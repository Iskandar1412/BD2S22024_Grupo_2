import requests
import pyodbc
import time


driver = 'ODBC Driver 17 for SQL Server'
server = 'ISKANDAR\\SQLEXPRESS' 
user = 'sa'
password = 'SuperSmash123'
database = 'Proyecto1BD2'

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
    cursor = conn.cursor()
    
    country_id = insert_country(artist_data['country']) if artist_data['country'] else None
    
    cursor.execute("SELECT id FROM Artist WHERE name = ? AND sort_name = ?", 
                   (artist_data['name'], artist_data['sort_name']))
    artist = cursor.fetchone()
    if artist:
        return artist[0]  
    
    cursor.execute("""
        INSERT INTO Artist (name, sort_name, begin_date, end_date, type, gender, country_id, area, description)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)
    """, (
        artist_data['name'], 
        artist_data['sort_name'], 
        artist_data.get('begin_date', None), 
        artist_data.get('end_date', None), 
        artist_data.get('type', None), 
        artist_data.get('gender', None), 
        country_id, 
        artist_data.get('area', None), 
        artist_data.get('description', None)
    ))
    conn.commit()
    
    cursor.execute("SELECT @@IDENTITY AS id;")
    artist_id = cursor.fetchone()[0]
    conn.close()
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

def main():
    fetch_all_artists_from_musicbrainz()

if __name__ == "__main__":
    main()