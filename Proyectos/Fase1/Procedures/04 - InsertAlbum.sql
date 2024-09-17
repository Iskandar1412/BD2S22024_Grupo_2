CREATE PROCEDURE InsertAlbum
    @album_title NVARCHAR(255),
    @release_date DATE,
    @artist_name NVARCHAR(255),
    @artist_country NVARCHAR(255)
AS
BEGIN
    DECLARE @artist_id INT;
    EXEC @artist_id = InsertArtist @artist_name, @artist_name, @artist_country;

    DECLARE @album_id INT;
    SELECT @album_id = id FROM Album WHERE title = @album_title AND artist_id = @artist_id;

    IF @album_id IS NULL
    BEGIN
        INSERT INTO Album (title, release_date, artist_id)
        VALUES (@album_title, @release_date, @artist_id);
        SET @album_id = SCOPE_IDENTITY();
    END

    SELECT @album_id AS album_id;
END;