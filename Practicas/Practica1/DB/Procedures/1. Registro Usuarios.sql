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
    v_userid INT;
BEGIN
    -- Correo existente, verificacion
    IF EXISTS (SELECT 1 FROM Usuarios WHERE Email = p_email) THEN
        RAISE EXCEPTION 'El correo electrónico ya está registrado';
    END IF;

    -- Insercion de usuario
    INSERT INTO Usuarios (Firstname, Lastname, Email, Birth, Pass, Credits)
    VALUES (p_firstname, p_lastname, p_email, p_birth, p_pass, p_credits);

    -- Insercion en historial
    -- INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
    -- VALUES ('INSERT', 'Usuarios', v_userid, 'SUCCESS');
END;
$$;