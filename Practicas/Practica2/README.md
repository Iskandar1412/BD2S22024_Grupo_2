# Practica 2

> Comandos usados

* Imagen SQL Server

```bash
docker pull mcr.microsoft.com/mssql/server:2019-latest
```

> Comandos para docker

* Correr

```bash
docker-compose up --build
```

* Ingresar a DB como superusuario

```bash
docker exec -it root sqlserver /bin/bash
```

```bash
apt-get update
```

```bash
apt-get install -y curl
```

```bash
curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
```

```bash
curl https://packages.microsoft.com/config/ubuntu/20.04/prod.list > /etc/apt/sources.list.d/mssql-release.list
```

```bash
apt-get update
```

```bash
ACCEPT_EULA=Y apt-get install -y mssql-tools unixodbc-dev
```

```bash
echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc
```

```bash
source ~/.bashrc
```

```bash
sqlcmd -?
```

* Ingresar a db

```bash
sqlcmd -S localhost -U sa -P 'Practica1@'
```

* Ver DB's

```bash
SELECT name FROM sys.databases;
GO
```

* Crear DB

```bash
CREATE DATABASE Practica2;
GO
```

* Eliminar DB

```bash
DROP DATABASE Practica2;
GO
```
