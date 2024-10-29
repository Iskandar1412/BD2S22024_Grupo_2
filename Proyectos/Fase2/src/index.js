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
    host: 'localhost',
    database: 'fase1',
    password: 'abc123**',
    port: 5432,
  });
  await pgClient.connect();

  const batchSize = 10000;

  try {
    console.log("Inicio de la migración...");

    // Función para obtener los géneros de un conjunto de artistas
    async function getGenresForArtists(artistIds) {
      const genresResult = await pgClient.query(`
        SELECT ag.id, g.genero
        FROM artista ag
        JOIN genero g ON ag.genero = g.id
        WHERE ag.id = ANY($1);
      `, [artistIds]);

      const genresMap = {};
      genresResult.rows.forEach(row => {
        if (!genresMap[row.artist_id]) {
          genresMap[row.artist_id] = [];
        }
        genresMap[row.artist_id].push(row.genero);
      });

      return genresMap;
    }

    // Función para obtener los tags de un conjunto de artistas
    async function getTagsForArtists(artistIds) {
      const tagsResult = await pgClient.query(`
        SELECT at.artist_id, t.nombre AS tag
        FROM artistatag at
        JOIN tags t ON at.tag_id = t.id
        WHERE at.artist_id = ANY($1);
      `, [artistIds]);

      const tagsMap = {};
      tagsResult.rows.forEach(row => {
        if (!tagsMap[row.artist_id]) {
          tagsMap[row.artist_id] = [];
        }
        tagsMap[row.artist_id].push(row.tag);
      });

      return tagsMap;
    }

    // Función para obtener los nombres de lugar asociados a los IDs
    async function getPlacesForArtists(artistRows) {
      const placeIds = [
        ...new Set(
          artistRows.flatMap(row => [
            row.id_lugar,
            row.lugar_inicio,
            row.lugar_final,
          ])
        ),
      ].filter(Boolean);

      const placesResult = await pgClient.query(`
        SELECT id, nombre
        FROM lugar
        WHERE id = ANY($1);
      `, [placeIds]);

      const placesMap = {};
      placesResult.rows.forEach(place => {
        placesMap[place.id] = place.nombre;
      });

      return placesMap;
    }

    // Función para obtener las canciones de un álbum
    async function getSongsForAlbums(albumIds) {
      const songsResult = await pgClient.query(`
        SELECT distinct t.*, d.id AS album_id 
        FROM discografia d 
        INNER JOIN lanzamientos l ON d.id = l.grupo_disc 
        INNER JOIN medio m ON l.id = m.release_id 
        INNER JOIN track t ON m.id = t.id_medio 
        WHERE d.id = ANY($1);
      `, [albumIds]);

      const songsMap = {};
      songsResult.rows.forEach(song => {
        if (!songsMap[song.album_id]) {
          songsMap[song.album_id] = [];
        }
        songsMap[song.album_id].push({

          numero: song.numero,
          nombre: song.nombre,
          duracion: song.duracion,
        });
      });

      return songsMap;
    }

    // Función para obtener los álbumes de un conjunto de artistas
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

      const albumIds = albumsResult.rows.map(album => album.id);
      const songsMap = await getSongsForAlbums(albumIds);

      const albumsMap = {};
      albumsResult.rows.forEach(album => {
        if (!albumsMap[album.artist_id]) {
          albumsMap[album.artist_id] = [];
        }
        albumsMap[album.artist_id].push({
          pg_id: album.id,
          titulo: album.titulo,
          rating: album.rating,
          num_calificaciones: album.num_calificaciones,
          num_lanzamientos: album.num_lanzamientos,
          fecha_salida: {
            anio: album.anio_salida,
            mes: album.mes_salida,
            dia: album.dia_salida,
          },
          canciones: songsMap[album.id] || [], // Añadir las canciones al álbum
        });
      });

      return albumsMap;
    }

    // Función para manejar la migración por lotes de PostgreSQL a MongoDB
    async function migrateInBatches(query, mongoCollection) {
      let offset = 1930000;
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

        // const genresMap = await getGenresForArtists(artistIds);
        const tagsMap = await getTagsForArtists(artistIds);
        const albumsMap = await getAlbumsForArtists(artistIds);
        const placesMap = await getPlacesForArtists(rows);

        const batchData = rows.map(artist => ({
          pg_id: artist.id,
          nombre: artist.nombre,
          comentario: artist.comentario,
          tipo: {

            nombre: artist.tipo_nombre,
          },
          genero: {

            nombre: artist.genero_nombre,
          },
          lugar: {

            nombre: placesMap[artist.id_lugar] || null,
          },
          lugar_inicio: {

            nombre: placesMap[artist.lugar_inicio] || null,
          },
          lugar_final: {

            nombre: placesMap[artist.lugar_final] || null,
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
          discografia: albumsMap[artist.id] || [], // Asocia los álbumes con sus canciones correspondientes
          // generos_musicales: genresMap[artist.id] || [], // Agregar géneros musicales asociados
          generos_musicales: tagsMap[artist.id] || [] // Agregar tags del artista
        }));

        if (batchData.length > 0) {
          await mongoCollection.insertMany(batchData);
        }

        const end = performance.now();
        console.log(`Migrado lote desde el offset ${offset} con ${rows.length} registros en ${(end - start) / 1000} segundos.`);

        offset += batchSize;
      }
    }

    // Migrar artistas con sus álbumes, canciones, géneros, lugares, tipo de artista y tags
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
