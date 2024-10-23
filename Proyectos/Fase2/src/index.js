const { MongoClient } = require('mongodb');
const { Client } = require('pg');
const { performance } = require('perf_hooks');

async function migrate() {
  // Conexión a MongoDB
  const mongoClient = new MongoClient('mongodb://localhost:27017');
  await mongoClient.connect();
  const db = mongoClient.db('mongoMusicBrainz'); // Nombre de la base de datos en MongoDB

  // Conexión a PostgreSQL
  const pgClient = new Client({
    user: 'postgres',
    host: 'localhost',
    database: 'fase1',  // Nombre de tu base de datos PostgreSQL
    password: 'abc123**',
    port: 5432,
  });
  await pgClient.connect();

  // Definir el tamaño del lote
  const batchSize = 100000; // Tamaño del lote de inserción

  try {
    console.log("Inicio de la migración...");

    // Obtener todos los álbumes de un conjunto de artistas
    async function getAlbumsForArtists(artistIds) {
      const albumsResult = await pgClient.query(`
        SELECT d.*, a.id AS artist_id
        FROM discografia d
        JOIN artistacredit ac ON d.creditos = ac.id_artista_credito
        JOIN nombreartistacredito n ON ac.id_artista_credito = n.id_artista_credito
        JOIN artista a ON n.id_artista = a.id
        WHERE a.id = ANY($1)
        AND d.tipo = 1;
      `, [artistIds]);

      const albumsMap = {};
      albumsResult.rows.forEach(album => {
        if (!albumsMap[album.artist_id]) {
          albumsMap[album.artist_id] = [];
        }
        albumsMap[album.artist_id].push({

          titulo: album.titulo,
          rating: album.rating,
          num_calificaciones: album.num_calificaciones,
          num_lanzamientos: album.num_lanzamientos,
          fecha_salida: {
            anio: album.anio_salida,
            mes: album.mes_salida,
            dia: album.dia_salida,
          }
        });
      });

      return albumsMap; // Retornar los álbumes agrupados por artista
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

        // Obtener IDs de los artistas en este lote
        const artistIds = rows.map(row => row.id);

        // Obtener los álbumes de los artistas en este lote
        const albumsMap = await getAlbumsForArtists(artistIds);

        // Transformar y preparar el lote de datos para insertar en MongoDB
        const batchData = rows.map(artist => ({
          nombre: artist.nombre,
          comentario: artist.comentario,
          tipo: {
     
            nombre: artist.tipo_nombre,
          },
          genero: {
        
            nombre: artist.genero_nombre,
          },
          lugar: {
 
            nombre: artist.lugar_nombre,
          },
          inicio: {
            anio: artist.anio_inicio,
            mes: artist.mes_inicio,
            dia: artist.dia_inicio,
          },
          fin: {
            anio: artist.anio_final,
            mes: artist.mes_final,
            dia: artist.dia_final,
          },
          discografia: albumsMap[artist.id] || [], // Asocia los álbumes correspondientes
        }));

        // Inserción en MongoDB usando insertMany para mejor rendimiento
        await mongoCollection.insertMany(batchData);

        const end = performance.now();
        // console.log("id: ", artistIds);
        console.log(`Migrado lote desde el offset ${offset} con ${rows.length} registros en ${(end - start) / 1000} segundos.`);

        // Incrementar el offset para el siguiente lote
        offset += batchSize;
      }
    }

    // Migrar artistas con sus álbumes
    await migrateInBatches(
      `SELECT a.*, t.nombre AS tipo_nombre, g.genero AS genero_nombre, l.nombre AS lugar_nombre
       FROM Artista a
       LEFT JOIN TipoArtista t ON a.tipo = t.id
       LEFT JOIN Genero g ON a.genero = g.id
       LEFT JOIN lugar l ON a.id_lugar = l.id`,
      db.collection('artistas')
    );

    console.log('Migración desnormalizada completa.');
  } finally {
    await pgClient.end();
    await mongoClient.close();
  }
}

migrate().catch(console.error);
