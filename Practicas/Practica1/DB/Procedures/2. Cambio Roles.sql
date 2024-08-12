CREATE OR REPLACE PROCEDURE PR2(
    IN p_email VARCHAR(100),
    IN p_codcourse INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_userid INT;
    v_tutor_roleid INT;
BEGIN
    -- Obtencion id usuario
    SELECT Id INTO v_userid FROM Usuarios WHERE Email = p_email AND EmailConfirmed = TRUE;
    IF v_userid IS NULL THEN
        RAISE EXCEPTION 'Usuario no encontrado o no tiene la cuenta activa';
    END IF;

    -- Obtencion id tutor
    SELECT Id INTO v_tutor_roleid FROM Roles WHERE RoleName = 'Tutor';
    IF v_tutor_roleid IS NULL THEN
        RAISE EXCEPTION 'Rol de Tutor no definido';

        -- Asignacion del rol de tutor en el perfil de estudiante
        INSERT INTO ProfileStudent (UserId, RoleId)
        VALUES (v_userid, v_tutor_roleid);

        -- Creacion perfil de tutor
        INSERT INTO TutorProfile (UserId, CourseId)
        VALUES (v_userid, p_codcourse);

        -- Registro en historial
        INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
        VALUES ('INSERT', 'ProfileStudent', v_userid, 'SUCCESS');

    END IF;
END;
$$;