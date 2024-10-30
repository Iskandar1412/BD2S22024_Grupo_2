const { MongoClient } = require('mongodb');
const { Client } = require('pg');
const { performance } = require('perf_hooks');

async function migrate() {
  // Conexión a MongoDB
  const mongoClient = new MongoClient('mongodb://localhost:27017', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  await mongoClient.connect();
  const db = mongoClient.db('mongoMusicBrainz');

  // Conexión a PostgreSQL
  const pgClient = new Client({
    user: 'postgres',
    host: '172.17.144.27',
    database: 'musicbrainz',
    password: 'kmilo0289',
    port: 5432,
  });
  await pgClient.connect();

  // Definir el tamaño del lote
  const batchSize = 10000;

  try {
    console.log("Inicio de la migración...");
    async function getDataPaises(lanzamientoIds){
      const lanzamientoResult = await pgClient.query(`
        select l2.id,l2.id_lanzamiento as id_lugar,l2.mes,l2.anio,l2.dia,l3.nombre as nombre_lugar from lanzamientos l
        inner join lugarlanzamiento l2 on l2.id_lanzamiento = l.id
        inner join lugar l3 on l3.id = l2.id_lugar
        where l.id = ANY($1);
      `, [lanzamientoIds]);
      
      const lugaresMap = {};
      lanzamientoResult.rows.forEach(lanzamiento => {
        if (!lugaresMap[lanzamiento.id_lugar]) {
          lugaresMap[lanzamiento.id_lugar] = [];
        }
        lugaresMap[lanzamiento.id_lugar].push({
          nombre: lanzamiento.nombre_lugar,
          fecha: {
            año: lanzamiento.anio,
            mes: lanzamiento.mes,
            dia: lanzamiento.dia,
          },
        });
      });
      return lugaresMap;
    }

    // Función para obtener los tags del lanzamiento
    async function getTagLanzamiento(lanzamientoId){
      const lanzamientoResult = await pgClient.query(`
        select t.id as tag_id,l.id as id_lanzamiento,t.nombre as tag_lanzamiento,l.nombre as nombre_taglanzamiento from taglanzamientos tl
        inner join tags t on tl.id_tag = t.id
        inner join lanzamientos l on l.id = tl.id_release 
        where tl.id_release = ANY($1);
      `, [lanzamientoId]);

      const tagMap = {};
      lanzamientoResult.rows.forEach(lanzamiento => {
        if (!tagMap[lanzamiento.tag_id]) {
          tagMap[lanzamiento.tag_id] = [];
        }
        tagMap[lanzamiento.tag_id].push({
          nombre:lanzamiento.tag_lanzamiento,
        });
      });
      return tagMap;

    }

    // Función para la información de lanzamientos
    async function getLanzamientoData(trackIds) {
      const lanzamientoResult = await pgClient.query(`
        select distinct t.id as track_id,l.*,l2.nombre as lenguaje_lanzamiento,c.catalogo as catalogo_lanzamiento,l3.descripcion as label_lanzamiento from track t
        inner join medio m on t.id_medio = m.id 
        inner join lanzamientos l on m.release_id = l.id
        inner join lenguaje l2 on l2.id = l.lenguaje
        inner join catalogolanzamientos c on c.id_lanzamiento = l.id 
        inner join labellanzamientos l3 on l3.id_lanzamiento = l.id 
        where t.id = ANY($1);
      `, [trackIds]);

      const lanzamientoId = lanzamientoResult.rows.map(lanzamiento => lanzamiento.id);
      const lugaresMap = await getDataPaises(lanzamientoId);
      const tagMap = await getTagLanzamiento(lanzamientoId);

      const lanzamientoMap = {};
      lanzamientoResult.rows.forEach(lanzamiento => {
        if (!lanzamientoMap[lanzamiento.track_id]) {
          lanzamientoMap[lanzamiento.track_id] = [];
        }
        lanzamientoMap[lanzamiento.track_id].push({
          pg_id: lanzamiento.id,
          titulo: lanzamiento.nombre,
          cod_barra: lanzamiento.cod_barra,
          lenguaje: lanzamiento.lenguaje_lanzamiento,
          catalogo: lanzamiento.catalogo_lanzamiento,
          label: lanzamiento.label_lanzamiento,
          lugares:lugaresMap[lanzamiento.id] || [],
          tags: tagMap[lanzamiento.id] || []
        });
      });

      return lanzamientoMap; // Retornar los álbumes agrupados por artista
    }


    // Función para manejar la migración por lotes de PostgreSQL a MongoDB
    async function migrateInBatches(query, mongoCollection) {
      let offset = 0;
      let hasMoreRows = true;

      while (hasMoreRows) {
        const start = performance.now();

        // Obtener el lote de datos desde PostgreSQL
        const result = await pgClient.query(`${query} LIMIT ${batchSize} OFFSET ${offset}`);
        const rows = result.rows;

        if (rows.length === 0) {
          hasMoreRows = false;
          break;
        }
        //Obtención de ids de tracks
        const trackId = rows.map(row => row.id);

        //Obtención información de lanzamiento
        const lanzamientoMap = await getLanzamientoData(trackId);

        // Transformar y preparar el lote de datos para insertar en MongoDB
        const batchData = rows.map(cancion => ({
          pg_id: cancion.id,
          nombre: cancion.nombre,
          duracion: cancion.duracion,
          artista: cancion.nombre_artista,
          formato: cancion.formato_cancion,
          lanzamiento: lanzamientoMap[cancion.id] || [],
        }));

        // Inserción en MongoDB usando insertMany para mejor rendimiento
        if (batchData.length > 0) {
          await mongoCollection.insertMany(batchData);
        }

        const end = performance.now();
        console.log(`Migrado lote desde el offset ${offset} con ${rows.length} registros en ${(end - start) / 1000} segundos.`);

        // Incrementar el offset para el siguiente lote
        offset += batchSize;
      }
    }

    await migrateInBatches(
      `select distinct t.id,t.nombre,m.formato as formato_cancion,l.id as id_lanzamiento,a.nombre as nombre_artista,t.duracion from track t
        inner join artistacredit a on a.id_artista_credito = t.id_creditos
        inner join medio m on t.id_medio = m.id 
        inner join lanzamientos l on m.release_id = l.id`,
      db.collection('canciones')
    );

    console.log('Migración desnormalizada completa.');
  } finally {
    await pgClient.end();
    await mongoClient.close();
  }
}

migrate().catch(console.error);
