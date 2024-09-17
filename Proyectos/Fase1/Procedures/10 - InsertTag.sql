CREATE PROCEDURE InsertTag
    @entity_type NVARCHAR(50),  -- 'Artist', 'Album', 'Track'
    @entity_id INT,
    @tag_name NVARCHAR(100)
AS
BEGIN
    DECLARE @tag_id INT;
    SELECT @tag_id = id FROM Tag WHERE name = @tag_name;

    IF @tag_id IS NULL
    BEGIN
        INSERT INTO Tag (name) VALUES (@tag_name);
        SET @tag_id = SCOPE_IDENTITY();
    END

    IF @entity_type = 'Artist'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM ArtistTag WHERE artist_id = @entity_id AND tag_id = @tag_id)
        BEGIN
            INSERT INTO ArtistTag (artist_id, tag_id) VALUES (@entity_id, @tag_id);
        END
    END
    ELSE IF @entity_type = 'Album'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM AlbumTag WHERE album_id = @entity_id AND tag_id = @tag_id)
        BEGIN
            INSERT INTO AlbumTag (album_id, tag_id) VALUES (@entity_id, @tag_id);
        END
    END
    ELSE IF @entity_type = 'Track'
    BEGIN
        IF NOT EXISTS (SELECT 1 FROM TrackTag WHERE track_id = @entity_id AND tag_id = @tag_id)
        BEGIN
            INSERT INTO TrackTag (track_id, tag_id) VALUES (@entity_id, @tag_id);
        END
    END
END;