CREATE PROCEDURE InsertGenre
    @genre_name NVARCHAR(100)
AS
BEGIN
    DECLARE @genre_id INT;
    SELECT @genre_id = id FROM Genre WHERE name = @genre_name;

    IF @genre_id IS NULL
    BEGIN
        INSERT INTO Genre (name) VALUES (@genre_name);
        SET @genre_id = SCOPE_IDENTITY();
    END

    SELECT @genre_id AS genre_id;
END;