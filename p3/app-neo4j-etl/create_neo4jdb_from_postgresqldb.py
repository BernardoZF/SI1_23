from neo4j import GraphDatabase
from sqlalchemy import create_engine, text
from sqlalchemy.orm import sessionmaker

# Configuración de la conexión a PostgreSQL
engine = create_engine('postgresql://alumnodb:alumnodb@localhost:5432/si1')
Session = sessionmaker(bind=engine)
session = Session()

# Configuración de la conexión a Neo4j
uri = "bolt://localhost:7687"
driver = GraphDatabase.driver(uri, auth=("neo4j", "si1-password"))

# Prueba de conexión a PostgreSQL
try:
    session.execute('SELECT 1')
    print("Conexión a la base de datos PostgreSQL establecida")
except Exception as e:
    print("Error en la conexión a la base de datos PostgreSQL:", e)

# Prueba de conexión a Neo4j
try:
    with driver.session() as session:
        session.run("RETURN 1")
    print("Conexión a Neo4j establecida")
except Exception as e:
    print("Error en la conexión a Neo4j:", e)

# Extraer datos de PostgreSQL
query = """
SELECT
    m.movieid,
    m.movietitle AS title,
    CASE 
        WHEN m.year ~ '^[0-9]{4}$' THEN m.year::int
        ELSE NULL
    END AS year,
    array_agg(DISTINCT d.directorid || ':' || d.directorname) AS directors,
    array_agg(DISTINCT a.actorid || ':' || a.actorname) AS actors
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
    mc.country = 'USA'
    AND m.year ~ '^[0-9]{4}$'
GROUP BY
    m.movieid, m.movietitle, m.year
ORDER BY
    m.year DESC
LIMIT 20;
"""

connection = engine.connect()
movies = connection.execute(text(query)).fetchall()

# Funciones para crear nodos y relaciones en Neo4j
def create_movie_node(tx, movieid, title, year):
    tx.run("MERGE (m:Movie {movieid: $movieid, title: $title, year: $year})", movieid=movieid, title=title, year=year)

def create_person_node(tx, personid, name, role):
    if role == 'Director':
        tx.run("MERGE (p:Person {personid: $personid, name: $name}) SET p:Director", personid=personid, name=name)
    elif role == 'Actor':
        tx.run("MERGE (p:Person {personid: $personid, name: $name}) SET p:Actor", personid=personid, name=name)

def create_relationship(tx, movieid, personid, role):
    if role == 'Director':
        tx.run("""
            MATCH (m:Movie {movieid: $movieid}),
                  (p:Person {personid: $personid})
            MERGE (p)-[:DIRECTED]->(m)
            """, movieid=movieid, personid=personid)
    elif role == 'Actor':
        tx.run("""
            MATCH (m:Movie {movieid: $movieid}),
                  (p:Person {personid: $personid})
            MERGE (p)-[:ACTED_IN]->(m)
            """, movieid=movieid, personid=personid)

# Crear nodos y relaciones en Neo4j
with driver.session() as session:
    for movie in movies:
        session.execute_write(create_movie_node, movie.movieid, movie.title, movie.year)
        for director in movie.directors:
            director_id, director_name = director.split(':')
            session.execute_write(create_person_node, director_id, director_name, 'Director')
            session.execute_write(create_relationship, movie.movieid, director_id, 'Director')
        for actor in movie.actors:
            actor_id, actor_name = actor.split(':')
            session.execute_write(create_person_node, actor_id, actor_name, 'Actor')
            session.execute_write(create_relationship, movie.movieid, actor_id, 'Actor')

print("Datos transferidos exitosamente a Neo4j")
connection.close()
driver.close()