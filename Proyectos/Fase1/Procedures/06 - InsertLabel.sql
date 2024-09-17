CREATE PROCEDURE InsertLabel
    @label_name NVARCHAR(255),
    @country_name NVARCHAR(255),
    @established_date DATE = NULL,
    @description NVARCHAR(MAX) = NULL
AS
BEGIN
    DECLARE @country_id INT;
    EXEC @country_id = InsertCountry @country_name;

    DECLARE @label_id INT;
    SELECT @label_id = id FROM Label WHERE name = @label_name AND country_id = @country_id;

    IF @label_id IS NULL
    BEGIN
        INSERT INTO Label (name, country_id, established_date, description)
        VALUES (@label_name, @country_id, @established_date, @description);
        SET @label_id = SCOPE_IDENTITY();
    END

    SELECT @label_id AS label_id;
END;