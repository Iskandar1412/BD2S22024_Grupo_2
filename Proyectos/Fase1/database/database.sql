CREATE DATABASE Proyecto1F1;
USE Proyecto1F1;

-- Paises
CREATE TABLE Country (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    iso_code NVARCHAR(20)  -- Código ISO del país
);

-- Artistas
CREATE TABLE Artist (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    sort_name NVARCHAR(255),  -- Apellido, Nombre
    begin_date DATE,
    end_date DATE,
    type NVARCHAR(200),  -- 'Person' o 'Group'
    gender NVARCHAR(80),  -- 'Male', 'Female', etc.
    country_id INT,
    area NVARCHAR(255),  -- Área geográfica del artista
    description NVARCHAR(MAX),
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Créditos de Artista (colaboraciones)
CREATE TABLE ArtistCredit (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) -- Nombre del crédito colaborativo
);

-- Detalle de créditos de artista (relación entre Artist y ArtistCredit)
CREATE TABLE ArtistCreditName (
    artist_credit_id INT,
    artist_id INT,
    position INT,  -- Posición de los artistas en el crédito colaborativo
    PRIMARY KEY (artist_credit_id, artist_id),
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Albums
CREATE TABLE Album (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    release_date DATE,
    artist_id INT,  -- Clave foránea hacia Artist
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Grabaciones
CREATE TABLE Recording (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    length TIME,  -- Duración de la grabación
    artist_credit_id INT,  -- Clave foránea hacia ArtistCredit
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id)
);

-- Traks (modificada)
CREATE TABLE Track (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),
    duration TIME,
    album_id INT,  -- Clave foránea hacia Album
    recording_id INT,  -- Clave foránea hacia Recording
    rating FLOAT DEFAULT 0.0,  -- Puntuación de la canción (punteo de estrellas)
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (recording_id) REFERENCES Recording(id)
);

-- Género
CREATE TABLE Genre (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200)
);

-- Relación Artista - Género
CREATE TABLE ArtistGenre (
    artist_id INT,
    genre_id INT,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Relación Canción - Género
CREATE TABLE TrackGenre (
    track_id INT,
    genre_id INT,
    PRIMARY KEY (track_id, genre_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Alias de Artista
CREATE TABLE ArtistAlias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    artist_id INT,  -- Clave foránea hacia Artist
    alias NVARCHAR(255),  -- Alias o nombre alternativo
    sort_name NVARCHAR(255),  -- Nombre para ordenación
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Sellos
CREATE TABLE Label (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255),
    country_id INT,  -- Clave foránea hacia Country
    established_date DATE,
    description NVARCHAR(MAX),
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Relación Album - Sello
CREATE TABLE AlbumLabel (
    album_id INT,
    label_id INT,
    PRIMARY KEY (album_id, label_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (label_id) REFERENCES Label(id)
);

-- Derechos de Autor
CREATE TABLE Copyright (
    id INT IDENTITY(1,1) PRIMARY KEY,
    copyright_holder NVARCHAR(255),  -- Quién posee los derechos
    copyright_year INT,  -- Año del derecho de autor
    copyright_notice NVARCHAR(MAX),  -- Aviso de copyright
    type NVARCHAR(80)  -- Tipo: 'Song' o 'Album'
);

-- Derechos de Autor en Album
CREATE TABLE AlbumCopyright (
    album_id INT,
    copyright_id INT,
    PRIMARY KEY (album_id, copyright_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (copyright_id) REFERENCES Copyright(id)
);

-- Derechos de Autor en Canción
CREATE TABLE TrackCopyright (
    track_id INT,
    copyright_id INT,
    PRIMARY KEY (track_id, copyright_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (copyright_id) REFERENCES Copyright(id)
);

-- Puntuación de Canciones
CREATE TABLE Rating (
    id INT IDENTITY(1,1) PRIMARY KEY,
    track_id INT,  -- Clave foránea hacia la canción
    user_id INT,   -- Clave foránea hacia el usuario que califica
    rating INT CHECK (rating BETWEEN 1 AND 5),  -- Puntuación de 1 a 5 estrellas
    FOREIGN KEY (track_id) REFERENCES Track(id)
);

-- Etiquetas
CREATE TABLE Tag (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200)
);

-- Relación Artista - Etiqueta
CREATE TABLE ArtistTag (
    artist_id INT,
    tag_id INT,
    PRIMARY KEY (artist_id, tag_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Relación Album - Etiqueta
CREATE TABLE AlbumTag (
    album_id INT,
    tag_id INT,
    PRIMARY KEY (album_id, tag_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Relación Canción - Etiqueta
CREATE TABLE TrackTag (
    track_id INT,
    tag_id INT,
    PRIMARY KEY (track_id, tag_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Lanzamientos
CREATE TABLE Release (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),  -- Título del lanzamiento
    release_group_id INT,  -- Clave foránea hacia ReleaseGroup
    artist_credit_id INT,  -- Clave foránea hacia ArtistCredit
    release_date DATE,     -- Fecha de lanzamiento
    label_id INT,              -- Clave foránea hacia Label
    country_id INT,            -- Clave foránea hacia Country
    FOREIGN KEY (release_group_id) REFERENCES ReleaseGroup(id),
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id),
    FOREIGN KEY (label_id) REFERENCES Label(id),
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Grupo de Lanzamientos
CREATE TABLE ReleaseGroup (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255),  -- Título del grupo de lanzamiento
    artist_credit_id INT, -- Clave foránea hacia ArtistCredit
    type NVARCHAR(200),   -- Tipo de grupo (Álbum, EP, Single, etc.)
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id)
);

-- Medio (para almacenar formatos como CD, vinilo, digital, etc.)
CREATE TABLE Medium (
    id INT IDENTITY(1,1) PRIMARY KEY,
    release_id INT,         -- Clave foránea hacia Release
    format NVARCHAR(200),   -- Formato del medio (CD, Vinilo, Digital, etc.)
    position INT,               -- Posición del medio dentro del lanzamiento (CD1, CD2, etc.)
    FOREIGN KEY (release_id) REFERENCES Release(id)
);
