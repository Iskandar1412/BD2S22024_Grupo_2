-- Collation a nivel de base de datos
SELECT datname, datcollate, datctype
FROM pg_database
WHERE datname = 'fase1';

-- Collation a nivel de columna
SELECT column_name, collation_name
FROM information_schema.columns
WHERE table_name = 'genero';

-- Alter del collation de columnas de una tabla
ALTER TABLE genero
ALTER COLUMN genero TYPE character varying(25) COLLATE "en_FI";