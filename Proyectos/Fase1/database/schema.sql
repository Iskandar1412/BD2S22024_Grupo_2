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

-- Albums
CREATE TABLE Album (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    release_date DATE,
    artist_id INT NOT NULL,  -- Clave foránea hacia Artist
    FOREIGN KEY (artist_id) REFERENCES Artist(id)
);

-- Traks
CREATE TABLE Track (
    id INT IDENTITY(1,1) PRIMARY KEY,
    title NVARCHAR(255) NOT NULL,
    duration TIME NOT NULL,
    album_id INT NOT NULL,  -- Clave foránea hacia Album
    FOREIGN KEY (album_id) REFERENCES Album(id)
);

-- Genre
CREATE TABLE Genre (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(200) NOT NULL
);

-- Artist Genre
CREATE TABLE ArtistGenre (
    artist_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (artist_id, genre_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Song Genre
CREATE TABLE TrackGenre (
    track_id INT NOT NULL,
    genre_id INT NOT NULL,
    PRIMARY KEY (track_id, genre_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (genre_id) REFERENCES Genre(id)
);

-- Artist Alias
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

-- Album Sello
CREATE TABLE AlbumLabel (
    album_id INT NOT NULL,
    label_id INT NOT NULL,
    PRIMARY KEY (album_id, label_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (label_id) REFERENCES Label(id)
);

-- Copyright
CREATE TABLE Copyright (
    id INT IDENTITY(1,1) PRIMARY KEY,
    copyright_holder NVARCHAR(255) NOT NULL,  -- Quién posee los derechos
    copyright_year INT NOT NULL,  -- Año del derecho de autor
    copyright_notice NVARCHAR(MAX) NULL,  -- Aviso de copyright
    type NVARCHAR(50) NOT NULL  -- Tipo: 'Song' o 'Album'
);

-- Album Copyright
CREATE TABLE AlbumCopyright (
    album_id INT NOT NULL,
    copyright_id INT NOT NULL,
    PRIMARY KEY (album_id, copyright_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (copyright_id) REFERENCES Copyright(id)
);

-- Track Copyright
CREATE TABLE TrackCopyright (
    track_id INT NOT NULL,
    copyright_id INT NOT NULL,
    PRIMARY KEY (track_id, copyright_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (copyright_id) REFERENCES Copyright(id)
);

-- Tags
CREATE TABLE Tag (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL
);

-- Artist Tag
CREATE TABLE ArtistTag (
    artist_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (artist_id, tag_id),
    FOREIGN KEY (artist_id) REFERENCES Artist(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Album Tag
CREATE TABLE AlbumTag (
    album_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (album_id, tag_id),
    FOREIGN KEY (album_id) REFERENCES Album(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);

-- Track Tag
CREATE TABLE TrackTag (
    track_id INT NOT NULL,
    tag_id INT NOT NULL,
    PRIMARY KEY (track_id, tag_id),
    FOREIGN KEY (track_id) REFERENCES Track(id),
    FOREIGN KEY (tag_id) REFERENCES Tag(id)
);