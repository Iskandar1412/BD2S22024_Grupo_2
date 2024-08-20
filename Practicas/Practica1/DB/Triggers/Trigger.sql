---------------------------------------- DEFINICIÓN DE TRIGGERS -----------------------------------------
create or replace function trigger_insert()
returns trigger as $$
begin
	insert into HistoryLog(Action,TableName,RecordId,TimeStampLog,StatusLog)
	return new;
end;
$$language plpgsql;


-------------------------------------- IMPLEMENTACIÓN DE TRIGGERS -------------------------------------