CREATE OR REPLACE FUNCTION buscar_artista(consulta TEXT)
RETURNS TABLE (
    id_artista INT,
    nombre_artista VARCHAR,
    genero VARCHAR,
    lugar_origen VARCHAR,
    lugar_famoso VARCHAR,
    lugar_inicio VARCHAR,
    lugar_final VARCHAR,
    anio_inicio INT,
    anio_final INT,
    comentario_artista VARCHAR
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        a.id AS id_artista,
        a.nombre::VARCHAR AS nombre_artista,
        g.genero::VARCHAR AS genero,
        lo.nombre::VARCHAR AS lugar_origen,
        lf.nombre::VARCHAR AS lugar_famoso,
        li.nombre::VARCHAR AS lugar_inicio,
        lfn.nombre::VARCHAR AS lugar_final,
        a.anio_inicio,
        a.anio_final,
        LOWER(a.comentario)::VARCHAR AS comentario_artista
    FROM Artista a
    LEFT JOIN Genero g ON a.genero = g.id
    LEFT JOIN Lugar lo ON a.id_lugar = lo.id
    LEFT JOIN Lugar li ON a.lugar_inicio = li.id
    LEFT JOIN Lugar lfn ON a.lugar_final = lfn.id
    LEFT JOIN Lugar lf ON a.id_lugar = lf.id
    WHERE LOWER(a.nombre) ILIKE '%' || LOWER(consulta) || '%'
       OR LOWER(g.genero) ILIKE '%' || LOWER(consulta) || '%'
       OR LOWER(lo.nombre) ILIKE '%' || LOWER(consulta) || '%'
       OR LOWER(lf.nombre) ILIKE '%' || LOWER(consulta) || '%'
       OR LOWER(li.nombre) ILIKE '%' || LOWER(consulta) || '%'
       OR LOWER(lfn.nombre) ILIKE '%' || LOWER(consulta) || '%'
       OR LOWER(a.comentario) ILIKE '%' || LOWER(consulta) || '%';
END;
$$ LANGUAGE plpgsql;

SELECT * FROM buscar_artista('gorillaz');

drop function buscar_artista(text);