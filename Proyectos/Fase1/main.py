import os
import requests
import pyodbc
from dotenv import load_dotenv

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

# Funciones para insertar en la base de datos usando los procedimientos almacenados

def insert_country(country_name, iso_code=None):
    execute_stored_procedure("EXEC InsertCountry @name = ?, @iso_code = ?", (country_name, iso_code))

def insert_artist(artist_data):
    params = (
        artist_data['name'],
        artist_data['sort_name'],
        artist_data['begin_date'],
        artist_data['end_date'],
        artist_data['type'],
        artist_data['gender'],
        artist_data['country_id'],
        artist_data['area'],
        artist_data['description']
    )
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

# Función para obtener los artistas desde la API de MusicBrainz y realizar las inserciones en la base de datos
def fetch_all_artists_from_musicbrainz():
    offset = 0
    limit = 100  # Número de resultados por página
    has_more_artists = True

    while has_more_artists:
        url = "https://musicbrainz.org/ws/2/artist/"
        params = {
            'query': 'artist:*',  # Buscar todos los artistas
            'fmt': 'json',
            'limit': limit,
            'offset': offset
        }
        headers = {
            'User-Agent': 'MyMusicApp/1.0 ( your-email@example.com )'
        }

        try:
            response = requests.get(url, headers=headers, params=params)
            response.raise_for_status()
            data = response.json()

            if data and data['artists']:
                for artist_info in data['artists']:
                    formatted_artist_data = {
                        'name': artist_info['name'],
                        'sort_name': artist_info['sort-name'],
                        'begin_date': artist_info.get('life-span', {}).get('begin'),
                        'end_date': artist_info.get('life-span', {}).get('end'),
                        'type': artist_info.get('type'),
                        'gender': artist_info.get('gender'),
                        'country': artist_info.get('country'),
                        'area': artist_info.get('area', {}).get('name'),
                        'description': artist_info.get('disambiguation')
                    }

                    # Insertar artista
                    artist_id = insert_artist(formatted_artist_data)

                    # Insertar géneros relacionados con el artista
                    if artist_info.get('tags'):
                        for tag in artist_info['tags']:
                            insert_artist_genre(artist_id, tag['name'])

                # Actualizar el offset para la siguiente página
                offset += limit
            else:
                # No hay más artistas para procesar
                has_more_artists = False

        except requests.exceptions.RequestException as e:
            print(f"Error fetching data from MusicBrainz API: {e}")
            has_more_artists = False  # Detener si hay un error

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

# Función principal
def main():
    # Puedes usar esta función para inicializar la base de datos si es necesario
    # init_database_schema()

    # Obtener artistas desde MusicBrainz e insertarlos en la base de datos
    fetch_all_artists_from_musicbrainz()

if __name__ == "__main__":
    main()
