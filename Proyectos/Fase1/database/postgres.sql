CREATE DATABASE musicbrainz;

-- Generos
CREATE TABLE Genero(
    id INT PRIMARY KEY,
    genero VARCHAR(25)
);

-- Conjunto de lugares, implica paises,regiones o ciudades
CREATE TABLE lugar (
    id INT PRIMARY KEY,
    nombre VARCHAR(1000),
    tipo VARCHAR(1000)
);

-- Conjunto de Tags Utilizados pora artistas, albumos, Ep, etc
CREATE TABLE Tags(
    id INT PRIMARY KEY,
    nombre VARCHAR(500)
);

-- Tipos de empaquetado
CREATE TABLE Empaquetado(
    id INT PRIMARY KEY,
    nombre VARCHAR(1000),
    descripcion VARCHAR(1000)
);


-- El estado de lanzamientos
CREATE TABLE Estado(
    id INT PRIMARY KEY,
    nombre VARCHAR(100),
    descrpcion VARCHAR(1000)
);

-- Lenguaje de los lanzamientos
CREATE TABLE Lenguaje(
    id INT PRIMARY KEY,
    iso_code1 VARCHAR(10),
    iso_code2 VARCHAR(10),
    iso_code3 VARCHAR(10),
    nombre VARCHAR(1000),
    frecuencia INT,
    iso_code4 VARCHAR(10)
);

-- Idioma en el que fue escrito el titulo de los lanzamientos
CREATE TABLE Scripts(
    id INT Primary KEY,
    iso_code VARCHAR(20),
    iso_number INT,
    nombre VARCHAR(1000),
    frecuencia INT
);


-- Tabla que contiene el tipo de artista
CREATE TABLE TipoArtista(
    id INT PRIMARY KEY,
    nombre VARCHAR(20)
);

-- Artistas
CREATE TABLE Artista (
    id INT PRIMARY KEY,
    nombre VARCHAR(5000),
    comentario VARCHAR(5000),
    tipo INT,
    genero INT,
    id_lugar INT,
    anio_inicio INT,
    mes_inicio INT,
    dia_inicio INT,
    anio_final INT,
    mes_final INT,
    dia_final INT,
    lugar_inicio INT,
    lugar_final INT,
    FOREIGN KEY (tipo) REFERENCES TipoArtista(id),
    FOREIGN KEY (genero) REFERENCES Genero(id),
    FOREIGN KEY (id_lugar) REFERENCES lugar(id),
    FOREIGN KEY (lugar_inicio) REFERENCES lugar(id),
    FOREIGN KEY (lugar_final) REFERENCES lugar(id)
);

-- Carga de ISNI
CREATE TABLE Isni(
    id SERIAL PRIMARY KEY,
    id_artista INT,
    isni_code VARCHAR(1000),
    FOREIGN KEY (id_artista) REFERENCES Artista(id)
);

-- Ratings de los artistas
CREATE TABLE RatingArtist(
    id SERIAL PRIMARY KEY,
    id_artista INT,
    rating INT,
    num_ratings INT,
    FOREIGN KEY (id_artista) REFERENCES Artista(id)
);

-- Relación Artista - Etiqueta
CREATE TABLE ArtistaTag (
    id SERIAL PRIMARY KEY,
    artist_id INT,
    tag_id INT,
    FOREIGN KEY (artist_id) REFERENCES Artista(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);

-- Créditos de Artista
CREATE TABLE ArtistaCredit(
    id_artista_credito INT PRIMARY KEY,
    nombre VARCHAR(10000),
    total_artistas INT
);


-- Relacion De Artista con Créditos
CREATE TABLE NombreArtistaCredito(
    id SERIAL PRIMARY KEY,
    id_artista_credito INT,
    id_artista INT,
    nombre_artista_individual VARCHAR(1000),
    FOREIGN KEY (id_artista_credito) REFERENCES ArtistaCredit(id_artista_credito),
    FOREIGN KEY (id_artista) REFERENCES Artista(id)
);

-- Tipo de Grupo de lanzamientos
create table TipoGrupo(
	id INT PRIMARY KEY,
    nombre VARCHAR(20),
    descripcion VARCHAR(5000)
);

-- Discografía
CREATE TABLE Discografia (
    id INT PRIMARY KEY,
    titulo VARCHAR(10000),
    tipo INT,
    creditos INT,
    rating INT,
    num_calificaciones INT,
    num_lanzamientos INT,
    anio_salida INT,
    mes_salida INT,
    dia_salida INT,
    FOREIGN KEY (creditos) REFERENCES ArtistaCredit(id_artista_credito),
    FOREIGN KEY (tipo) REFERENCES TipoGrupo(id)
);

-- Tabla De Subgeneros/Subcategorías de los elementos de discografía
CREATE TABLE DiscSubTipo(
	id SERIAL PRIMARY KEY, 
    id_disc INT,
    subtipo VARCHAR(1000),
    FOREIGN KEY (id_disc) REFERENCES Discografia(id)
);

-- PENDIENTEEEEEEEEEEEEEEEEEE
-- Conjunto de tagas para elementos de la discografía
CREATE TABLE TagsDisc (
    id SERIAL PRIMARY KEY,
    id_disc INT,
    tag_id INT,
    FOREIGN KEY (id_disc) REFERENCES Discografia(id),
    FOREIGN KEY (tag_id) REFERENCES Tags(id)
);


-- CORRESPONDE A LAS TABLAS DE LANZAMIENTOS
CREATE TABLE Lanzamientos(
    id INT PRIMARY KEY,
    nombre VARCHAR(5000),
    creditos INT,
    grupo_disc INT,
    empaquetado INT,
    estado INT,
    lenguaje INT,
    script INT,
    cod_barra VARCHAR(6000),
    calidad INT,
    comentario VARCHAR(5000),
    FOREIGN KEY (creditos) REFERENCES ArtistaCredit(id_artista_credito),
    FOREIGN KEY (grupo_disc) REFERENCES Discografia(id),
    FOREIGN KEY (empaquetado) REFERENCES Empaquetado(id),
    FOREIGN KEY (estado) REFERENCES Estado(id),
    FOREIGN KEY (lenguaje) REFERENCES Lenguaje(id)
);

-- Lista de lugares donde se realizó un lanzamiento
CREATE TABLE lugarLanzamiento(
    id SERIAL PRIMARY KEY,
    id_lanzamiento INT,
    id_lugar INT,
    anio INT,
    mes INT,
    dia INT,
    FOREIGN KEY (id_lanzamiento) REFERENCES lanzamientos(id),
    FOREIGN KEY (id_lugar) REFERENCES lugar(id)
);

-- Sellos de los lanzamientos
CREATE TABLE LabelLanzamientos(
	id SERIAL PRIMARY KEY,
    id_label INT,
    id_lanzamiento INT,
    descripcion VARCHAR(5000),
    FOREIGN KEY (id_lanzamiento) REFERENCES Lanzamientos(id)
);

-- Catalogos de los lanzamientos
CREATE TABLE CatalogoLanzamientos(
    id_catalogo INT PRIMARY KEY,
    id_lanzamiento INT,
    catalogo VARCHAR(5000),
    FOREIGN KEY (id_lanzamiento) REFERENCES Lanzamientos(id)
);

-- Medio (para almacenar formatos como CD, vinilo, digital, etc.)
CREATE TABLE Medio (
    id INT PRIMARY KEY,
    release_id INT, 
    formato VARCHAR(1000),
    posicion INT, -- Posición del medio dentro del lanzamiento (CD1, CD2, etc.)
    FOREIGN KEY (release_id) REFERENCES Lanzamientos(id)
);

-- Etiquetas para los lanazamientos
CREATE TABLE TagLanzamientos(
    id SERIAL PRIMARY KEY,
    id_release INT,
    id_tag INT,
    FOREIGN KEY (id_release) REFERENCES Lanzamientos(id),
    FOREIGN KEY (id_tag) REFERENCES Tags(id)
);

-- Grabaciones
CREATE TABLE Recording (
    id INT PRIMARY KEY,
    title VARCHAR(1000),
    artist_credit_id INT,
    duracion INT,
    comentario VARCHAR(5000),
    FOREIGN KEY (artist_credit_id) REFERENCES ArtistaCredit(id_artista_credito)
);

-- Rating de las Grabaciones
CREATE TABLE RatingRecording(
    id SERIAL PRIMARY KEY,
    id_recording INT,
    calificacion INT,
    num_calificaciones INT,
    FOREIGN KEY(id_recording) REFERENCES Recording(id)
);

-- ISRC de las grabaciones
CREATE TABLE ISRCRecording(
    id INT PRIMARY KEY,
    id_recording INT,
    valor_isrc VARCHAR(5000),
    FOREIGN KEY(id_recording) REFERENCES Recording(id)
);

-- Tags de las grabaciones
CREATE TABLE TagRecording(
    id SERIAL PRIMARY KEY,
    id_recording INT,
    id_tag INT,
    FOREIGN KEY (id_recording) REFERENCES Recording(id),
    FOREIGN KEY (id_tag) REFERENCES Tags(id)
);

-- Artistas encargado de cada recording
CREATE TABLE ArtistaRecording(
    id INT PRIMARY KEY,
    id_artista INT,
    id_recording INT,
    FOREIGN KEY (id_artista) REFERENCES Artista(id),
    FOREIGN KEY (id_recording) REFERENCES Recording(id)
);

-- Tracks
CREATE TABLE Track (
    id INT PRIMARY KEY,
    id_recording INT,
    id_medio INT,
    numero VARCHAR(3000),
    nombre VARCHAR(5000),
    id_creditos INT, 
    duracion INT,
    FOREIGN KEY (id_recording) REFERENCES Recording(id),
    FOREIGN KEY (id_medio) REFERENCES Medio(id),
    FOREIGN KEY (id_creditos) REFERENCES ArtistaCredit(id_artista_credito)
);