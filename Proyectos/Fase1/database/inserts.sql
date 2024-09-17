INSERT INTO Artista (nombre, genero, pais, descripcion)
VALUES ('Hoyomix', 'Instrumental', 'CH', 'Banda sinfónica de Mihoyo');

INSERT INTO Album (titulo, ano_lanzamiento, id_artista)
VALUES ('Stellar Moments Vol. 2', 2022, 1);

INSERT INTO Cancion (titulo, duracion, id_album)
VALUES ('Broker Betwixt Life and Death', '01:27', 1);

INSERT INTO Genero (nombre)
VALUES ('Instrumental');

INSERT INTO ArtistaGenero (id_artista, id_genero)
VALUES (1, 1);



EXEC insertSong 
    @nombre_artista = 'Hoyomix', 
    @genero = 'Instrumental', 
    @pais = 'CH', 
    @descripcion = 'Banda sinfónica de Mihoyo',
    @titulo_album = 'Stellar Moments Vol. 2', 
    @ano_lanzamiento = 2022, 
    @titulo_cancion = 'Broker Betwixt Life and Death', 
    @duracion = '01:27';
