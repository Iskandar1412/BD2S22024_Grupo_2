CREATE OR REPLACE PROCEDURE PR2(
    IN p_email VARCHAR(100),
    IN p_rol INT
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_userid INT;
    v_tutor_roleid INT;
    v_student_roleid INT;
    v_existing_student INT;
    v_existing_tutor INT;
BEGIN
    -- Obtención id usuario
    SELECT Id INTO v_userid FROM Usuarios WHERE Email = p_email AND EmailConfirmed = TRUE;
    IF v_userid IS NULL THEN
        RAISE EXCEPTION 'Usuario no encontrado o no tiene la cuenta activa';
    END IF;

    -- Obtención id de los roles
    SELECT Id INTO v_tutor_roleid FROM Roles WHERE RoleName = 'Tutor';
    SELECT Id INTO v_student_roleid FROM Roles WHERE RoleName = 'Estudiante';
    IF v_tutor_roleid IS NULL OR v_student_roleid IS NULL THEN
        RAISE EXCEPTION 'Rol no definido';
    END IF;

    -- Verificación de existencia en las tablas correspondientes
    SELECT COUNT(*) INTO v_existing_student FROM ProfileStudent WHERE UserId = v_userid AND RoleId = v_student_roleid;
    SELECT COUNT(*) INTO v_existing_tutor FROM TutorProfile WHERE UserId = v_userid;

    -- Asignación del rol de estudiante o tutor
    IF p_rol = v_student_roleid THEN
        IF v_existing_student > 0 THEN
            INSERT INTO Notification(UserID, Mesage)
            VALUES (v_userid, 'EFEZOTA el usuario ya tiene su rol como estudiante [Llora :"v]');

            RAISE EXCEPTION 'El usuario ya tiene el rol de estudiante';
        ELSE
            IF v_existing_tutor > 0 THEN
                -- Eliminar perfil de tutor si existe
                DELETE FROM TutorProfile WHERE UserId = v_userid;
            END IF;
            -- Asignar rol de estudiante
            INSERT INTO ProfileStudent (UserId, RoleId)
            VALUES (v_userid, v_student_roleid);

            INSERT INTO Notification(UserID, Mesage)
            VALUES (v_userid, 'Cambio de rol a estudiante');

        END IF;
    ELSIF p_rol = v_tutor_roleid THEN
        IF v_existing_tutor > 0 THEN
            INSERT INTO Notification(UserID, Mesage)
            VALUES (v_userid, 'EFEZOTA el usuario ya tiene su rol como tutor [Llora x2 :"v]');

            RAISE EXCEPTION 'El usuario ya tiene el rol de tutor';
        ELSE
            IF v_existing_student > 0 THEN
                -- Eliminar perfil de estudiante si existe
                DELETE FROM ProfileStudent WHERE UserId = v_userid;
            END IF;
            -- Asignar rol de tutor
            INSERT INTO TutorProfile (UserId, CourseId)
            VALUES (v_userid, p_rol);

            INSERT INTO Notification(UserID, Mesage)
            VALUES (v_userid, 'Cambio de rol a tutor');
        END IF;
    ELSE
        RAISE EXCEPTION 'Rol no reconocido';
    END IF;

    -- Registro en historial (descomentado si se desea)
    -- INSERT INTO HistoryLog (Action, TableName, RecordId, StatusLog)
    -- VALUES ('INSERT', 'ProfileStudent', v_userid, 'SUCCESS');

END;
$$;