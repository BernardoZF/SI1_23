from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
from pymongo import MongoClient
import itertools


# Configuracion de la  conexion a postgresql
engine = create_engine('postgresql://alumnodb:alumnodb@localhost:5432/si1')
Session = sessionmaker(bind=engine)
session = Session()

#Prueba de conexion a la base de datos
try:
    session.execute('SELECT 1')
    print("Conexion a la base de datos establecida")
except Exception as e:
    print("Error en la conexion a la base de datos", e)

# Configuracion de la conexion a mongodb
client = MongoClient('localhost', 27017)
db = client.si1

#Prueba de conexion a la base de datos
try:
    db.command('ping')
    print("Conexion a Mongodb establecida")
except Exception as e:
    print("Error en la conexion a Mongodb", e)


# Definir la consulta para extraer películas francesas
query = """
SELECT
    m.movietitle AS title,
    STRING_AGG(DISTINCT g.genre, ', ') AS genres,
    m.year::int,
    array_agg(DISTINCT d.directorname) AS directors,
    array_agg(DISTINCT a.actorname) AS actors
FROM
    imdb_movies m
JOIN
    imdb_moviegenres g ON m.movieid = g.movieid
JOIN
    imdb_directormovies md ON m.movieid = md.movieid
JOIN
    imdb_directors d ON md.directorid = d.directorid
JOIN
    imdb_actormovies ma ON m.movieid = ma.movieid
JOIN
    imdb_actors a ON ma.actorid = a.actorid
JOIN 
    imdb_moviecountries mc ON m.movieid = mc.movieid
WHERE
    mc.country = 'France' OR mc.country LIKE '%France%'
GROUP BY
    m.movietitle, m.year;
"""

# Ejecutar la consulta
movies = session.execute(query).fetchall()

# Transformar los resultados en una lista de diccionarios para facilitar el procesamiento
movie_list = []
for movie in movies:
    movie_dict = {
        "title": movie.title,
        "genres": movie.genres.split(', '),
        "year": movie.year,
        "directors": movie.directors,
        "actors": movie.actors,
        "most_related_movies": [],
        "related_movies": []
    }
    movie_list.append(movie_dict)

# Función para encontrar películas relacionadas
def find_related_movies(movie, movie_list):
    most_related = []
    related = []
    
    for other_movie in movie_list:
        if other_movie["title"] == movie["title"]:
            continue
        
        common_genres = set(movie["genres"]).intersection(set(other_movie["genres"]))
        
        if len(common_genres) == len(movie["genres"]):
            most_related.append({"title": other_movie["title"], "year": other_movie["year"]})
        elif len(common_genres) >= len(movie["genres"]) / 2:
            related.append({"title": other_movie["title"], "year": other_movie["year"]})
    
    # Limitar a 10 resultados
    most_related = sorted(most_related, key=lambda x: x["year"], reverse=True)[:10]
    related = sorted(related, key=lambda x: x["year"], reverse=True)[:10]
    
    return most_related, related

# Procesar cada película para encontrar las relacionadas y cargar en MongoDB
for movie in movie_list:
    most_related, related = find_related_movies(movie, movie_list)
    movie["most_related_movies"] = most_related
    movie["related_movies"] = related
    
    # Insertar el documento en la colección 'france'
    db.france.insert_one(movie)

print("Datos transferidos exitosamente a MongoDB")

# Cerrar las conexiones
session.close()
client.close()
