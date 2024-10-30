import requests
import psycopg2
from psycopg2.extras import execute_values
import time

# Configuración de la conexión a PostgreSQL
DB_HOST = "172.17.144.27"
DB_NAME = "musicbrainz"
DB_USER = "postgres"
DB_PASSWORD = "kmilo0289"
DB_PORT = "5432"

# Función para obtener datos de la API de MusicBrainz con reintentos
def obtener_datos_musicbrainz(offset, retries=5, wait_time=5):
    url = f"https://musicbrainz.org/ws/2/artist/?query=artist:*&limit=100&offset={offset}&fmt=json"
    for intento in range(retries):
        try:
            response = requests.get(url)
            if response.status_code == 200:
                # Obtener la lista de artistas
                return response.json()['artists']  # Retornar la lista de artistas
            elif response.status_code == 503:
                print(f"Error 503: Servicio no disponible. Reintentando en {wait_time * (intento + 1)} segundos...")
                time.sleep(wait_time * (intento + 1))  # Aumentar el tiempo de espera en cada intento
            else:
                print(f"Error en la solicitud: {response.status_code}")
                return []
        except requests.ConnectionError as e:
            print(f"Error de conexión: {e}. Reintentando en {wait_time} segundos...")
            time.sleep(wait_time)
    return []  # Si todos los intentos fallan, regresar lista vacía

# Función para convertir valores en NULL si están vacíos o inválidos
def convertir_a_int(valor):
    try:
        return int(valor)
    except (ValueError, TypeError):
        return None

# Función para insertar datos de artist_isni en la base de datos
def insertar_datos_en_db_artist_isni(con, datos):
    with con.cursor() as cur:
        sql = """
        INSERT INTO musicbrainz.artist_isni 
        (artist, isni, edits_pending, created) 
        VALUES %s
        ON CONFLICT (artist, isni) DO NOTHING
        """
        # Crear una lista de tuplas con los datos
        valores = []
        for artist in datos:
            artist_id = artist.get('id')
            isni_list = artist.get('isni-list', [])  # Acceder a la lista de ISNIs
            edits_pending = convertir_a_int(artist.get('edits_pending', 0))  # Si edits_pending no está presente, asumimos 0
            created = artist.get('created')  # Tomar el valor de 'created'

            # Crear una entrada para cada ISNI asociado con el artista
            for isni in isni_list:
                valores.append((
                    artist_id,
                    isni,
                    edits_pending,
                    created
                ))

        # Insertar los valores en la base de datos
        execute_values(cur, sql, valores)
        con.commit()

# Función principal
def main():
    # Conectar a la base de datos PostgreSQL
    con = psycopg2.connect(
        host=DB_HOST,
        dbname=DB_NAME,
        user=DB_USER,
        password=DB_PASSWORD,
        port=DB_PORT
    )
    
    # Cambia este valor para empezar desde el registro deseado
    offset = 0
    
    while True:
        # Obtener datos de la API en lotes de 100 con reintentos
        datos = obtener_datos_musicbrainz(offset)
        if not datos:
            break  # Si no hay más datos, salimos del loop

        # Insertar los datos de artist_isni en la base de datos
        insertar_datos_en_db_artist_isni(con, datos)

        # Incrementar el offset para obtener el siguiente lote
        offset += 100

    # Cerrar la conexión
    con.close()

if __name__ == "__main__":
    main()
