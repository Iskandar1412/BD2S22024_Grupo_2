-- Creación de la tabla de bitácora
CREATE TABLE bitacora (
    id SERIAL PRIMARY KEY,
    operacion VARCHAR(10), -- Tipo de operación: INSERT o SELECT
    tabla VARCHAR(100), -- Nombre de la tabla afectada
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    usuario VARCHAR(100), -- Usuario que ejecutó la operación
    descripcion TEXT -- Descripción de la operación realizada
);

-- Triggers para la tabla Genero
CREATE OR REPLACE FUNCTION log_insert_genero() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bitacora(operacion, tabla, usuario, descripcion)
    VALUES ('INSERT', TG_TABLE_NAME, current_user, 'Insertado un nuevo registro en Genero');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_genero
AFTER INSERT ON Genero
FOR EACH ROW EXECUTE FUNCTION log_insert_genero();


-- Triggers para la tabla lugar
CREATE OR REPLACE FUNCTION log_insert_lugar() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bitacora(operacion, tabla, usuario, descripcion)
    VALUES ('INSERT', TG_TABLE_NAME, current_user, 'Insertado un nuevo registro en lugar');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_lugar
AFTER INSERT ON lugar
FOR EACH ROW EXECUTE FUNCTION log_insert_lugar();


-- Triggers para la tabla Tags
CREATE OR REPLACE FUNCTION log_insert_tags() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bitacora(operacion, tabla, usuario, descripcion)
    VALUES ('INSERT', TG_TABLE_NAME, current_user, 'Insertado un nuevo registro en Tags');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_tags
AFTER INSERT ON Tags
FOR EACH ROW EXECUTE FUNCTION log_insert_tags();


-- Triggers para la tabla Empaquetado
CREATE OR REPLACE FUNCTION log_insert_empaquetado() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bitacora(operacion, tabla, usuario, descripcion)
    VALUES ('INSERT', TG_TABLE_NAME, current_user, 'Insertado un nuevo registro en Empaquetado');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_empaquetado
AFTER INSERT ON Empaquetado
FOR EACH ROW EXECUTE FUNCTION log_insert_empaquetado();


-- Triggers para la tabla Estado
CREATE OR REPLACE FUNCTION log_insert_estado() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bitacora(operacion, tabla, usuario, descripcion)
    VALUES ('INSERT', TG_TABLE_NAME, current_user, 'Insertado un nuevo registro en Estado');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_estado
AFTER INSERT ON Estado
FOR EACH ROW EXECUTE FUNCTION log_insert_estado();


-- Triggers para la tabla Lenguaje
CREATE OR REPLACE FUNCTION log_insert_lenguaje() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bitacora(operacion, tabla, usuario, descripcion)
    VALUES ('INSERT', TG_TABLE_NAME, current_user, 'Insertado un nuevo registro en Lenguaje');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_lenguaje
AFTER INSERT ON Lenguaje
FOR EACH ROW EXECUTE FUNCTION log_insert_lenguaje();


-- Triggers para la tabla Scripts
CREATE OR REPLACE FUNCTION log_insert_scripts() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO bitacora(operacion, tabla, usuario, descripcion)
    VALUES ('INSERT', TG_TABLE_NAME, current_user, 'Insertado un nuevo registro en Scripts');
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER insert_trigger_scripts
AFTER INSERT ON Scripts
FOR EACH ROW EXECUTE FUNCTION log_insert_scripts();