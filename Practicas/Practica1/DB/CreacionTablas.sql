-- Usuarios
CREATE TABLE Usuarios (
    Id SERIAL PRIMARY KEY,
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Birth DATE NOT NULL,
    Pass VARCHAR(100) NOT NULL,
    Credits INT DEFAULT 0,
    EmailConfirmed BOOLEAN DEFAULT FALSE
);

-- Roles
CREATE TABLE Roles (
    Id SERIAL PRIMARY KEY,
    RoleName VARCHAR(50) UNIQUE NOT NULL
);

-- ProfileStudent
CREATE TABLE ProfileStudent (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    RoleId INT REFERENCES Roles(Id)
);

-- TFA (Two Factor Authentication)
CREATE TABLE TFA (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    IsActive BOOLEAN DEFAULT FALSE
);

-- Notification
CREATE TABLE Notification (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    Mesage TEXT NOT NULL,
    SentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Course
CREATE TABLE Course (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CreditsRequired INT NOT NULL
);

-- TutorProfile
CREATE TABLE TutorProfile (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    CourseId INT REFERENCES Course(Id)
);

-- CourseAssignment
CREATE TABLE CourseAssignment (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    CourseId INT REFERENCES Course(Id),
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- HistoryLog
CREATE TABLE HistoryLog (
    Id SERIAL PRIMARY KEY,
    Action VARCHAR(50) NOT NULL,
    TableName VARCHAR(50) NOT NULL,
    RecordId INT NOT NULL,
    TimeStampLog TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    StatusLog VARCHAR(20) NOT NULL
);
