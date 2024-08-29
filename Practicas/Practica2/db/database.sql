-- SQL Server

CREATE TABLE Paciente (
    id_paciente INT IDENTITY(1, 1) PRIMARY KEY,
    edad INT NOT NULL,
    genero CHAR(1) NOT NULL
);

CREATE TABLE Habitacion (
    id_habitacion INT IDENTITY(1, 1) PRIMARY KEY,
    habitacion VARCHAR(30) NOT NULL
);

CREATE TABLE Log_Habitacion (
    id_log_habitacion INT IDENTITY(1, 1) PRIMARY KEY,
    id_habitacion INT NOT NULL
    timestamp DATETIME DEFAULT GETDATE(),
    status CHAR(1) NOT NULL,
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion)
);

CREATE TABLE Log_Actividad (
    id_log_actividad INT IDENTITY(1, 1) PRIMARY KEY,
    id_paciente INT NOT NULL,
    id_habitacion INT NOT NULL,
    timestamp DATETIME DEFAULT GETDATE(),
    actividad VARCHAR(100) NOT NULL,
    FOREIGN KEY (id_paciente) REFERENCES Paciente(id_paciente),
    FOREIGN KEY (id_habitacion) REFERENCES Habitacion(id_habitacion)
);