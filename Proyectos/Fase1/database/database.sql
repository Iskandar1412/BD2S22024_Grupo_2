CREATE DATABASE Proyecto1F1;
USE Proyecto1F1;

-- Paises
CREATE TABLE Country (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    iso_code NVARCHAR(10) NULL  -- Código ISO del país
);

-- Artistas
CREATE TABLE Artist (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    sort_name NVARCHAR(255) NOT NULL,  -- Apellido, Nombre
    begin_date DATE NULL,
    end_date DATE NULL,
    type NVARCHAR(100) NULL,  -- 'Person' o 'Group'
    gender NVARCHAR(50) NULL,  -- 'Male', 'Female', etc.
    country_id INT NULL,
    area NVARCHAR(255) NULL,  -- Área geográfica del artista
    description NVARCHAR(MAX) NULL,
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Créditos de Artista (colaboraciones)
CREATE TABLE ArtistCredit (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL -- Nombre del crédito colaborativo
);

-- Detalle de créditos de artista (relación entre Artist y ArtistCredit)
CREATE TABLE ArtistCreditName (
    artist_credit_id INT NOT NULL,
    artist_id INT NOT NULL,
    position INT NULL,  -- Posición de los artistas en el crédito colaborativo
    PRIMARY KEY (artist_credit_id, artist_id),
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Albums
CREATE TABLE Album (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    release_date DATE,
    artist_id INT NOT NULL,  -- Clave foránea hacia Artist
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Grabaciones
CREATE TABLE Recording (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    length TIME NOT NULL,  -- Duración de la grabación
    artist_credit_id INT NOT NULL,  -- Clave foránea hacia ArtistCredit
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id)
);

-- Traks (modificada)
CREATE TABLE Track (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    duration TIME NOT NULL,
    album_id INT NOT NULL,  -- Clave foránea hacia Album
    recording_id INT NOT NULL,  -- Clave foránea hacia Recording
    rating FLOAT DEFAULT 0.0,  -- Puntuación de la canción (punteo de estrellas)
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (recording_id) REFERENCES Recording(id)
);

-- Género
CREATE TABLE Genre (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

-- Relación Artista - Género
CREATE TABLE ArtistGenre (
    artist_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Relación Canción - Género
CREATE TABLE TrackGenre (
    track_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (track_id, genre_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Alias de Artista
CREATE TABLE ArtistAlias (
    id INT IDENTITY(1,1) PRIMARY KEY,
    artist_id INT NOT NULL,  -- Clave foránea hacia Artist
    alias NVARCHAR(255) NOT NULL,  -- Alias o nombre alternativo
    sort_name NVARCHAR(255) NOT NULL,  -- Nombre para ordenación
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Sellos
CREATE TABLE Label (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(255) NOT NULL,
    country_id INT NULL,  -- Clave foránea hacia Country
    established_date DATE NULL,
    description NVARCHAR(MAX) NULL,
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Relación Album - Sello
CREATE TABLE AlbumLabel (
    album_id INT NOT NULL,
    label_id INT NOT NULL,
    PRIMARY KEY (album_id, label_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (label_id) REFERENCES Label(id)
);

-- Derechos de Autor
CREATE TABLE Copyright (
    id INT IDENTITY(1,1) PRIMARY KEY,
    copyright_holder NVARCHAR(255) NOT NULL,  -- Quién posee los derechos
    copyright_year INT NOT NULL,  -- Año del derecho de autor
    copyright_notice NVARCHAR(MAX) NULL,  -- Aviso de copyright
    type NVARCHAR(50) NOT NULL  -- Tipo: 'Song' o 'Album'
);

-- Derechos de Autor en Album
CREATE TABLE AlbumCopyright (
    album_id INT NOT NULL,
    copyright_id INT NOT NULL,
    PRIMARY KEY (album_id, copyright_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (copyright_id) REFERENCES Copyright(id)
);

-- Derechos de Autor en Canción
CREATE TABLE TrackCopyright (
    track_id INT NOT NULL,
    copyright_id INT NOT NULL,
    PRIMARY KEY (track_id, copyright_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (copyright_id) REFERENCES Copyright(id)
);

-- Puntuación de Canciones
CREATE TABLE Rating (
    id INT IDENTITY(1,1) PRIMARY KEY,
    track_id INT NOT NULL,  -- Clave foránea hacia la canción
    user_id INT NOT NULL,   -- Clave foránea hacia el usuario que califica
    rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),  -- Puntuación de 1 a 5 estrellas
    FOREIGN KEY (track_id) REFERENCES Track(id)
);

-- Etiquetas
CREATE TABLE Tag (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

-- Relación Artista - Etiqueta
CREATE TABLE ArtistTag (
    artist_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (artist_id, tag_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Relación Album - Etiqueta
CREATE TABLE AlbumTag (
    album_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (album_id, tag_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Relación Canción - Etiqueta
CREATE TABLE TrackTag (
    track_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (track_id, tag_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Lanzamientos
CREATE TABLE Release (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,  -- Título del lanzamiento
    release_group_id INT NOT NULL,  -- Clave foránea hacia ReleaseGroup
    artist_credit_id INT NOT NULL,  -- Clave foránea hacia ArtistCredit
    release_date DATE NOT NULL,     -- Fecha de lanzamiento
    label_id INT NULL,              -- Clave foránea hacia Label
    country_id INT NULL,            -- Clave foránea hacia Country
    FOREIGN KEY (release_group_id) REFERENCES ReleaseGroup(id),
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id),
    FOREIGN KEY (label_id) REFERENCES Label(id),
    FOREIGN KEY (country_id) REFERENCES Country(id)
);

-- Grupo de Lanzamientos
CREATE TABLE ReleaseGroup (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,  -- Título del grupo de lanzamiento
    artist_credit_id INT NOT NULL, -- Clave foránea hacia ArtistCredit
    type NVARCHAR(100) NOT NULL,   -- Tipo de grupo (Álbum, EP, Single, etc.)
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistCredit(id)
);

-- Medio (para almacenar formatos como CD, vinilo, digital, etc.)
CREATE TABLE Medium (
    id INT IDENTITY(1,1) PRIMARY KEY,
    release_id INT NOT NULL,         -- Clave foránea hacia Release
    format NVARCHAR(100) NOT NULL,   -- Formato del medio (CD, Vinilo, Digital, etc.)
    position INT NULL,               -- Posición del medio dentro del lanzamiento (CD1, CD2, etc.)
    FOREIGN KEY (release_id) REFERENCES Release(id)
);
