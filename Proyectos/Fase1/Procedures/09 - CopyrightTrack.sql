CREATE PROCEDURE InsertTrackCopyright
    @track_title NVARCHAR(255),
    @album_title NVARCHAR(255),
    @artist_name NVARCHAR(255),
    @artist_country NVARCHAR(255),
    @copyright_holder NVARCHAR(255),
    @copyright_year INT,
    @copyright_notice NVARCHAR(MAX)
AS
BEGIN
    DECLARE @track_id INT;
    EXEC @track_id = InsertTrack @track_title, NULL, @album_title, @artist_name, @artist_country, NULL;

    DECLARE @copyright_id INT;
    EXEC @copyright_id = InsertCopyright @copyright_holder, @copyright_year, @copyright_notice, 'Song';

    IF NOT EXISTS (SELECT 1 FROM TrackCopyright WHERE track_id = @track_id AND copyright_id = @copyright_id)
    BEGIN
        INSERT INTO TrackCopyright (track_id, copyright_id) VALUES (@track_id, @copyright_id);
    END
END;