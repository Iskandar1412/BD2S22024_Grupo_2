# Utilizar la imagen oficial de SQL Server
FROM mcr.microsoft.com/mssql/server:2019-latest

# Configuración del entorno para aceptar EULA y contraseña
ENV ACCEPT_EULA=Y
ENV SA_PASSWORD=Practica1@
ENV MSSQL_PID=Express

# Exponer puerto
EXPOSE 1433

# Crear un directorio para scripts
RUN mkdir -p /var/opt/mssql/app

# Copiar scripts SQL al contenedor
COPY . /var/opt/mssql/app

# Iniciar SQL Server y ejecutar el script de inicialización
CMD /opt/mssql/bin/sqlservr