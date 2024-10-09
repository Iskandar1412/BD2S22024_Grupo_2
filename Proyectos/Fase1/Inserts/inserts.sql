EXEC InsertCountry @name = 'United States', @iso_code = 'US';
EXEC InsertArtist 
    @name = 'Artist Example', 
    @sort_name = 'Example, Artist', 
    @begin_date = '1990-01-01', 
    @end_date = NULL, 
    @type = 'Person', 
    @gender = 'Male', 
    @country_id = 1,  -- ID del país que acabamos de insertar
    @area = 'North America', 
    @description = 'A famous artist from the US';
EXEC InsertArtistCredit 
    @name = 'Artist Example';
EXEC InsertArtistCreditName
    @artist_credit_id = 1,   -- ID del crédito de artista
    @artist_id = 1,          -- ID del artista
    @position = 1;           -- Posición en el crédito
EXEC InsertAlbum 
    @title = 'Album Example', 
    @release_date = '2024-01-01', 
    @artist_id = 1;  -- ID del artista que acabamos de insertar
EXEC InsertRecording 
    @title = 'Example Song', 
    @length = '00:04:30', 
    @artist_credit_id = 1;  -- ID del crédito de artista
EXEC InsertTrack 
    @title = 'Example Song', 
    @duration = '00:04:30', 
    @album_id = 1,           -- ID del álbum que acabamos de insertar
    @recording_id = 1,       -- ID de la grabación que acabamos de insertar
    @rating = 4.5;           -- Ejemplo de una puntuación
EXEC InsertGenre @name = 'Rock';
EXEC InsertArtistGenre 
    @artist_id = 1,  -- ID del artista
    @genre_id = 1;   -- ID del género que acabamos de insertar
EXEC InsertTrackGenre 
    @track_id = 1,  -- ID de la canción (track) que acabamos de insertar
    @genre_id = 1;  -- ID del género
EXEC InsertArtistAlias 
    @artist_id = 1, 
    @alias = 'The Example', 
    @sort_name = 'Example, The';
EXEC InsertLabel 
    @name = 'Example Label', 
    @country_id = 1,           -- ID del país
    @established_date = '2000-01-01', 
    @description = 'A popular music label';
EXEC InsertAlbumLabel 
    @album_id = 1,   -- ID del álbum
    @label_id = 1;   -- ID del sello discográfico
EXEC InsertCopyright 
    @copyright_holder = 'Example Artist', 
    @copyright_year = 2024, 
    @copyright_notice = 'All rights reserved', 
    @type = 'Song';
EXEC InsertTrackCopyright 
    @track_id = 1,           -- ID de la canción
    @copyright_id = 1;       -- ID del derecho de autor
EXEC InsertAlbumCopyright 
    @album_id = 1,           -- ID del álbum
    @copyright_id = 1;       -- ID del derecho de autor
EXEC InsertReleaseGroup 
    @title = 'Album Example', 
    @artist_credit_id = 1, 
    @type = 'Album';
EXEC InsertRelease 
    @title = 'Album Example Release', 
    @release_group_id = 1,     -- ID del grupo de lanzamientos
    @artist_credit_id = 1,     -- ID del crédito del artista
    @release_date = '2024-01-01', 
    @label_id = 1,             -- ID del sello discográfico
    @country_id = 1;           -- ID del país
EXEC InsertMedium 
    @release_id = 1,           -- ID del lanzamiento
    @format = 'CD', 
    @position = 1;             -- CD 1, en caso de tener múltiples discos
EXEC InsertRating 
    @track_id = 1,             -- ID de la canción (track)
    @user_id = 1,              -- ID del usuario que está calificando (cambiar por un usuario válido)
    @rating = 5;               -- Puntuación del usuario (ejemplo: 5 estrellas)
EXEC InsertTag @name = 'Example Tag';
EXEC InsertArtistTag 
    @artist_id = 1,  -- ID del artista que ya habíamos insertado
    @tag_id = 1;     -- ID de la etiqueta que acabamos de insertar
EXEC InsertAlbumTag 
    @album_id = 1,  -- ID del álbum que ya habíamos insertado
    @tag_id = 1;    -- ID de la etiqueta que acabamos de insertar
EXEC InsertTrackTag 
    @track_id = 1,  -- ID de la canción que ya habíamos insertado
    @tag_id = 1;    -- ID de la etiqueta que acabamos de insertar
