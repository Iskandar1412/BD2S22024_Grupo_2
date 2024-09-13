-- Dia 1
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Full_d1.bak'WITH FORMAT, INIT, NAME = 'Full Backup for Practica2';
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Differential_d1.bak' WITH DIFFERENTIAL, INIT, NAME = 'Differential Backup for Practica2';
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Log_d1.bak' WITH INIT, NAME = 'Transaction Log Backup for Practica2';

-- Dia 2
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Log_d2.bak' WITH INIT, NAME = 'Transaction Log Backup for Practica2';

-- Dia 3
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Log_d3.bak' WITH INIT, NAME = 'Transaction Log Backup for Practica2';
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Differential_d3.bak' WITH DIFFERENTIAL, INIT, NAME = 'Differential Backup for Practica2';

-- Dia 4
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Log_d4_1.bak' WITH INIT, NAME = 'Transaction Log Backup for Practica2';
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Differential_d4_1.bak' WITH DIFFERENTIAL, INIT, NAME = 'Differential Backup for Practica2';
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Full_d4.bak'WITH FORMAT, INIT, NAME = 'Full Backup for Practica2';
BACKUP DATABASE Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Differential_d4_2.bak' WITH DIFFERENTIAL, INIT, NAME = 'Differential Backup for Practica2';
BACKUP LOG Practica2 TO DISK = '/var/opt/mssql/app/backups/Pr2_Log_d4_2.bak' WITH INIT, NAME = 'Transaction Log Backup for Practica2';


-- Restauracion d1
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Full_d1.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Differentia_d1.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d1.bak' WITH NORECOVERY;
-- Recuperar la base de datos
RESTORE DATABASE Practica2 WITH RECOVERY;

-- Restauracion d2
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Full_d1.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Differentia_d1.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d1.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d2.bak' WITH NORECOVERY;
-- Recuperar la base de datos
RESTORE DATABASE Practica2 WITH RECOVERY;

-- Restauracion d3
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Full_d1.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Differentia_d1.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d1.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d2.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d3.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Differentia_d3.bak' WITH NORECOVERY;
-- Recuperar la base de datos
RESTORE DATABASE Practica2 WITH RECOVERY;

-- Restauracion d4
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Full_d1.bak' WITH NORECOVERY;
RESTORE DATABASE Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Differentia_d1.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d1.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d2.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d3.bak' WITH NORECOVERY;
RESTORE LOG Practica2 FROM DISK = '/var/opt/mssql/app/backups/Pr2_Log_d4_1.bak' WITH NORECOVERY;
-- Recuperar la base de datos
RESTORE DATABASE Practica2 WITH RECOVERY;