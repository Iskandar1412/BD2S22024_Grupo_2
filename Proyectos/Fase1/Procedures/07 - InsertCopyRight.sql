CREATE PROCEDURE InsertCopyright
    @copyright_holder NVARCHAR(255),
    @copyright_year INT,
    @copyright_notice NVARCHAR(MAX),
    @type NVARCHAR(50) -- 'Song' o 'Album'
AS
BEGIN
    DECLARE @copyright_id INT;
    INSERT INTO Copyright (copyright_holder, copyright_year, copyright_notice, type)
    VALUES (@copyright_holder, @copyright_year, @copyright_notice, @type);
    SET @copyright_id = SCOPE_IDENTITY();

    SELECT @copyright_id AS copyright_id;
END;