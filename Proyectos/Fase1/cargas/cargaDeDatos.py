import psycopg2
from psycopg2.extras import execute_values

conn_params_origen = {
    'dbname': 'musicbrainz',
    'user': 'postgres',
    'password': 'kmilo0289',
    'host': '172.17.144.27',
    'port': 5432
}

conn_params_destino = {
    'dbname': 'musicbrainz',
    'user': 'postgres',
    'password': 'kmilo0289',
    'host': '172.17.144.27', 
    'port': 5432
}

conn_origen = psycopg2.connect(**conn_params_origen)
cur_origen = conn_origen.cursor()

cur_origen.execute("SET search_path TO musicbrainz;")

conn_destino = psycopg2.connect(**conn_params_destino)
cur_destino = conn_destino.cursor()

cur_destino.execute("SET search_path TO public;")

def cargar(query_select,batch_size,insert_query):
    cur_origen.execute(query_select)

    while True:
        rows = cur_origen.fetchmany(batch_size)
        
        if not rows:
            break 
        execute_values(cur_destino, insert_query, rows)

        conn_destino.commit()
    print("Transferencia completada con éxito.")

#Función para que toma en cuenta que las llaves pueden ser nulas, de tal manera que no se agregan
def cargarNul(query_select, batch_size, insert_query):
    cur_origen.execute(query_select)

    while True:
        # Obtener un batch de filas
        rows = cur_origen.fetchmany(batch_size)
        
        if not rows:
            break
        
        # Filtrar las filas donde 'id' no es None
        rows_filtradas = [row for row in rows if row[0] is not None]

        if rows_filtradas:
            # Insertar solo las filas que pasaron el filtro
            execute_values(cur_destino, insert_query, rows_filtradas)
            conn_destino.commit()

    print("Transferencia completada con éxito.")

# Función para verificar si el artista existe en la tabla Artista
def verificar_artista(id_artista):
    cur_destino.execute("SELECT id FROM Artista WHERE id = %s", (id_artista,))
    return cur_destino.fetchone() is not None


def cargaIdentArtist(query_select, batch_size, insert_query):
    cur_origen.execute(query_select)

    while True:
        rows = cur_origen.fetchmany(batch_size)
        
        if not rows:
            break
        
        # Filtrar filas para incluir solo aquellas cuyo id_artista existe en la tabla Artista
        filas_filtradas = [row for row in rows if verificar_artista(row[0])]  # row[0] asume que id_artista es la primera columna
        
        if filas_filtradas:
            # Insertar solo las filas con id_artista existente
            execute_values(cur_destino, insert_query, filas_filtradas)
            conn_destino.commit()

    print("Transferencia completada con éxito.")
# ==================================================================================================== CARGA DE TABLAS GENERALES ============================================================================================
cargar("SELECT id,name from gender;",5000,"INSERT INTO Genero (id, genero) VALUES %s;")
cargar("select area.id,area.name,area_type.name as tipo from area full outer join area_type on area.type = area_type.id;",5000,"INSERT INTO lugar (id, nombre,tipo) VALUES %s;")
cargar("select id,name from tag;",5000,"INSERT INTO Tags (id, nombre) VALUES %s;")
cargar("select id,name,description from release_packaging;",5000,"INSERT INTO Empaquetado (id, nombre,descripcion) VALUES %s;")
cargar("select id,name,description from release_status;",5000,"INSERT INTO Estado (id, nombre,descrpcion) VALUES %s;")
cargar("select * from language;",5000,"INSERT INTO Lenguaje (id, iso_code1,iso_code2,iso_code3,nombre,frecuencia,iso_code4) VALUES %s;")
cargar("select * from script;",5000,"INSERT INTO Scripts (id, iso_code,iso_number,nombre,frecuencia) VALUES %s;")
cargar("select id,name from artist_type;",5000,"INSERT INTO TipoArtista (id,nombre) VALUES %s;")

# ==================================================================================================== CARGA DE TABLAS ARTISTAS ============================================================================================
cargar("SELECT artist.id, artist.name, artist.comment, artist.type as tipo, artist.gender, artist.area,artist.begin_date_year, artist.begin_date_month, artist.begin_date_day,artist.end_date_year, artist.end_date_month, artist.end_date_day,artist.begin_area, artist.end_areaFROM artist",5000,"INSERT INTO Artista (id, nombre, comentario, tipo, genero, id_lugar, anio_inicio, mes_inicio, dia_inicio, anio_final, mes_final, dia_final, lugar_inicio, lugar_final) VALUES %s;")
cargaIdentArtist("SELECT * FROM artist_meta;", 5000, "INSERT INTO RatingArtist (id_artista, rating, num_ratings) VALUES %s;")
cargaIdentArtist("SELECT artist, tag FROM artist_tag;", 5000, "INSERT INTO ArtistaTag (artist_id, tag_id) VALUES %s;")
cargar("select id,name,artist_count from artist_credit;",5000,"INSERT INTO ArtistaCredit (id_artista_credito,nombre,total_artistas) VALUES %s;")
cargaIdentArtist("select artist_credit,artist,name from artist_credit_name;", 5000, "INSERT INTO NombreArtistaCredito (id_artista_credito, id_artista,nombre_artista_individual) VALUES %s;")

# ==================================================================================================== CARGA PARA DISCOGRAFIA ============================================================================================
cargar("select id,name,description from release_group_primary_type;",5000,"INSERT INTO TipoGrupo (id, nombre,descripcion) VALUES %s;")
cargar("select release_group.id,release_group.name,release_group.type,release_group.artist_credit,release_group_meta.rating,release_group_meta.rating_count,release_group_meta.release_count ,release_group_meta.first_release_date_year,release_group_meta.first_release_date_month,release_group_meta.first_release_date_day from release_group join release_group_meta on release_group_meta.id = release_group.id;",5000,"INSERT INTO Discografia (id, titulo,tipo,creditos,rating,num_calificaciones,num_lanzamientos,anio_salida,mes_salida,dia_salida) VALUES %s;")
cargar("select release_group_secondary_type_join.release_group,release_group_secondary_type.name as tipo from release_group_secondary_type_join full outer join release_group_secondary_type on release_group_secondary_type.id = release_group_secondary_type_join.secondary_type;",10000,"INSERT INTO DiscSubTipo(id_disc,subtipo) VALUES %s;");
cargar("select release_group,tag from release_group_tag;",10000,"INSERT INTO TagsDisc(id_disc,tag_id) VALUES %s;");


# ==================================================================================================== CARGA PARA LANZAMIENTOS ============================================================================================
cargar("select id,name,artist_credit,release_group,packaging,status,language,script,barcode,quality,comment from release;",10000,"INSERT INTO Lanzamientos(id,nombre,creditos,grupo_disc,empaquetado,estado,lenguaje,script,cod_barra,calidad,comentario) VALUES %s;");
cargar("select * from release_country;",10000,"INSERT INTO lugarLanzamiento(id_lanzamiento,id_lugar,anio,mes,dia) VALUES %s;");
cargar("select release_label.id,release_label.release,label.name from release_label full outer join label on release_label.label = label.id;",10000,"INSERT INTO LabelLanzamientos(id_label,id_lanzamiento,descripcion) VALUES %s;");
cargar("select id,release,catalog_number from release_label;",10000,"INSERT INTO CatalogoLanzamientos(id_catalogo,id_lanzamiento,catalogo) VALUES %s;");
cargarNul("select medium.id,medium.release,medium_format.name,medium.position from medium full outer join medium_format on medium.format = medium_format.id;",10000,"INSERT INTO Medio(id,release_id,formato,posicion) VALUES %s;");
cargar("select release,tag from release_tag;",10000,"INSERT INTO TagLanzamientos(id_release,id_tag) VALUES %s;");

# ==================================================================================================== CARGA PARA RECORDINGS ============================================================================================
cargar("select id,name,artist_credit,length,comment from recording;",10000,"INSERT INTO Recording(id,title,artist_credit_id,duracion,comentario) VALUES %s;");
cargar("select * from recording_meta;",10000,"INSERT INTO RatingRecording(id_recording,calificacion,num_calificaciones) VALUES %s;");
cargar("select id,recording,isrc from isrc;",10000,"INSERT INTO ISRCRecording(id,id_recording,valor_isrc) VALUES %s;");
cargar("select recording,tag from recording_tag;",10000,"INSERT INTO TagRecording(id_recording,id_tag) VALUES %s;");
cargar("select id,entity0,entity1 from l_artist_recording;",10000,"INSERT INTO ArtistaRecording(id,id_artista,id_recording) VALUES %s;");

# ==================================================================================================== CARGA PARA TRACK ============================================================================================
cargar("select id,recording,medium,number,name,artist_credit,length from track;",10000,"INSERT INTO Track(id,id_recording,id_medio,numero,nombre,id_creditos,duracion) VALUES %s;");

cur_origen.close()
cur_destino.close()
conn_origen.close()
conn_destino.close()