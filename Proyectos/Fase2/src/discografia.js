const { MongoClient } = require('mongodb');
const { Client } = require('pg');
const { performance } = require('perf_hooks');

async function migrate() {
  const mongoClient = new MongoClient('mongodb://localhost:27017', {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  });
  await mongoClient.connect();
  const db = mongoClient.db('mongoMusicBrainz');

  const pgClient = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'proyecto',
    password: 'super',
    port: 5432,
  });
  await pgClient.connect();

  const batchSize = 10000;

  try {
    console.log("Inicio de la migración...");

    async function getAlbumsDetails(albumIds) {
      const albumsResult = await pgClient.query(`
        SELECT 
          a.id AS artista_id, 
          a.nombre AS nombre_artista,
          t.nombre AS tipo, 
          d.titulo, 
          CONCAT(d.dia_salida, '/', d.mes_salida, '/', d.anio_salida) AS fecha_salida, 
          d.num_lanzamientos, 
          d.id AS discografia_id
        FROM discografia d
        JOIN artistacredit ac ON d.creditos = ac.id_artista_credito
        JOIN nombreartistacredito n ON ac.id_artista_credito = n.id_artista_credito
        JOIN artista a ON n.id_artista = a.id
        JOIN tipogrupo t ON t.id = d.tipo
        WHERE d.id = ANY($1)
      `, [albumIds]);

      const albumsMap = {};
      albumsResult.rows.forEach(album => {
        albumsMap[album.discografia_id] = {
          artista_id: album.artista_id,
          nombre_artista: album.nombre_artista,
          tipo: album.tipo,
          titulo: album.titulo,
          fecha_salida: album.fecha_salida,
          num_lanzamientos: album.num_lanzamientos
        };
      });
      return albumsMap;
    }

    async function getSongsForAlbums(albumIds) {
      const songsResult = await pgClient.query(`
        SELECT t.id AS track_id, t.nombre AS cancion, t.duracion, d.id AS discografia_id 
        FROM discografia d 
        INNER JOIN lanzamientos l ON d.id = l.grupo_disc 
        INNER JOIN medio m ON l.id = m.release_id 
        INNER JOIN track t ON m.id = t.id_medio 
        WHERE d.id = ANY($1)
      `, [albumIds]);

      const songsMap = {};
      songsResult.rows.forEach(song => {
        if (!songsMap[song.discografia_id]) {
          songsMap[song.discografia_id] = [];
        }
        songsMap[song.discografia_id].push({
          track_id: song.track_id,
          nombre: song.cancion,
          duracion: song.duracion
        });
      });
      return songsMap;
    }

    async function getTagsForAlbums(albumIds) {
      const tagsResult = await pgClient.query(`
        SELECT d.id AS discografia_id, t2.nombre AS tag
        FROM discografia d 
        INNER JOIN tagsdisc t ON d.id = t.id_disc 
        INNER JOIN tags t2 ON t2.id = t.tag_id 
        WHERE d.id = ANY($1)
      `, [albumIds]);

      const tagsMap = {};
      tagsResult.rows.forEach(tag => {
        if (!tagsMap[tag.discografia_id]) {
          tagsMap[tag.discografia_id] = [];
        }
        tagsMap[tag.discografia_id].push(tag.tag);
      });
      return tagsMap;
    }

    async function getLabelsForAlbums(albumIds) {
      const labelsResult = await pgClient.query(`
        SELECT d.id AS discografia_id, l.cod_barra AS codigo_barras, l2.descripcion AS label, l3.anio AS anio_lanzamiento
        FROM discografia d 
        INNER JOIN lanzamientos l ON l.grupo_disc = d.id 
        INNER JOIN labellanzamientos l2 ON l2.id_lanzamiento = l.id 
        JOIN lugarlanzamiento l3 ON l3.id_lanzamiento = l.id 
        WHERE d.id = ANY($1)
      `, [albumIds]);

      const labelsMap = {};
      labelsResult.rows.forEach(label => {
        if (!labelsMap[label.discografia_id]) {
          labelsMap[label.discografia_id] = [];
        }
        labelsMap[label.discografia_id].push({
          codigo_barras: label.codigo_barras,
          descripcion: label.label,
          anio_lanzamiento: label.anio_lanzamiento
        });
      });
      return labelsMap;
    }

    async function migrateInBatches(query, mongoCollection) {
      let offset = 0;
      let hasMoreRows = true;

      while (hasMoreRows) {
        const start = performance.now();

        const result = await pgClient.query(`${query} LIMIT ${batchSize} OFFSET ${offset}`);
        const rows = result.rows;

        if (rows.length === 0) {
          hasMoreRows = false;
          break;
        }

        const artistIds = rows.map(row => row.id);
        const albumsResult = await pgClient.query(`
          SELECT d.id
          FROM discografia d
          JOIN artistacredit ac ON d.creditos = ac.id_artista_credito
          JOIN nombreartistacredito n ON ac.id_artista_credito = n.id_artista_credito
          JOIN artista a ON n.id_artista = a.id
          WHERE a.id = ANY($1)
        `, [artistIds]);

        const albumIds = albumsResult.rows.map(row => row.id);
        const albumsMap = await getAlbumsDetails(albumIds);
        const songsMap = await getSongsForAlbums(albumIds);
        const tagsMap = await getTagsForAlbums(albumIds);
        const labelsMap = await getLabelsForAlbums(albumIds);

        const discographyData = albumIds.map(id => ({
          ...albumsMap[id],
          canciones: songsMap[id] || [],
          tags: tagsMap[id] || [],
          labels: labelsMap[id] || []
        }));

        await mongoCollection.insertMany(discographyData);

        const end = performance.now();
        console.log(`Migrado lote desde el offset ${offset} con ${rows.length} registros en ${(end - start) / 1000} segundos.`);

        offset += batchSize;
      }
    }

    await migrateInBatches(
      `SELECT a.*, t.nombre AS tipo_nombre, g.genero AS genero_nombre, l.nombre AS lugar_nombre
       FROM Artista a
       LEFT JOIN TipoArtista t ON a.tipo = t.id
       LEFT JOIN Genero g ON a.genero = g.id
       LEFT JOIN lugar l ON a.id_lugar = l.id`,
      db.collection('discografias')
    );

    console.log('Migración completa.');
  } finally {
    await pgClient.end();
    await mongoClient.close();
  }
}

migrate().catch(console.error);
