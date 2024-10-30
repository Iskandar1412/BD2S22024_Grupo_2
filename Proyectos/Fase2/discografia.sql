-- artista
select a.id as artista_id, a.nombre nombre_artista from artista a 
   where a.nombre  = 'Bad Bunny';

-- talegazo
 select
 	a.id  as artista_id,
 	a.nombre AS nombre_artista,
    t.nombre || 
    CASE 
        WHEN d2.subtipo IS NOT NULL THEN ' + ' || d2.subtipo 
        ELSE '' 
    END AS Discografia,
    d.titulo as titulo,
    CASE 
        WHEN l2.dia IS NOT NULL AND l2.mes IS NOT NULL AND l2.anio IS NOT NULL 
        THEN CONCAT(d.dia_salida , '/', d.mes_salida , '/', d.anio_salida)
        ELSE null
    END AS fecha_salida,
    d.num_lanzamientos,
    d.id as discografia_id
FROM 
    discografia d
JOIN 
    artistacredit ac ON d.creditos = ac.id_artista_credito
JOIN 
    nombreartistacredito n ON ac.id_artista_credito = n.id_artista_credito
JOIN 
    artista a ON n.id_artista = a.id
JOIN 
    tipogrupo t ON t.id = d.tipo 
join 
	lugar l on a.id_lugar  = l.id 
join
	lugarlanzamiento l2 on l2.id_lugar = l.id
LEFT JOIN 
    discsubtipo d2 ON d2.id_disc = d.id
WHERE 
    a.id = 1492430 ; -- este es id artista

   
 -- canciones de album
   SELECT distinct t.id as track_id, t.nombre as cancion, t.duracion as duracion, d.id AS discografia_id, m.id as medio_id, m.formato as formato
        FROM discografia d 
        INNER JOIN lanzamientos l ON d.id = l.grupo_disc 
        INNER JOIN medio m ON l.id = m.release_id 
        INNER JOIN track t ON m.id = t.id_medio 
        WHERE d.id = 2079977; -- aqui es el id discografia
 
 -- hijole
       select d.id as discografia_id, l.id as lanzamiento_id, l2.id as lugar_lanzamiento_id, l3.id as lugar_id, d.rating as rating, l3.tipo as tipo_lanzamiento_lugar, l3.nombre as lugar_lanzamiento 
       from lanzamientos l
       inner join discografia d on l.grupo_disc = d.id
       inner join lugarlanzamiento l2  on l2.id_lanzamiento = l.id 
       inner join lugar l3 on l3.id = l2.id_lugar
       where d.id = 2079977; -- aqui es el id de la discografia
       
-- tagdiscografia
      select d.id as discografia_id, t.id as tagdisc_id, t2.id as tags_id, t2.nombre as nombre_tag from discografia d 
      inner join tagsdisc t on d.id = t.id_disc 
      inner join tags t2 on t2.id = t.tag_id 
      where d.id = 2079977; -- aqui es el id de la discografia
      
-- labels
      select d.id as discografia_id, l.cod_barra as codigo_barras, l2.descripcion as label, l3.anio as anio_lanzamiento 
      from discografia d 
      inner join lanzamientos l on l.grupo_disc  = d.id 
      inner join labellanzamientos l2  on l2.id_lanzamiento = l.id 
      join lugarlanzamiento l3 on l3.id_lanzamiento = l.id 
      where d.id = 2079977; -- aqui es el id de la discografia