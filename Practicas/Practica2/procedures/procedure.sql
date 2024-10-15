USE Practica2;

CREATE PROCEDURE InsertarDatosCompletos
    @edad INT,
    @genero CHAR(1),
    @habitacion VARCHAR(30),
    @status CHAR(1),
    @actividad VARCHAR(100)
AS
BEGIN
    BEGIN TRANSACTION;

    -- Insertar Paciente
    DECLARE @id_paciente INT;
    INSERT INTO Paciente (edad, genero)
    VALUES (@edad, @genero);
    SET @id_paciente = SCOPE_IDENTITY();  -- Obtener el ID Paciente actual

    -- Insertar Habitacion
    DECLARE @id_habitacion INT;
    INSERT INTO Habitacion (habitacion)
    VALUES (@habitacion);
    SET @id_habitacion = SCOPE_IDENTITY();  -- Obtener el ID Habitación Actual

    -- Insercion en tabla Log_Habitacion
    INSERT INTO Log_Habitacion (id_habitacion, status)
    VALUES (@id_habitacion, @status);

    -- Insercion en tabla Log_Actividad
    INSERT INTO Log_Actividad (id_paciente, id_habitacion, actividad)
    VALUES (@id_paciente, @id_habitacion, @actividad);

    COMMIT TRANSACTION;
END