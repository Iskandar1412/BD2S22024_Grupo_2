-- Restaurar Backup Completo
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Clinica_Full.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 WITH RECOVERY;

-- Restaurar Backup Incremental
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Clinica_Differential.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 WITH RECOVERY;

-- Restaurar Backup Diferencial
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Clinica_Log.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 WITH RECOVERY;
