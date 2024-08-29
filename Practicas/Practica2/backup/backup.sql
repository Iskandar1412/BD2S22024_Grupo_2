-- Backup Completo
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Clinica_Full.bak' WITH FORMAT;

-- Backup Incremental
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Clinica_Differential.bak' WITH DIFFERENTIAL;

-- Backup Diferencial
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Clinica_Log.bak';