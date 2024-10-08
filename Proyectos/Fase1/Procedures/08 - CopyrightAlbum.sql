CREATE PROCEDURE InsertAlbumCopyright
    @album_title NVARCHAR(255),
    @artist_name NVARCHAR(255),
    @artist_country NVARCHAR(255),
    @copyright_holder NVARCHAR(255),
    @copyright_year INT,
    @copyright_notice NVARCHAR(MAX)
AS
BEGIN
    DECLARE @album_id INT;
    EXEC @album_id = InsertAlbum @album_title, NULL, @artist_name, @artist_country;

    DECLARE @copyright_id INT;
    EXEC @copyright_id = InsertCopyright @copyright_holder, @copyright_year, @copyright_notice, 'Album';

    IF NOT EXISTS (SELECT 1 FROM AlbumCopyright WHERE album_id = @album_id AND copyright_id = @copyright_id)
    BEGIN
        INSERT INTO AlbumCopyright (album_id, copyright_id) VALUES (@album_id, @copyright_id);
    END
END;