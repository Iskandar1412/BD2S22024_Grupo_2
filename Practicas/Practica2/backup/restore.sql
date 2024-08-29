-- Restaurar Backup Completo
RESTORE DATABASE Clinica FROM DISK = '/var/opt/mssql/backups/Clinica_Full.bak' WITH NORECOVERY;

-- Restaurar Backup Incremental
RESTORE DATABASE Clinica FROM DISK = '/var/opt/mssql/backups/Clinica_Incremental.bak' WITH NORECOVERY;

-- Restaurar Backup Diferencial
RESTORE DATABASE Clinica FROM DISK = '/var/opt/mssql/backups/Clinica_Diferencial.bak' WITH NORECOVERY;
