-- Backup Completo
BACKUP DATABASE Clinica TO DISK = '/var/opt/mssql/backups/Clinica_Full.bak' WITH FORMAT;

-- Backup Incremental
BACKUP DATABASE Clinica TO DISK = '/var/opt/mssql/backups/Clinica_Incremental.bak' WITH DIFFERENTIAL;

-- Backup Diferencial
BACKUP DATABASE Clinica TO DISK = '/var/opt/mssql/backups/Clinica_Diferencial.bak' WITH DIFFERENTIAL;