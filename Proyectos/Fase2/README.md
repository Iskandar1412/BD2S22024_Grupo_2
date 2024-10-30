# Documentacion

## Artista `index.js`

### Descripción General

Este archivo es un script de migración que extrae información sobre artistas, géneros, lugares, álbumes y canciones desde una base de datos PostgreSQL y la inserta en una base de datos MongoDB. Este proceso se realiza en lotes para optimizar la migración de un volumen grande de datos, con una serie de funciones auxiliares para extraer, transformar y enriquecer los datos antes de insertarlos.


### Código

#### Importación de módulos

```js
const { MongoClient } = require('mongodb');
const { Client } = require('pg');
const { performance } = require('perf_hooks');
```

* `MongoClient:` Se utiliza para la conexión e interacción con MongoDB.
* `Client:` Permite la conexión e interacción con PostgreSQL.
* `performance:` Se usa para medir el tiempo de ejecución de cada lote de migración.


#### Función Principal migrate

Esta función se encarga de conectar ambas bases de datos, configurar los parámetros de migración por lotes y coordinar el proceso de migración.

```js
async function migrate() { ... }
```

* Conexión a MongoDB


```js
const mongoClient = new MongoClient('mongodb://localhost:27017', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
await mongoClient.connect();
const db = mongoClient.db('mongoMusicBrainz');
```

> Establece una conexión con la base de datos MongoDB en localhost y selecciona la base de datos mongoMusicBrainz.

* Conexión a PostgreSQL

```js
const pgClient = new Client({
    user: 'postgres',
  host: 'localhost',
  database: 'fase1',
  password: 'abc123**',
  port: 5432,
});
await pgClient.connect();
```

> Conecta a PostgreSQL con las credenciales y base de datos especificadas.

#### Tamaño de Lote

```js
const batchSize = 10000;
```

Define el tamaño de cada lote para la migración, lo cual ayuda a controlar el consumo de memoria y tiempos de respuesta.

#### Funciones Auxiliares de Extracción de Datos

Cada función auxiliar se encarga de extraer datos específicos desde PostgreSQL.

* getGenresForArtists

Obtiene los géneros asociados a un conjunto de artistas.

```js
async function getGenresForArtists(artistIds) { ... }
```

> Recibe un arreglo de IDs de artistas y devuelve un mapa de géneros asociados por ID de artista.

* getTagsForArtists

Obtiene los tags (etiquetas) asociados a un conjunto de artistas.

```js
async function getTagsForArtists(artistIds) { ... }
```
Similar a getGenresForArtists, pero devuelve un mapa de tags por artista.

* getPlacesForArtists

Extrae y asocia los lugares relevantes (inicio, final, y lugar de origen) para los artistas.

```js
async function getPlacesForArtists(artistRows) { ... }
```

Recibe filas de artistas y devuelve un mapa de nombres de lugares.

* getSongsForAlbums

Recupera las canciones de un conjunto de álbumes.

```js
async function getSongsForAlbums(albumIds) { ... }
```

Devuelve un mapa de canciones agrupadas por ID de álbum, incluyendo detalles de cada canción.

* getAlbumsForArtists

Obtiene los álbumes de un conjunto de artistas, incluyendo información de canciones asociadas.

```js
async function getAlbumsForArtists(artistIds) { ... }
```

Devuelve un mapa de álbumes con sus canciones asociadas, agrupados por ID de artista.

#### Función `migrateInBatches`

Esta función organiza el proceso de migración en lotes, limitando el número de filas migradas en cada iteración.

```js
async function migrateInBatches(query, mongoCollection) { ... }
```

* Parámetros:
    * `query`: Consulta SQL base para seleccionar los datos de artistas.
    * `mongoCollection`: Colección de MongoDB en la que se insertarán los datos.
* Flujo:
    * `Inicialización`: Define el offset inicial y marca hasMoreRows como true.
    * `Bucle de Lotes`: Ejecuta la consulta SQL para obtener un conjunto de artistas.
    * `Extracción de Datos Asociados`: Llama a las funciones auxiliares para enriquecer los datos con tags, álbumes, canciones y lugares.
    * `Transformación y Envío a MongoDB`: Mapea los datos de artistas y los inserta en MongoDB.
    * `Medición de Tiempo`: Calcula y muestra en consola el tiempo de migración para cada lote.

#### Ejecución de la Migración Completa

```js
await migrateInBatches(
  `SELECT a.*, t.nombre AS tipo_nombre, g.genero AS genero_nombre, l.nombre AS lugar_nombre
   FROM Artista a
   LEFT JOIN TipoArtista t ON a.tipo = t.id
   LEFT JOIN Genero g ON a.genero = g.id
   LEFT JOIN lugar l ON a.id_lugar = l.id`,
  db.collection('artistas')
);
```

Este comando realiza la migración, invocando migrateInBatches con una consulta SQL que selecciona datos enriquecidos de los artistas y especificando la colección artistas en MongoDB como destino.

#### Cierre de Conexiones

```js
await pgClient.end();
await mongoClient.close();
```

Cierra las conexiones a PostgreSQL y MongoDB al finalizar la migración.

#### Ejecución de la Función `migrate`

```js
migrate().catch(console.error);
```

Inicia el proceso de migración y captura cualquier error que ocurra durante la ejecución, mostrando un mensaje de error en consola.

-----------------------------------------------------

## Canciones `canciones.js`
### Descripción General

Este archivo es un script de migración de datos que transfiere información de canciones y lanzamientos desde una base de datos PostgreSQL a una base de datos MongoDB. Extrae detalles sobre las canciones, los lanzamientos asociados, los países y etiquetas de lanzamiento, y los inserta en MongoDB de manera desnormalizada. El proceso de migración se realiza en lotes para manejar grandes volúmenes de datos de forma eficiente.

### Código

#### Importación de Módulos

```js
const { MongoClient } = require('mongodb');
const { Client } = require('pg');
const { performance } = require('perf_hooks');
```

* `MongoClient`: Permite la conexión e interacción con MongoDB.
* `Client`: Facilita la conexión e interacción con PostgreSQL.
* `performance`: Se usa para medir el tiempo de ejecución de cada lote de migración.

#### Función Principal `migrate`

La función migrate se encarga de establecer las conexiones con ambas bases de datos, definir el tamaño de los lotes, y coordinar el proceso de migración.

```js
async function migrate() { ... }
```

#### Conexión a MongoDB

```js
const mongoClient = new MongoClient('mongodb://localhost:27017', {
    useNewUrlParser: true,
  useUnifiedTopology: true,
});
await mongoClient.connect();
const db = mongoClient.db('mongoMusicBrainz');
```

Establece una conexión con MongoDB y selecciona la base de datos mongoMusicBrainz.

#### Conexión a PostgreSQL

```js
const pgClient = new Client({
  user: 'postgres',
  host: '172.17.144.27',
  database: 'musicbrainz',
  password: 'kmilo0289',
  port: 5432,
});
await pgClient.connect();
```

Conecta a PostgreSQL en el servidor y base de datos especificados.

#### Tamaño de Lote

```js
const batchSize = 10000;
```

Define el tamaño de cada lote para la migración, controlando así el rendimiento y consumo de memoria.

#### Funciones Auxiliares de Extracción de Datos

Cada función auxiliar extrae datos específicos de PostgreSQL y los transforma en el formato necesario para MongoDB.

* getDataPaises

Obtiene información de los países (lugares) donde se lanzó cada álbum.

```js
async function getDataPaises(lanzamientoIds) { ... }
```

Recibe un arreglo de IDs de lanzamientos y devuelve un mapa de lugares con fechas asociadas por lanzamiento.

* getTagLanzamiento

Obtiene las etiquetas (tags) asociadas a cada lanzamiento.

```js
async function getTagLanzamiento(lanzamientoId) { ... }
```

Devuelve un mapa de tags asociados a cada lanzamiento.

* getLanzamientoData

Extrae la información de lanzamientos, incluyendo lugar, idioma, catálogo y etiquetas.

```js
async function getLanzamientoData(trackIds) { ... }
```

* Llama a las funciones getDataPaises y getTagLanzamiento para enriquecer los datos de lanzamientos.
* Devuelve un mapa de lanzamientos con los datos enriquecidos, agrupado por ID de track.

#### Función `migrateInBatches`

Esta función organiza el proceso de migración en lotes, limitando el número de registros migrados en cada iteración.

```js
async function migrateInBatches(query, mongoCollection) { ... }
```

* Parámetros:

    * `query`: Consulta SQL base para seleccionar los datos de canciones.
    * `mongoCollection`: Colección de MongoDB en la que se insertarán los datos.
* Flujo:

    * `Inicialización`: Define el offset inicial y marca hasMoreRows como true.
    * `Bucle de Lotes`: Ejecuta la consulta SQL para obtener un conjunto de canciones.
    * `Extracción de Datos Asociados`: Llama a getLanzamientoData para obtener información de lanzamientos enriquecida.
    * `Transformación y Envío a MongoDB`: Mapea los datos de canciones y los inserta en MongoDB.
    * `Medición de Tiempo`: Calcula y muestra en consola el tiempo de migración para cada lote.

#### Ejecución de la Migración Completa

```js
await migrateInBatches(
  `select distinct t.id, t.nombre, m.formato as formato_cancion, l.id as id_lanzamiento, a.nombre as nombre_artista, t.duracion
   from track t
   inner join artistacredit a on a.id_artista_credito = t.id_creditos
   inner join medio m on t.id_medio = m.id
   inner join lanzamientos l on m.release_id = l.id`,
  db.collection('canciones')
);
```

Este comando ejecuta la migración llamando a migrateInBatches con una consulta SQL para seleccionar datos de canciones, y especifica canciones como la colección de destino en MongoDB.

#### Cierre de Conexiones

```js
await pgClient.end();
await mongoClient.close();
```

Cierra las conexiones a PostgreSQL y MongoDB al finalizar la migración.

#### Ejecución de la Función migrate

```js
migrate().catch(console.error);
```

Inicia el proceso de migración y captura cualquier error que ocurra durante la ejecución, mostrando un mensaje de error en consola.

---------------------------------------------

## Discografias `discografia.js`

### Descripción General

Este archivo es un script de migración que transfiere datos de discografías y sus detalles asociados (canciones, etiquetas, sellos discográficos y lanzamientos) desde una base de datos PostgreSQL a una base de datos MongoDB. La migración se realiza en lotes para optimizar el manejo de grandes volúmenes de datos y mejorar la eficiencia.

### Código

#### Importación de Módulos

```js
const { MongoClient } = require('mongodb');
const { Client } = require('pg');
const { performance } = require('perf_hooks');
```

* `MongoClient`: Permite la conexión e interacción con MongoDB.
* `Client`: Facilita la conexión e interacción con PostgreSQL.
* `performance`: Mide el tiempo de ejecución de cada lote de migración.

#### Función Principal `migrate`

La función migrate establece las conexiones con ambas bases de datos, configura el tamaño del lote y coordina la migración.

```js
async function migrate() { ... }
```

* Conexión a MongoDB

```js
const mongoClient = new MongoClient('mongodb://localhost:27017', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
});
await mongoClient.connect();
const db = mongoClient.db('mongoMusicBrainz');
```

Conecta a MongoDB y selecciona la base de datos mongoMusicBrainz.

* Conexión a PostgreSQL

```js
const pgClient = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'proyecto',
  password: 'super',
  port: 5432,
});
await pgClient.connect();
```

Conecta a PostgreSQL en localhost utilizando las credenciales y base de datos proporcionadas.

* Tamaño de Lote

```js
const batchSize = 10000;
```

Define el tamaño del lote para controlar el rendimiento y consumo de memoria durante la migración.

#### Funciones Auxiliares de Extracción de Datos

Cada función auxiliar extrae y organiza información específica de PostgreSQL.

* getAlbumsDetails

Obtiene los detalles de álbumes específicos como el nombre del artista, tipo, título, fecha de salida y número de lanzamientos.

```js
async function getAlbumsDetails(albumIds) { ... }
```

> Recibe un arreglo de IDs de álbumes y devuelve un mapa de detalles de álbumes, donde la clave es el ID del álbum.

* getSongsForAlbums

Obtiene las canciones asociadas a un conjunto de álbumes.

```js
async function getSongsForAlbums(albumIds) { ... }
```

> Devuelve un mapa de canciones por ID de álbum, con detalles de cada canción como nombre y duración.

* getTagsForAlbums

Extrae las etiquetas (tags) asociadas a un conjunto de álbumes.

```js
async function getTagsForAlbums(albumIds) { ... }
```

> Devuelve un mapa de tags por ID de álbum.

* getLabelsForAlbums

Obtiene información de sellos discográficos (labels) asociados a un conjunto de álbumes, incluyendo código de barras y año de lanzamiento.

```js
async function getLabelsForAlbums(albumIds) { ... }
```

> Devuelve un mapa de etiquetas de lanzamiento por ID de álbum.

#### Función `migrateInBatches`

Esta función organiza el proceso de migración en lotes, limitando el número de registros migrados en cada iteración.

```js
async function migrateInBatches(query, mongoCollection) { ... }
```

* Parámetros:
    * `query`: Consulta SQL base para seleccionar los datos de discografía.
    * `mongoCollection`: Colección de MongoDB donde se insertarán los datos.
* Flujo:
    * `Inicialización`: Define offset y marca hasMoreRows como true.
    * `Bucle de Lotes`: Ejecuta la consulta SQL para obtener datos de artistas relacionados con discografías.
    * `Extracción de Datos Asociados`: Obtiene los detalles de álbumes, canciones, etiquetas y sellos discográficos a través de funciones auxiliares.
    * `Transformación y Inserción`: Estructura y organiza los datos en formato JSON y los inserta en MongoDB.
    * `Medición de Tiempo`: Calcula y muestra el tiempo de migración para cada lote en consola.

#### Ejecución de la Migración Completa

```js
await migrateInBatches(
  `SELECT a.*, t.nombre AS tipo_nombre, g.genero AS genero_nombre, l.nombre AS lugar_nombre
   FROM Artista a
   LEFT JOIN TipoArtista t ON a.tipo = t.id
   LEFT JOIN Genero g ON a.genero = g.id
   LEFT JOIN lugar l ON a.id_lugar = l.id`,
  db.collection('discografias')
);
```

Este comando inicia la migración, ejecutando migrateInBatches con una consulta SQL que selecciona datos enriquecidos de artistas relacionados con discografía, y especifica discografias como la colección de destino en MongoDB.

#### Cierre de Conexiones

```js
await pgClient.end();
await mongoClient.close();
```

Cierra las conexiones a PostgreSQL y MongoDB al finalizar la migración.

#### Ejecución de la Función `migrate`

```js
migrate().catch(console.error);
```

Inicia el proceso de migración y captura cualquier error que ocurra durante la ejecución, mostrando un mensaje de error en consola.

