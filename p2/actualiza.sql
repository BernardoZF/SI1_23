-- Se define una transacción para agrupar todas las operaciones y asegurar que se realicen de manera consistente.
BEGIN;

-- Tabla customers
-- Se agrega una clave primaria para la columna customerid para garantizar que cada cliente tenga una identificación única.
ALTER TABLE public.customers
    ADD CONSTRAINT customers_pk PRIMARY KEY (customerid);

-- Tabla orders
-- Se agrega una clave primaria para la columna orderid para garantizar que cada pedido tenga una identificación única.
-- Se agrega una clave foránea (FK) para la columna customerid que referencia la tabla customers, lo que indica que cada pedido debe estar asociado con un cliente existente.
-- Se especifica ON DELETE CASCADE, lo que significa que si se elimina un cliente, todos los pedidos asociados a ese cliente también se eliminarán.
ALTER TABLE public.orders
    ADD CONSTRAINT orders_pk PRIMARY KEY (orderid),
    ADD CONSTRAINT orders_fk_customerid FOREIGN KEY (customerid) REFERENCES public.customers (customerid) ON DELETE CASCADE;

-- Tabla orderdetail
-- Se agrega una clave foránea (FK) para la columna orderid que referencia la tabla orders, lo que indica que cada detalle del pedido debe estar asociado con un pedido existente.
-- Se agrega una clave foránea (FK) para la columna prod_id que referencia la tabla products, lo que indica que cada detalle del pedido debe estar asociado con un producto existente.
-- Se especifica ON DELETE CASCADE para ambas claves foráneas, lo que significa que si se elimina un pedido o un producto, todos los detalles del pedido asociados también se eliminarán.
ALTER TABLE public.orderdetail
    ADD CONSTRAINT orderdetail_fk_orderid FOREIGN KEY (orderid) REFERENCES public.orders (orderid) ON DELETE CASCADE,
    ADD CONSTRAINT orderdetail_fk_prod_id FOREIGN KEY (prod_id) REFERENCES public.products (prod_id) ON DELETE CASCADE;

-- Tabla products
-- Se agrega una clave primaria para la columna prod_id para garantizar que cada producto tenga una identificación única.
-- Se agrega una clave foránea (FK) para la columna movieid que referencia la tabla imdb_movies, lo que indica que cada producto debe estar asociado con una película existente.
-- Se especifica ON DELETE CASCADE, lo que significa que si se elimina una película, todos los productos asociados a esa película también se eliminarán.
ALTER TABLE public.products
    ADD CONSTRAINT products_pk PRIMARY KEY (prod_id),
    ADD CONSTRAINT products_fk_movieid FOREIGN KEY (movieid) REFERENCES public.imdb_movies (movieid) ON DELETE CASCADE;

-- Tabla imdb_movies
-- Se agrega una clave primaria para la columna movieid para garantizar que cada película tenga una identificación única.

ALTER TABLE public.imdb_movies
    ADD CONSTRAINT imdb_movies_pk PRIMARY KEY (movieid);

-- Se confirma la transacción para aplicar todos los cambios.
COMMIT;

-- Se define una transacción para agrupar todas las operaciones y asegurar que se realicen de manera consistente.
BEGIN;

-- Tabla customers
-- Se agrega una nueva columna "balance" para guardar el saldo de los clientes.
-- Se aumenta el tamaño del campo "password" para poder almacenar contraseñas cifradas con el formato hexadecimal.
ALTER TABLE public.customers
    ADD COLUMN balance numeric,
    ALTER COLUMN password TYPE varchar(96);

-- Tabla ratings
-- Se crea una nueva tabla "ratings" para almacenar las valoraciones de los usuarios a las películas.
-- Se agrega una clave primaria compuesta para evitar que un mismo usuario valore dos veces la misma película.
CREATE TABLE public.ratings (
    customerid integer NOT NULL,
    movieid integer NOT NULL,
    rating numeric NOT NULL,
    CONSTRAINT ratings_pk PRIMARY KEY (customerid, movieid),
    CONSTRAINT ratings_fk_customerid FOREIGN KEY (customerid) REFERENCES public.customers (customerid),
    CONSTRAINT ratings_fk_movieid FOREIGN KEY (movieid) REFERENCES public.imdb_movies (movieid)
);

-- Tabla imdb_movies
-- Se añaden dos nuevas columnas "ratingmean" y "ratingcount" para almacenar la valoración media y el número de valoraciones de cada película.
ALTER TABLE public.imdb_movies
    ADD COLUMN ratingmean numeric,
    ADD COLUMN ratingcount integer;

-- Se confirma la transacción para aplicar todos los cambios.
COMMIT;


-- Trigger para ejecutar la función update_movie_ratings después de insertar o eliminar una fila en ratings.
CREATE TRIGGER ratings_update_trigger
AFTER INSERT OR DELETE ON public.ratings
FOR EACH ROW EXECUTE FUNCTION update_movie_ratings();


CREATE OR REPLACE FUNCTION setCustomersBalance(IN initialBalance bigint)
RETURNS void
AS $$
DECLARE
    random_balance bigint;
BEGIN
    -- Asignar un saldo aleatorio entre 0 y initialBalance a cada cliente.
    UPDATE public.customers
    SET balance = floor(random() * (initialBalance + 1));
END;
$$ LANGUAGE plpgsql;




-- Llamada al procedimiento para inicializar el balance de clientes con N = 200.
SELECT setCustomersBalance(200);

-- Se define una transacción para agrupar todas las operaciones y asegurar que se realicen de manera consistente.
BEGIN;

-- Tabla countries
CREATE TABLE countries (
    country_id SERIAL PRIMARY KEY,
    country_name VARCHAR(100) NOT NULL
);

-- Tabla genres
CREATE TABLE genres (
    genre_id SERIAL PRIMARY KEY,
    genre_name VARCHAR(100) NOT NULL
);

-- Tabla languages
CREATE TABLE languages (
    language_id SERIAL PRIMARY KEY,
    language_name VARCHAR(100) NOT NULL
);

-- Tabla movies
ALTER TABLE public.movies
ADD COLUMN country_id INT,
ADD COLUMN genre_id INT,
ADD COLUMN language_id INT,
ADD CONSTRAINT fk_country FOREIGN KEY (country_id) REFERENCES countries(country_id),
ADD CONSTRAINT fk_genre FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
ADD CONSTRAINT fk_language FOREIGN KEY (language_id) REFERENCES languages(language_id);

-- Migración de datos
INSERT INTO countries (country_name)
SELECT DISTINCT unnest(moviecountries) FROM movies;

INSERT INTO genres (genre_name)
SELECT DISTINCT unnest(moviegenres) FROM movies;

INSERT INTO languages (language_name)
SELECT DISTINCT unnest(movielanguages) FROM movies;

UPDATE movies m
SET country_id = c.country_id
FROM countries c
WHERE m.moviecountries @> ARRAY[c.country_name];

UPDATE movies m
SET genre_id = g.genre_id
FROM genres g
WHERE m.moviegenres @> ARRAY[g.genre_name];

UPDATE movies m
SET language_id = l.language_id
FROM languages l
WHERE m.movielanguages @> ARRAY[l.language_name];

ALTER TABLE movies
DROP COLUMN moviecountries,
DROP COLUMN moviegenres,
DROP COLUMN movielanguages;

-- Se confirma la transacción para aplicar todos los cambios.
COMMIT;