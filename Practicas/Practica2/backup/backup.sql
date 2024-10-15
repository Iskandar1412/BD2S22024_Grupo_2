-- Backup Completo
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Full.bak'WITH FORMAT, INIT, NAME = 'Full Backup for Practica2';

-- Backup Diferencial
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Differential.bak' WITH DIFFERENTIAL, INIT, NAME = 'Differential Backup for Practica2';

-- Backup Incremental (Estos deben ser varios y secuenciales para no haber errores de seguimiento)
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Log.bak' WITH INIT, NAME = 'Transaction Log Backup for Practica2';


-- En caso de que de error de permisos
-- ❯ chmod -R 777 ./app/backups
-- ❯ chmod -R 777 ./app