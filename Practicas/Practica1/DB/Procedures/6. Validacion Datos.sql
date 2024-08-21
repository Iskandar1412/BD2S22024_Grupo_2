CREATE OR REPLACE PROCEDURE PR6()
LANGUAGE plpgsql
AS $$
DECLARE
    v_user_id INT;
    v_course_id INT;
BEGIN
    -- Validación de FirstName y LastName en la tabla Usuarios
    FOR v_user_id IN
        SELECT Id
        FROM Usuarios
        WHERE Firstname ~ '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]' OR Lastname ~ '[^A-Za-zÁÉÍÓÚáéíóúÑñ ]'
    LOOP
        RAISE EXCEPTION 'Error: Firstname or Lastname contains invalid characters for User ID %', v_user_id;
    END LOOP;

    -- Validación de Name en la tabla Course
    FOR v_course_id IN
        SELECT Id
        FROM Course
        WHERE Name ~ '[^A-Za-zÁÉÍÓÚáéíóúÑñ0-9 ]'
    LOOP
        RAISE EXCEPTION 'Error: Course name contains invalid characters for Course ID %', v_course_id;
    END LOOP;

    -- Validación de CreditsRequired en la tabla Course
    FOR v_course_id IN
        SELECT Id
        FROM Course
        WHERE CreditsRequired < 0  -- O ajusta este límite según sea necesario
    LOOP
        RAISE EXCEPTION 'Error: CreditsRequired contains invalid value for Course ID %', v_course_id;
    END LOOP;
    
    -- Registro en HistoryLog si todo es exitoso
    INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
    SELECT 'VALIDATE', 'Usuarios', Id, 'SUCCESS'
    FROM Usuarios
    WHERE Firstname ~ '[A-Za-zÁÉÍÓÚáéíóúÑñ ]' AND Lastname ~ '[A-Za-zÁÉÍÓÚáéíóúÑñ ]';

    INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
    SELECT 'VALIDATE', 'Course', Id, 'SUCCESS'
    FROM Course
    WHERE Name ~ '[A-Za-zÁÉÍÓÚáéíóúÑñ0-9 ]' AND CreditsRequired >= 0;

END;
$$;