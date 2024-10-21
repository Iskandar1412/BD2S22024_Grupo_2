-- TABLAS AREA, TAGS, GENEROS, EMPAQUETADO, ESTADO, LENGUAJE, SCRIPT
select id,name from gender;
select area.id,area.name,area_type.name as tipo from area full outer join area_type on area.type = area_type.id;
select id,name from tag;
select id,name,description from release_packaging;
select id,name,description from release_status;
select * from language;
select * from script;

-- CORRESPONDE A LAS TABLAS DE ARTISTAS
-- carga de tipos de artistas
select id,name from artist_type;

-- tabla artista
select artist.id,artist.name,artist.comment,artist_type.name as tipo,artist.gender,artist.area,artist.begin_date_year,artist.begin_date_month,artist.begin_date_day,artist.end_date_year,artist.end_date_month,artist.end_date_day,artist.begin_area,artist.end_area from artist full outer join artist_type on artist.type = artist_type.id;

-- tabla isni

-- tabla de ratings de artistas
select * from artist_meta;

-- tablas de tags de artistas
select artist,tag from artist_tag;
-- artisas agrupados
select id,name,artist_count from artist_credit;

-- relacion de artista individual con grupos de artistas para lanzamientos
select artist_credit,artist,name from artist_credit_name;

-- CORESSPONDE A LAS TABLAS PARA DISCOGRAFIA
-- tabla tipo principal de discografia
select id,name,description from release_group_primary_type;

-- tabla discografia
select release_group.id,release_group.name,release_group.type,release_group.artist_credit,release_group_meta.rating,release_group_meta.rating_count,release_group_meta.release_count ,release_group_meta.first_release_date_year,release_group_meta.first_release_date_month,release_group_meta.first_release_date_day from release_group full outer join release_group_meta on release_group_meta.id = release_group.id;

-- tabla de tipos secundarios de discografia
select release_group_secondary_type_join.release_group,release_group_secondary_type.name as tipo from release_group_secondary_type_join full outer join release_group_secondary_type on release_group_secondary_type.id = release_group_secondary_type_join.secondary_type;

-- tags de la discografia
select release_group,tag from release_group_tag;



-- CORESSPONDE A LAS TABLAS PARA LANZAMIENTOS
-- Tabla de lanzamientos
select id,name,artist_credit,release_group,packaging,status,language,script,barcode,quality,comment from release;

-- Tabla de los paises de lanzamiento
select * from release_country;

-- Tabla de labels para release
select release_label.id,release_label.release,label.name from release_label full outer join label on release_label.label = label.id;

-- Tabla de catalogos para release
select id,release,catalog_number from release_label;

-- Tabla para los formatos de los release
select medium.id,medium.release,medium_format.name,medium."position" from medium full outer join medium_format on medium.format = medium_format.id where medium_format.name like '%Minimax%';

-- Tabla para tags de release
select release,tag from release_tag;

-- CORRESPONDIENTE A TODO LO RELACIONADO A RECORDINGS
-- Tabla principal
select id,name,artist_credit,length,comment from recording;

-- Codigos isrc de recording
select id,recording,isrc from isrc;

-- ratings de cada recording
select * from recording_meta;

-- tags relacioandos al recording
select recording,tag from recording_tag;

-- artista del recording
select id,entity0,entity1 from l_artist_recording;

-- CORRESPONDE A TODO LO RELACIONADO A LOS TRACKS
