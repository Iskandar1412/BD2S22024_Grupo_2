-- Restaurar Backup Completo
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Full.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 WITH RECOVERY;

-- Restaurar Backup Incremental
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Differential.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 WITH RECOVERY;

-- Restaurar Backup Diferencial
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 WITH RECOVERY;
