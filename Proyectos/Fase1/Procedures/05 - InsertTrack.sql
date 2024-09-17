CREATE PROCEDURE InsertTrack
    @track_title NVARCHAR(255),
    @duration TIME,
    @album_title NVARCHAR(255),
    @artist_name NVARCHAR(255),
    @artist_country NVARCHAR(255),
    @genre_name NVARCHAR(100)
AS
BEGIN
    DECLARE @album_id INT;
    EXEC @album_id = InsertAlbum @album_title, NULL, @artist_name, @artist_country;

    DECLARE @genre_id INT;
    EXEC @genre_id = InsertGenre @genre_name;

    DECLARE @track_id INT;
    SELECT @track_id = id FROM Track WHERE title = @track_title AND album_id = @album_id;

    IF @track_id IS NULL
    BEGIN
        INSERT INTO Track (title, duration, album_id) VALUES (@track_title, @duration, @album_id);
        SET @track_id = SCOPE_IDENTITY();
    END

    IF NOT EXISTS (SELECT 1 FROM TrackGenre WHERE track_id = @track_id AND genre_id = @genre_id)
    BEGIN
        INSERT INTO TrackGenre (track_id, genre_id) VALUES (@track_id, @genre_id);
    END

    SELECT @track_id AS track_id;
END;