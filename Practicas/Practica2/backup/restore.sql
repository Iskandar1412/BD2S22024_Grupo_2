-- Restaurar el backup completo
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Full.bak' WITH NORECOVERY;

-- Restaurar el backup diferencial
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Differential.bak' WITH NORECOVERY;

-- Restaurar el log de transacciones (si lo tienes)
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log.bak' WITH NORECOVERY;

-- Recuperar la base de datos
RESTORE DATABASE Practica2 WITH RECOVERY;