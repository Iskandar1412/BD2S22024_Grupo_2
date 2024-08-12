CREATE OR REPLACE PROCEDURE PR3(
    IN p_email VARCHAR(100),
    IN p_codcourse INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_userid INT;
    v_credits INT;
    v_coursecredits INT;
BEGIN
    -- Obtencion del id usuario y sus creditos
    SELECT Id, Credits INTO v_userid, v_credits FROM Usuarios WHERE Email = p_email AND EmailConfirmed = TRUE;
    IF v_userid IS NULL THEN
        RAISE EXCEPTION 'Usuario no encontrado o no tiene la cuenta activa';
    END IF;

    -- Obtencion de creditos del curso (creditos necesarios)
    SELECT CreditsRequired INTO v_coursecredits FROM Course WHERE Id = p_codcourse;
    IF v_credits < v_coursecredits THEN
        RAISE EXCEPTION 'El usuario no tiene suficientes créditos para tomar este curso';

        -- Asignacion del curso
        INSERT INTO CourseAssignment (UserId, CourseId)
        VALUES (v_userid, p_codcourse);

        -- Registrar en historial
        INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
        VALUES ('INSERT', 'CourseAssignment', v_userid, 'SUCCESS');

    END IF;
END;
$$;