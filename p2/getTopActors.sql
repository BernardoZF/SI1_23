CREATE OR REPLACE FUNCTION getTopActors(genre CHAR, OUT Actor CHAR, OUT Num INT, OUT Debut INT, OUT Film CHAR, OUT Director CHAR)
RETURNS SETOF RECORD AS $$
DECLARE
    actor_record RECORD;
BEGIN
    FOR actor_record IN
        SELECT ia.actorname,
               COUNT(*) AS num_movies,
               MIN(im.year) AS debut_year,
               m.movietitle AS movie_title,
               d.directorname AS director
        FROM public.imdb_actors ia
        JOIN public.imdb_actormovies am ON ia.actorid = am.actorid
        JOIN public.imdb_movies im ON am.movieid = im.movieid
        JOIN public.imdb_moviegenres mg ON im.movieid = mg.movieid
        JOIN public.products p ON p.movieid = im.movieid
        JOIN public.orderdetail od ON p.prod_id = od.prod_id
        JOIN public.orders o ON od.orderid = o.orderid
        JOIN public.imdb_directormovies dm ON dm.movieid = im.movieid
        JOIN public.imdb_directors d ON dm.directorid = d.directorid
        JOIN (
            SELECT DISTINCT ON (am.actorid) am.actorid, m.movietitle
            FROM public.imdb_actormovies am
            JOIN public.imdb_movies m ON am.movieid = m.movieid
            JOIN public.imdb_moviegenres mg ON m.movieid = mg.movieid
            WHERE mg.genre = getTopActors.genre
            ORDER BY am.actorid, m.year
        ) AS m ON ia.actorid = m.actorid
        WHERE mg.genre = getTopActors.genre
        GROUP BY ia.actorname, m.movietitle, d.directorname
        HAVING COUNT(*) > 4
        ORDER BY num_movies DESC
    LOOP
        Actor := actor_record.actorname;
        Num := actor_record.num_movies;
        Debut := actor_record.debut_year;
        Film := actor_record.movie_title;
        Director := actor_record.director;
        RETURN NEXT;
    END LOOP;

    RETURN;
END;
$$ LANGUAGE plpgsql;
