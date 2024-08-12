CREATE OR REPLACE PROCEDURE PR5(
    IN p_name VARCHAR(100),
    IN p_creditsrequired INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_courseid INT;
BEGIN
    INSERT INTO Course (Name, CreditsRequired)
    VALUES (p_name, p_creditsrequired)
    RETURNING Id INTO v_courseid;

    -- Registrar historial
    INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
    VALUES ('INSERT', 'Course', v_courseid, 'SUCCESS');
END;
$$;