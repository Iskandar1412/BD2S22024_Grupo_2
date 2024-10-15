# pip install musicbrainzngs python-dotenv
import os
import requests
import time
import pyodbc
from dotenv import load_dotenv

BASE_URL = "https://musicbrainz.org/ws/2"
HEADERS = {
    'User-Agent': 'MyMusicApp/1.0 (panasgpt69@gmail.com)',
    'Accept': 'application/json'
}

# Cargar las variables de entorno
load_dotenv()

driver = 'ODBC Driver 17 for SQL Server'
server = os.getenv('DB_SERVER')
port = os.getenv('DB_PORT')
database = os.getenv('DB_NAME')

# Variables opcionales para autenticación SQL Server
user = os.getenv('DB_USER')
password = os.getenv('DB_PASSWORD')

# Variable para definir el tipo de autenticación
use_windows_auth = os.getenv('USE_WINDOWS_AUTH', 'False').lower() == 'true'

# Condicional para construir la cadena de conexión
if use_windows_auth:
    # Autenticación de Windows
    conn_str = (
        f"DRIVER={driver};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"Trusted_Connection=yes;"
    )
else:
    # Autenticación SQL Server (con usuario y contraseña)
    conn_str = (
        f"DRIVER={driver};"
        f"SERVER={server};"
        f"DATABASE={database};"
        f"UID={user};"
        f"PWD={password};"
    )

def get_db_connection():
    try:
        conn = pyodbc.connect(conn_str)
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

# Función para ejecutar un procedimiento almacenado
def execute_stored_procedure(proc_name, params):
    conn = get_db_connection()
    cursor = conn.cursor()

    try:
        cursor.execute(proc_name, params)
        conn.commit()
    except Exception as e:
        print(f"Error executing stored procedure {proc_name}: {e}")
        conn.rollback()
    finally:
        conn.close()


# Inserción
def insert_country(country_name, iso_code=None):
    execute_stored_procedure("EXEC InsertCountry @name = ?, @iso_code = ?", (country_name, iso_code))

def insert_artist(artist_data):
    params = (artist_data['name'], artist_data['sort_name'], artist_data['begin_date'], artist_data['end_date'], artist_data['type'], artist_data['gender'], artist_data['country_id'], artist_data['area'], artist_data['description'])
    execute_stored_procedure("EXEC InsertArtist ?, ?, ?, ?, ?, ?, ?, ?, ?", params)

def insert_artist_credit(credit_name):
    execute_stored_procedure("EXEC InsertArtistCredit @name = ?", (credit_name,))

def insert_artist_credit_name(artist_credit_id, artist_id, position):
    execute_stored_procedure("EXEC InsertArtistCreditName @artist_credit_id = ?, @artist_id = ?, @position = ?", 
                             (artist_credit_id, artist_id, position))

def insert_album(album_data):
    execute_stored_procedure("EXEC InsertAlbum @title = ?, @release_date = ?, @artist_id = ?", 
                             (album_data['title'], album_data['release_date'], album_data['artist_id']))

def insert_recording(recording_data):
    execute_stored_procedure("EXEC InsertRecording @title = ?, @length = ?, @artist_credit_id = ?", 
                             (recording_data['title'], recording_data['length'], recording_data['artist_credit_id']))

def insert_track(track_data):
    execute_stored_procedure("EXEC InsertTrack @title = ?, @duration = ?, @album_id = ?, @recording_id = ?, @rating = ?", 
                             (track_data['title'], track_data['duration'], track_data['album_id'], track_data['recording_id'], track_data['rating']))

def insert_genre(genre_name):
    execute_stored_procedure("EXEC InsertGenre @name = ?", (genre_name,))

def insert_artist_genre(artist_id, genre_id):
    execute_stored_procedure("EXEC InsertArtistGenre @artist_id = ?, @genre_id = ?", (artist_id, genre_id))

def insert_track_genre(track_id, genre_id):
    execute_stored_procedure("EXEC InsertTrackGenre @track_id = ?, @genre_id = ?", (track_id, genre_id))

def insert_artist_alias(artist_id, alias, sort_name):
    execute_stored_procedure("EXEC InsertArtistAlias @artist_id = ?, @alias = ?, @sort_name = ?", 
                             (artist_id, alias, sort_name))

def insert_label(label_data):
    execute_stored_procedure("EXEC InsertLabel @name = ?, @country_id = ?, @established_date = ?, @description = ?", 
                             (label_data['name'], label_data['country_id'], label_data['established_date'], label_data['description']))

def insert_album_label(album_id, label_id):
    execute_stored_procedure("EXEC InsertAlbumLabel @album_id = ?, @label_id = ?", (album_id, label_id))

def insert_copyright(copyright_data):
    execute_stored_procedure("EXEC InsertCopyright @copyright_holder = ?, @copyright_year = ?, @copyright_notice = ?, @type = ?", 
                             (copyright_data['holder'], copyright_data['year'], copyright_data['notice'], copyright_data['type']))

def insert_track_copyright(track_id, copyright_id):
    execute_stored_procedure("EXEC InsertTrackCopyright @track_id = ?, @copyright_id = ?", 
                             (track_id, copyright_id))

def insert_album_copyright(album_id, copyright_id):
    execute_stored_procedure("EXEC InsertAlbumCopyright @album_id = ?, @copyright_id = ?", 
                             (album_id, copyright_id))

def insert_release_group(release_group_data):
    execute_stored_procedure("EXEC InsertReleaseGroup @title = ?, @artist_credit_id = ?, @type = ?", 
                             (release_group_data['title'], release_group_data['artist_credit_id'], release_group_data['type']))

def insert_release(release_data):
    execute_stored_procedure("EXEC InsertRelease @title = ?, @release_group_id = ?, @artist_credit_id = ?, @release_date = ?, @label_id = ?, @country_id = ?", 
                             (release_data['title'], release_data['release_group_id'], release_data['artist_credit_id'], release_data['release_date'], release_data['label_id'], release_data['country_id']))

def insert_medium(medium_data):
    execute_stored_procedure("EXEC InsertMedium @release_id = ?, @format = ?, @position = ?", 
                             (medium_data['release_id'], medium_data['format'], medium_data['position']))

def insert_rating(rating_data):
    execute_stored_procedure("EXEC InsertRating @track_id = ?, @user_id = ?, @rating = ?", 
                             (rating_data['track_id'], rating_data['user_id'], rating_data['rating']))

def insert_tag(tag_name):
    execute_stored_procedure("EXEC InsertTag @name = ?", (tag_name,))

def insert_artist_tag(artist_id, tag_id):
    execute_stored_procedure("EXEC InsertArtistTag @artist_id = ?, @tag_id = ?", (artist_id, tag_id))

def insert_album_tag(album_id, tag_id):
    execute_stored_procedure("EXEC InsertAlbumTag @album_id = ?, @tag_id = ?", (album_id, tag_id))

def insert_track_tag(track_id, tag_id):
    execute_stored_procedure("EXEC InsertTrackTag @track_id = ?, @tag_id = ?", (track_id, tag_id))

# https://musicbrainz.org/ws/2
# Función para buscar todos los artistas manejando la paginación
def get_all_artists(limit=100):
    offset = 0
    all_artists = []
    while True:
        url = f"{BASE_URL}/artist/"
        params = {
            'query': 'artist:*',  # Este query busca todos los artistas
            'limit': limit,
            'offset': offset,
            'fmt': 'json'
        }
        try:
            response = requests.get(url, headers=HEADERS, params=params)
            response.raise_for_status()
            data = response.json()

            # Obtener la lista de artistas de la respuesta
            artists = data.get('artists', [])
            if not artists:
                break  # No hay más artistas, salir del bucle

            all_artists.extend(artists)  # Añadir los artistas a la lista global
            offset += limit  # Incrementar el offset para la siguiente página

            # Puedes añadir un delay para evitar sobrecargar la API
            time.sleep(1)
        except requests.RequestException as e:
            print(f"Error fetching artists: {e}")
            break

    return all_artists

# Función para obtener todos los lanzamientos de un artista manejando la paginación
def get_all_releases_by_artist(artist_mbid, limit=100):
    offset = 0
    all_releases = []
    while True:
        url = f"{BASE_URL}/release/"
        params = {
            'artist': artist_mbid,
            'limit': limit,
            'offset': offset,
            'fmt': 'json'
        }
        try:
            response = requests.get(url, headers=HEADERS, params=params)
            response.raise_for_status()
            data = response.json()

            # Obtener la lista de lanzamientos de la respuesta
            releases = data.get('releases', [])
            if not releases:
                break  # No hay más lanzamientos, salir del bucle

            all_releases.extend(releases)  # Añadir los lanzamientos a la lista global
            offset += limit  # Incrementar el offset para la siguiente página

            # Añadir un pequeño retraso para evitar sobrecargar la API
            time.sleep(1)
        except requests.RequestException as e:
            print(f"Error fetching releases for artist {artist_mbid}: {e}")
            break

    return all_releases

# Inserción automática de todos los artistas y álbumes
def insert_all_artists_and_albums():
    artists = get_all_artists(limit=100)
    
    if not artists:
        return

    for artist in artists:
        # Insertar el artista
        artist_name = artist.get('name', '')
        sort_name = artist.get('sort-name', '')
        begin_date = artist.get('life-span', {}).get('begin', None)
        end_date = artist.get('life-span', {}).get('end', None)
        artist_type = artist.get('type', None)
        gender = artist.get('gender', None)
        country = artist.get('country', None)
        
        insert_artist({
            'name': artist_name,
            'sort_name': sort_name,
            'begin_date': begin_date,
            'end_date': end_date,
            'type': artist_type,
            'gender': gender,
            'country_id': country,  # Aquí debes mapear el ID del país desde la tabla Country
            'area': None,
            'description': None
        })

        # Obtener todos los álbumes del artista e insertarlos
        artist_mbid = artist['id']
        albums = get_all_releases_by_artist(artist_mbid)
        
        for album in albums:
            album_title = album.get('title', '')
            release_date = album.get('date', None)
            
            insert_album({
                'title': album_title,
                'release_date': release_date,
                'artist_id': artist_mbid  # El ID del artista ya insertado
            })


# Inicializar el esquema de base de datos
def init_database_schema():
    path = os.path.join(os.path.dirname(__file__), 'database/schema.sql')
    with open(path, 'r', encoding='utf-8') as file:
        sql = file.read()
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(sql)
        conn.commit()
        conn.close()

def init_procedure_schema():
    path = os.path.join(os.path.dirname(__file__), 'Procedures/procedures.sql')
    with open(path, 'r', encoding='utf-8') as file:
        sql_statements = file.read().split('GO')
        conn = get_db_connection()
        cursor = conn.cursor()
        for statement in sql_statements:
            if statement.strip():
                cursor.execute(statement)
        conn.commit()
        conn.close()

# Función principal
def main():
    insert_all_artists_and_albums()

    

if __name__ == "__main__":
    main()
