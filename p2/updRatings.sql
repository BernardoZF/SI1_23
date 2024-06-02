CREATE OR REPLACE FUNCTION update_movie_ratings()
RETURNS TRIGGER AS $$
DECLARE
    total_ratings numeric;
    new_rating_count integer;
    new_rating_mean numeric;
BEGIN
    -- Calcular el nuevo número total de valoraciones para la película
    SELECT COUNT(*) INTO total_ratings
    FROM public.ratings
    WHERE movieid = NEW.movieid;

    -- Actualizar el campo ratingcount en la tabla imdb_movies
    UPDATE public.imdb_movies
    SET ratingcount = total_ratings
    WHERE movieid = NEW.movieid;

    -- Calcular el nuevo ratingmean para la película
    SELECT COALESCE(AVG(rating), 0) INTO new_rating_mean
    FROM public.ratings
    WHERE movieid = NEW.movieid;

    -- Actualizar el campo ratingmean en la tabla imdb_movies
    UPDATE public.imdb_movies
    SET ratingmean = new_rating_mean
    WHERE movieid = NEW.movieid;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER updRatings
AFTER INSERT OR UPDATE OR DELETE ON public.ratings
FOR EACH ROW
EXECUTE FUNCTION update_movie_ratings();
