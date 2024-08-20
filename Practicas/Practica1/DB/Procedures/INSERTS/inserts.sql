-- Registro Usuario
CALL PR1('John', 'Doe', 'john.doe@example.com', '1990-01-01', 'mypassword', 10);

-- Creacion Curso
CALL PR5('Fisica Basica', 11);
CALL PR5('Matematica Basica 1', 0);

-- Rol Estudiante/Tutor
CALL PR4('Tutor');
CALL PR4('Estudiante');

-- Asignacion Curso
CALL PR3('john.doe@example.com', 4);

-- Cambio rol
CALL PR2('john.doe@example.com', 1);

-- Validacion Datos
CALL PR6();
