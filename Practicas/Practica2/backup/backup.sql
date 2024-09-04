-- Backup Completo
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Full.bak' WITH FORMAT;

-- Backup Incremental
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Differential.bak' WITH DIFFERENTIAL;

-- Backup Diferencial
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Log.bak';


-- En caso de que de error de permisos
-- ❯ chmod -R 777 ./app/backups
-- ❯ chmod -R 777 ./app