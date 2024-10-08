import os

import requests
import pyodbc
import time
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

def validate_and_format_date(date_str):
    """Valida y formatea la fecha. Devuelve None si la fecha es inválida."""
    if date_str is None:
        return None
    try:
        # Intenta parsear la fecha en el formato 'YYYY-MM' o 'YYYY-MM-DD'
        if len(date_str) == 7:  # Formato 'YYYY-MM'
            return f"{date_str}-01"  # Agregar día '01'
        elif len(date_str) == 10:  # Formato 'YYYY-MM-DD'
            return date_str  # Ya es un formato válido
        else:
            return None  # Formato no válido
    except ValueError:
        return None  # Retorna None si hay un error al parsear

def get_db_connection():
    try:
        conn = pyodbc.connect(conn_str)
        return conn
    except Exception as e:
        print(f"Error connecting to database: {e}")
        return None

def insert_country(country_name, iso_code=None):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT id FROM Country WHERE name = ?", (country_name,))
    country = cursor.fetchone()
    if country:
        return country[0]  
    
    cursor.execute("INSERT INTO Country (name, iso_code) VALUES (?, ?)", (country_name, iso_code))
    conn.commit()
    
    cursor.execute("SELECT @@IDENTITY AS id;")
    country_id = cursor.fetchone()[0]
    conn.close()
    return country_id

def insert_artist(artist_data):
    conn = get_db_connection()
    if conn is None:
        print("No se pudo establecer la conexión con la base de datos.")
        return None

    cursor = conn.cursor()
    
    # Obtener el ID del país, si se proporciona
    country_id = insert_country(artist_data['country']) if artist_data['country'] else None
    
    # Comprobar si el artista ya existe
    cursor.execute("SELECT id FROM Artist WHERE name = ? AND sort_name = ?", 
                   (artist_data['name'], artist_data['sort_name']))
    artist = cursor.fetchone()
    if artist:
        conn.close()  # Cerrar la conexión antes de regresar
        return artist[0]  
    

    
    # Validar y formatear las fechas
    begin_date = validate_and_format_date(artist_data.get('begin_date'))
    end_date = validate_and_format_date(artist_data.get('end_date'))

    # Intentar insertar el nuevo artista
    try:
        cursor.execute(""" 
            INSERT INTO Artist (name, sort_name, begin_date, end_date, type, gender, country_id, area, description)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
        """, (
            artist_data['name'], 
            artist_data['sort_name'], 
            begin_date, 
            end_date, 
            artist_data.get('type'), 
            artist_data.get('gender'), 
            country_id, 
            artist_data.get('area'), 
            artist_data.get('description')
        ))
        conn.commit()  # Confirmar la transacción

        # Obtener el ID del artista insertado
        cursor.execute("SELECT @@IDENTITY AS id;")
        artist_id = cursor.fetchone()[0]
        
    except pyodbc.Error as e:
        print(f"Error inserting artist: {e}")
        conn.rollback()  # Revertir la transacción en caso de error
        artist_id = None
    finally:
        conn.close()  # Asegúrate de cerrar la conexión

    return artist_id



def insert_album(album_data):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    artist_id = insert_artist(album_data['artist'])
    
    cursor.execute("SELECT id FROM Album WHERE title = ? AND artist_id = ?", 
                   (album_data['title'], artist_id))
    album = cursor.fetchone()
    if album:
        return album[0]  
    
    cursor.execute("""
        INSERT INTO Album (title, release_date, artist_id)
        VALUES (?, ?, ?)
    """, (album_data['title'], album_data.get('release_date', None), artist_id))
    conn.commit()
    
    cursor.execute("SELECT @@IDENTITY AS id;")
    album_id = cursor.fetchone()[0]
    conn.close()
    return album_id

def insert_track(track_data):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    album_id = insert_album(track_data['album'])
    
    cursor.execute("SELECT id FROM Track WHERE title = ? AND album_id = ?", 
                   (track_data['title'], album_id))
    track = cursor.fetchone()
    if track:
        return track[0]  
    
    cursor.execute("""
        INSERT INTO Track (title, duration, album_id)
        VALUES (?, ?, ?)
    """, (track_data['title'], track_data['duration'], album_id))
    conn.commit()
    
    cursor.execute("SELECT @@IDENTITY AS id;")
    track_id = cursor.fetchone()[0]
    conn.close()
    return track_id

def insert_genre(genre_name):
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT id FROM Genre WHERE name = ?", (genre_name,))
    genre = cursor.fetchone()
    if genre:
        return genre[0]
    
    cursor.execute("INSERT INTO Genre (name) VALUES (?)", (genre_name,))
    conn.commit()
    
    cursor.execute("SELECT @@IDENTITY AS id;")
    genre_id = cursor.fetchone()[0]
    conn.close()
    return genre_id

def insert_artist_genre(artist_id, genre_name):
    genre_id = insert_genre(genre_name)
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT * FROM ArtistGenre WHERE artist_id = ? AND genre_id = ?", (artist_id, genre_id))
    if cursor.fetchone():
        return  
    
    cursor.execute("INSERT INTO ArtistGenre (artist_id, genre_id) VALUES (?, ?)", (artist_id, genre_id))
    conn.commit()
    conn.close()

def insert_track_genre(track_id, genre_name):
    genre_id = insert_genre(genre_name)
    conn = get_db_connection()
    cursor = conn.cursor()
    
    cursor.execute("SELECT * FROM TrackGenre WHERE track_id = ? AND genre_id = ?", (track_id, genre_id))
    if cursor.fetchone():
        return  
    
    cursor.execute("INSERT INTO TrackGenre (track_id, genre_id) VALUES (?, ?)", (track_id, genre_id))
    conn.commit()
    conn.close()

def fetch_all_artists_from_musicbrainz():
    offset = 0
    limit = 100  
    has_more_artists = True

    while has_more_artists:
        url = "https://musicbrainz.org/ws/2/artist/"
        params = {
            'query': 'artist:*',  
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

                    artist_id = insert_artist(formatted_artist_data)

                    if artist_info.get('tags'):
                        for tag in artist_info['tags']:
                            insert_artist_genre(artist_id, tag['name'])
                offset += limit
            else:
                has_more_artists = False

        except requests.exceptions.RequestException as e:
            print(f"Error fetching data from MusicBrainz API: {e}")
            has_more_artists = False  


def init_databaseSchema():
    path = os.path.join(os.path.dirname(__file__), 'database/schema.sql')
    with open(path, 'r', encoding='utf-8') as file:
        sql = file.read()
        conn = get_db_connection()
        cursor = conn.cursor()
        cursor.execute(sql)
        conn.commit()
        conn.close()
    

def main():

    # init_databaseSchema()
    fetch_all_artists_from_musicbrainz()

if __name__ == "__main__":
    main()