CREATE OR REPLACE PROCEDURE PR4(
    IN p_rolename VARCHAR(50)
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_roleid INT;
BEGIN
    IF EXISTS (SELECT 1 FROM Roles WHERE RoleName = p_rolename) THEN
        RAISE EXCEPTION 'El rol ya existe';
    ELSE
        INSERT INTO Roles (RoleName)
        VALUES (p_rolename)
        RETURNING Id INTO v_roleid;

        -- Registrar historial
        INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
        VALUES ('INSERT', 'Roles', v_roleid, 'SUCCESS');
    END IF;
END;
$$;