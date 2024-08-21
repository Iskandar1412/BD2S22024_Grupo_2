---------------------------------------- DEFINICIÓN DE TRIGGERS -----------------------------------------
create or replace function trigger_insert()
returns trigger as $$
begin
	insert into HistoryLog(Action,TableName,RecordId,TimeStampLog,StatusLog)
	return new;
end;
$$language plpgsql;


-------------------------------------- IMPLEMENTACIÓN DE TRIGGERS -------------------------------------
=======
CREATE OR REPLACE FUNCTION history_log_trigger_function() RETURNS TRIGGER AS $$
BEGIN
    -- Manejar eventos de INSERT
    IF (TG_OP = 'INSERT') THEN
        INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
        VALUES ('INSERT', TG_TABLE_NAME, NEW.Id, 'SUCCESS');
        RETURN NEW;
    -- Manejar eventos de UPDATE
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
        VALUES ('UPDATE', TG_TABLE_NAME, NEW.Id, 'SUCCESS');
        RETURN NEW;
    -- Manejar eventos de DELETE
    ELSIF (TG_OP = 'DELETE') THEN
        INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
        VALUES ('DELETE', TG_TABLE_NAME, OLD.Id, 'SUCCESS');
        RETURN OLD;
    END IF;
END;
$$ LANGUAGE plpgsql;


-- Usuarios

CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON Usuarios
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();

-- Roles
CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON Roles
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();


-- ProfileStudent

CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON ProfileStudent
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();

-- TFA

CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON TFA
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();

-- Notification

CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON Notification
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();

-- Course

CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON Course
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();

-- TutorProfile

CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON TutorProfile
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();

-- CourseAssignment
CREATE TRIGGER Trigger1
AFTER INSERT OR UPDATE OR DELETE
ON CourseAssignment
FOR EACH ROW EXECUTE FUNCTION history_log_trigger_function();
