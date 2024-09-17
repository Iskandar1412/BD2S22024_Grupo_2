CREATE PROCEDURE obtenerInformacionArtista
    @nombre_artista NVARCHAR(255)
AS
BEGIN
    SELECT a.nombre, a.genero, a.pais, al.titulo AS album, al.ano_lanzamiento, c.titulo AS cancion, c.duracion
    FROM Artista a
    LEFT JOIN Album al ON a.id = al.id_artista
    LEFT JOIN Cancion c ON al.id = c.id_album
    WHERE a.nombre = @nombre_artista;
END;
GO

-- Procediminento cancion completa
CREATE PROCEDURE insertSong
    @nombre_artista NVARCHAR(255),
    @genero NVARCHAR(100),
    @pais NVARCHAR(100),
    @descripcion NVARCHAR(MAX),
    @titulo_album NVARCHAR(255),
    @ano_lanzamiento INT,
    @titulo_cancion NVARCHAR(255),
    @duracion TIME
AS
BEGIN
    BEGIN TRANSACTION;

    DECLARE @id_artista INT;
    SELECT @id_artista = id FROM Artista WHERE nombre = @nombre_artista;

    IF @id_artista IS NULL
    BEGIN
        INSERT INTO Artista (nombre, genero, pais, descripcion)
        VALUES (@nombre_artista, @genero, @pais, @descripcion);
        SET @id_artista = SCOPE_IDENTITY();
    END

    DECLARE @id_genero INT;
    SELECT @id_genero = id FROM Genero WHERE nombre = @genero;

    IF @id_genero IS NULL
    BEGIN
        INSERT INTO Genero (nombre)
        VALUES (@genero);
        SET @id_genero = SCOPE_IDENTITY();
    END

    IF NOT EXISTS (SELECT 1 FROM ArtistaGenero WHERE id_artista = @id_artista AND id_genero = @id_genero)
    BEGIN
        INSERT INTO ArtistaGenero (id_artista, id_genero)
        VALUES (@id_artista, @id_genero);
    END

    DECLARE @id_album INT;
    SELECT @id_album = id FROM Album WHERE titulo = @titulo_album AND id_artista = @id_artista;

    IF @id_album IS NULL
    BEGIN
        INSERT INTO Album (titulo, ano_lanzamiento, id_artista)
        VALUES (@titulo_album, @ano_lanzamiento, @id_artista);
        SET @id_album = SCOPE_IDENTITY();
    END

    INSERT INTO Cancion (titulo, duracion, id_album)
    VALUES (@titulo_cancion, @duracion, @id_album);

    COMMIT TRANSACTION;
END;
GO
