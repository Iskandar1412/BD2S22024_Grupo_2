CREATE TABLE Artista (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(255) NOT NULL,
    genero NVARCHAR(100),
    pais NVARCHAR(100),
    descripcion NVARCHAR(MAX)
);

CREATE TABLE Album (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(255) NOT NULL,
    ano_lanzamiento INT,
    id_artista INT,
    FOREIGN KEY (id_artista) REFERENCES Artista(id)
);

CREATE TABLE Cancion (
    id INT IDENTITY(1,1) PRIMARY KEY,
    titulo NVARCHAR(255) NOT NULL,
    duracion TIME,
    id_album INT,
    FOREIGN KEY (id_album) REFERENCES Album(id)
);

CREATE TABLE Genero (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL
);

CREATE TABLE ArtistaGenero (
    id_artista INT,
    id_genero INT,
    PRIMARY KEY (id_artista, id_genero),
    FOREIGN KEY (id_artista) REFERENCES Artista(id),
    FOREIGN KEY (id_genero) REFERENCES Genero(id)
);
