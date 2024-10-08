CREATE PROCEDURE InsertArtist
    @artist_name NVARCHAR(255),
    @sort_name NVARCHAR(255),
    @country_name NVARCHAR(255),
    @area NVARCHAR(255) = NULL,
    @begin_date DATE = NULL,
    @end_date DATE = NULL,
    @type NVARCHAR(100) = NULL,
    @gender NVARCHAR(50) = NULL,
    @description NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @country_id INT;
    EXEC @country_id = InsertCountry @country_name;

    DECLARE @artist_id INT;
    SELECT @artist_id = id FROM Artist WHERE name = @artist_name AND country_id = @country_id;
    
    IF @artist_id IS NULL
    BEGIN
        INSERT INTO Artist (name, sort_name, country_id, area, begin_date, end_date, type, gender, description)
        VALUES (@artist_name, @sort_name, @country_id, @area, @begin_date, @end_date, @type, @gender, @description);
        SET @artist_id = SCOPE_IDENTITY();
    END

    SELECT @artist_id AS artist_id;
END;