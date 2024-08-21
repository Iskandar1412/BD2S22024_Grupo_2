--------------------------------------------------- CREACIÓN DE FUNCIONES ------------------------------------------------
--- Func_course_usuarios
create or replace function Func_course_usuarios(id_curso INT)
returns table (student_id INT,Nombres VARCHAR(50), Apellidos VARCHAR(50), correo VARCHAR(100),F_nacimiento DATE,Creditos INT) as $$
begin
	return query
	select UserId,Firstname,Lastname,Email,Birth,Credits
	from Usuarios
	inner join CourseAssignment on Usuarios.Id = CourseAssignment.UserId
	where CourseAssignment.CourseId = id_curso;
end;
$$ language plpgsql;



--- Func_tutor_course
create or replace function Func_tutor_course(id_tutor INT)
returns table(id_curso INT, nombre_curso VARCHAR(100)) as $$
begin
	return query
	select CourseId,Name
	from Course
	inner join TutorProfile on Course.Id = TutorProfile.CourseId
	where TutorProfile.id = id_tutor;
end;
$$ language plpgsql;

--- Func_notification_usuarios
create or replace function Func_notification_usuarios(id_usuario INT)
returns table(id_mensaje INT, Mensaje text,Tiempo_De_Envio TIMESTAMP) as $$
begin
	return query
	select Id,Mesage,SentAt
	from Notification
	where UserId = id_usuario;
end;
$$ language plpgsql;

--- Func_logger
create or replace function Func_logger()
returns table(id_log INT,Accion VARCHAR(50),Nombre_tabla VARCHAR(50),Id_record INT,Time_Stamp_log TIMESTAMP,Estado VARCHAR(20)) as $$
begin
	return query
	select Id, Action,TableName,RecordId,TimeStampLog,StatusLog
	from HistoryLog;
end;
$$ language plpgsql;
--- Func_usuarios

create or replace function Func_usuarios()
returns table(Id_estudiante INT,Nombres VARCHAR(50), Apellidos VARCHAR(50), Correo VARCHAR(100), Fecha_Nacimiento DATE, Creditos INT, Rol VARCHAR(50)) as $$
begin
	return query
	select pu.Id,u.Firstname,u.Lastname,u.Email,u.Birth,u.Credits,r.RoleName
	from ProfileStudent pu
	join Usuarios u on pu.UserId = u.Id
	join Roles r on pu.RoleId = r.Id;
		
end;
$$ language plpgsql;

------------------------ LLAMADAS A FUNCIONES -----------------------
-- SE USA ID DEL CURSO
select * from Func_course_usuarios(18);
-- SE USA ID DEL TUTOR
select * from Func_tutor_course(1);
-- SE USA ID DEL USUARIO
select * from Func_notification_usuarios(27);
select * from Func_usuarios();
select * from Func_logger();
