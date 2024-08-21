CREATE OR REPLACE PROCEDURE PR1(
    IN p_firstname VARCHAR(50),
    IN p_lastname VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_birth DATE,
    IN p_pass VARCHAR(100),
    IN p_credits INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    idUsuario INT;
    id_perfiles INT;
BEGIN
    -- Correo existente, verificacion
    IF EXISTS (SELECT 1 FROM Usuarios WHERE Email = p_email) THEN
        RAISE EXCEPTION 'El correo electrónico ya está registrado';
    ELSE
        -- Insercion de usuario
        INSERT INTO Usuarios (Firstname, Lastname, Email, Birth, Pass, Credits)
        VALUES (p_firstname, p_lastname, p_email, p_birth, p_pass, p_credits)
        RETURNING id INTO idUsuario;

        -- Insercion en TFA
        INSERT INTO TFA (UserID, IsActive) 
        VALUES (idUsuario, TRUE);

        -- Obtener id_perfiles para 'Estudiante'
        id_perfiles = (SELECT id FROM Roles WHERE RoleName = 'Estudiante');

        -- Inserción en ProfileStudent
        INSERT INTO ProfileStudent(UserId, RoleId)
        VALUES (idUsuario, id_perfiles);

        INSERT INTO Notification(UserID, Mesage)
        VALUES (idUsuario, 'Nuevo estudiante registrado UwU');
    END IF;

    -- Insercion en historial (descomentar si es necesario)
    -- INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
    -- VALUES ('INSERT', 'Usuarios', idUsuario, 'SUCCESS');
END;
$$;