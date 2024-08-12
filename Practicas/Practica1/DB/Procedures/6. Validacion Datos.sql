CREATE OR REPLACE PROCEDURE PR6()
LANGUAGE plpgsql
AS $$
BEGIN
    -- Validar nombre en usuarios
    UPDATE Usuarios
    SET Firstname = REGEXP_REPLACE(Firstname, '[^a-zA-Z]', '', 'g'),
        Lastname = REGEXP_REPLACE(Lastname, '[^a-zA-Z]', '', 'g');

    -- Validacion de nombre y creditos
    UPDATE Course
    SET Name = REGEXP_REPLACE(Name, '[^a-zA-Z]', '', 'g'),
        CreditsRequired = CAST(REGEXP_REPLACE(CreditsRequired::TEXT, '[^0-9]', '', 'g') AS INT);
        
    -- Registro en el historial
    INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
    VALUES ('VALIDATION', 'Usuarios/Course', 0, 'SUCCESS');
END;
$$;