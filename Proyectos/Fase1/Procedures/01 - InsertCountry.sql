CREATE PROCEDURE InsertCountry
    @country_name NVARCHAR(255),
    @iso_code NVARCHAR(10) = NULL
AS
BEGIN
    DECLARE @country_id INT;
    SELECT @country_id = id FROM Country WHERE name = @country_name;
    
    IF @country_id IS NULL
    BEGIN
        INSERT INTO Country (name, iso_code) VALUES (@country_name, @iso_code);
        SET @country_id = SCOPE_IDENTITY();
    END
    
    SELECT @country_id AS country_id;
END;