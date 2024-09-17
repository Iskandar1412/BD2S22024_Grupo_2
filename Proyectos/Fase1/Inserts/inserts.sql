-- Insertar país China
EXEC InsertCountry @country_name = 'China', @iso_code = 'CN';

-- Insertar artista Hoyomix
EXEC InsertArtist 
    @artist_name = 'Hoyomix',
    @sort_name = 'Hoyomix',
    @country_name = 'China',
    @area = 'Shanghai',
    @begin_date = '2019-01-01',  -- Año en que se formó o empezó a hacerse conocido
    @end_date = NULL,
    @type = 'Group',  -- Asumimos que Hoyomix es un grupo o colectivo musical
    @gender = NULL,  -- Sin género porque es un grupo
    @description = 'Music production group known for Genshin Impact soundtracks';

-- Insertar género Instrumental
EXEC InsertGenre @genre_name = 'Instrumental';

-- Insertar género Video Game Music
EXEC InsertGenre @genre_name = 'Video Game Music';

-- Insertar álbum The Wind and The Star Traveler (de Genshin Impact)
EXEC InsertAlbum 
    @album_title = 'The Wind and The Star Traveler', 
    @release_date = '2020-09-28',  -- Fecha de lanzamiento del juego y del álbum
    @artist_name = 'Hoyomix',
    @artist_country = 'China';

-- Insertar canción A New Day with Hope
EXEC InsertTrack 
    @track_title = 'A New Day with Hope',
    @duration = '02:34',
    @album_title = 'The Wind and The Star Traveler',
    @artist_name = 'Hoyomix',
    @artist_country = 'China',
    @genre_name = 'Instrumental';  -- Específico para esta canción

-- Insertar canción Whirlwind of Leaves
EXEC InsertTrack 
    @track_title = 'Whirlwind of Leaves',
    @duration = '03:12',
    @album_title = 'The Wind and The Star Traveler',
    @artist_name = 'Hoyomix',
    @artist_country = 'China',
    @genre_name = 'Video Game Music';  -- Específico para esta canción

-- Insertar sello discográfico miHoYo
EXEC InsertLabel 
    @label_name = 'miHoYo',
    @country_name = 'China',
    @established_date = '2012-02-13',  -- Fecha en que se estableció miHoYo
    @description = 'Chinese video game developer and music publisher for Genshin Impact soundtracks';

-- Insertar derechos de autor para el álbum The Wind and The Star Traveler
EXEC InsertAlbumCopyright 
    @album_title = 'The Wind and The Star Traveler',
    @artist_name = 'Hoyomix',
    @artist_country = 'China',
    @copyright_holder = 'miHoYo',
    @copyright_year = 2020,
    @copyright_notice = 'All rights reserved';

-- Insertar derechos de autor para la canción A New Day with Hope
EXEC InsertTrackCopyright 
    @track_title = 'A New Day with Hope',
    @album_title = 'The Wind and The Star Traveler',
    @artist_name = 'Hoyomix',
    @artist_country = 'China',
    @copyright_holder = 'miHoYo',
    @copyright_year = 2020,
    @copyright_notice = 'All rights reserved';

-- Insertar derechos de autor para la canción Whirlwind of Leaves
EXEC InsertTrackCopyright 
    @track_title = 'Whirlwind of Leaves',
    @album_title = 'The Wind and The Star Traveler',
    @artist_name = 'Hoyomix',
    @artist_country = 'China',
    @copyright_holder = 'miHoYo',
    @copyright_year = 2020,
    @copyright_notice = 'All rights reserved';

-- Insertar etiquetas para el artista Hoyomix
EXEC InsertTag 
    @entity_type = 'Artist',
    @entity_id = 1,  -- Reemplazar con el ID real del artista 'Hoyomix'
    @tag_name = 'Genshin Impact';

-- Insertar etiquetas para el álbum The Wind and The Star Traveler
EXEC InsertTag 
    @entity_type = 'Album',
    @entity_id = 1,  -- Reemplazar con el ID real del álbum
    @tag_name = 'Epic Music';

-- Insertar etiquetas para la canción A New Day with Hope
EXEC InsertTag 
    @entity_type = 'Track',
    @entity_id = 1,  -- Reemplazar con el ID real de la canción
    @tag_name = 'Game Soundtrack';

-- Insertar etiquetas para la canción Whirlwind of Leaves
EXEC InsertTag 
    @entity_type = 'Track',
    @entity_id = 2,  -- Reemplazar con el ID real de la canción
    @tag_name = 'Genshin Impact Music';
