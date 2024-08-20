# Practica 1

## Introducción

En el contexto de la Facultad de Ingeniería de la Universidad de San Carlos de Guatemala, se ha identificado la necesidad de mejorar la fiabilidad y consistencia en el manejo de la base de datos que soporta los procesos académicos y administrativos. Con el crecimiento y evolución del sistema, se han detectado diversas inconsistencias, como usuarios sin roles asignados, asignaciones de cursos incorrectas, y fallos en la atomicidad de las transacciones. Estas problemáticas comprometen la integridad de los datos y afectan la operación diaria de la facultad.

La presente documentación detalla el desarrollo de la Práctica 1 del curso "Sistemas de Bases de Datos 2", cuyo objetivo principal es implementar mecanismos que aseguren la correcta gestión de transacciones en la base de datos, cumpliendo con las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad). A lo largo de esta práctica, se abordarán diversos retos que incluyen la creación de roles y cursos, la gestión de usuarios y la validación de datos, así como la implementación de triggers y procedimientos almacenados para automatizar y asegurar la correcta ejecución de operaciones críticas.

Este documento servirá como guía para la implementación de las soluciones propuestas, detallando las estructuras, procedimientos y funciones desarrolladas para resolver los problemas identificados. Además, se proporcionarán instrucciones claras sobre el proceso de entrega, asegurando que el trabajo cumpla con los estándares académicos y técnicos requeridos. La meta es dotar a la Facultad de una base de datos más robusta y confiable, que soporte adecuadamente sus necesidades actuales y futuras.

## Requisitos del Sistema

> * **Sistema Operativo:** Ubuntu 22.04 o superior / Windows 7 o Superior
> * **Sistema de Base de Datos:** Postgres
> * **Versión Base de Datos:** Latest
> * **Contenedores:** Docker
> * **IDE:** Visual Studio Code (VSCode)
> * **CPU:** Intel Pentium D o AMD Athlon 64 (K8) 2.6GHz.
> * **RAM:** 2GB

## Explicación Tablas

### Creación Tablas

Se creará la tabla de Usuarios la cual se encargará de obtener la información de cada usuario.

```sql
-- Usuarios
CREATE TABLE Usuarios (
    Id SERIAL PRIMARY KEY,
    Firstname VARCHAR(50) NOT NULL,
    Lastname VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Birth DATE NOT NULL,
    Pass VARCHAR(100) NOT NULL,
    Credits INT DEFAULT 0,
    EmailConfirmed BOOLEAN DEFAULT TRUE
);
```

Las tablas de Roles y curso se encargarán de obtener los roles insertados y los cursos que se van a crear.
```sql
-- Roles
CREATE TABLE Roles (
    Id SERIAL PRIMARY KEY,
    RoleName VARCHAR(50) UNIQUE NOT NULL
);
```

```sql
-- Course
CREATE TABLE Course (
    Id SERIAL PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    CreditsRequired INT NOT NULL
);
```

La tabla de HistoryLog se encargará de obtener las acciones de las inserciones y cambios de datos.
```sql
-- HistoryLog
CREATE TABLE HistoryLog (
    Id SERIAL PRIMARY KEY,
    Action VARCHAR(50) NOT NULL,
    TableName VARCHAR(50) NOT NULL,
    RecordId INT NOT NULL,
    TimeStampLog TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    StatusLog VARCHAR(20) NOT NULL
);
```

Se tendrán las las siguientes tablas que harán referencias a las anteriores, las cuales mediante los Procedimientos, se haran verificaciones de la información de los usuarios, creditos, para hacer las respectivas inserciones; en los casos en los que no cumplan los requisitos la información que se quiere insertar (asignación de cursos), retornará un mensaje de error.
```sql
-- ProfileStudent
CREATE TABLE ProfileStudent (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    RoleId INT REFERENCES Roles(Id)
);
```

```sql
-- TFA (Two Factor Authentication)
CREATE TABLE TFA (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    IsActive BOOLEAN DEFAULT FALSE
);
```

```sql
-- Notification
CREATE TABLE Notification (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    Mesage TEXT NOT NULL,
    SentAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

```sql
-- TutorProfile
CREATE TABLE TutorProfile (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    CourseId INT REFERENCES Course(Id)
);
```

```sql
-- CourseAssignment
CREATE TABLE CourseAssignment (
    Id SERIAL PRIMARY KEY,
    UserId INT REFERENCES Usuarios(Id),
    CourseId INT REFERENCES Course(Id),
    AssignedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
```

