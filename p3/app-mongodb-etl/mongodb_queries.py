from pymongo import MongoClient
from prettytable import PrettyTable
import itertools


#conexion a la base de datos
client = MongoClient('localhost', 27017)
db = client.si1

#Consulta 1 Ciencia ficcion entre 1994 y 1998
query1 = {
    "genres": "Sci-Fi",
    "year": {"$gte": 1994, "$lte": 1998}
}

sci_fi_movies = db.france.find(query1)

#Mostrar los resultados
table1 = PrettyTable(["Title", "Genres", "Year", "Directors", "Actors"])
for movie in sci_fi_movies:
    table1.add_row([movie['title'], movie['genres'], movie['year'], ', '.join(movie['directors']), ', '.join(movie['actors'])])
print("Ciencia ficción entre 1994 y 1998")
print(table1)


#Consulta 2 peliculas de drama del anyo 1998 que empieza por "The"

query2 = {
    "genres": { '$in': ["Drama"]},
    "year": 1998,
    "title": {"$regex": "^The", "$options": "i"}
}

drama_movies = db.france.find(query2)

#Mostrar los resultados
table2 = PrettyTable(["Title", "Genres", "Year", "Directors", "Actors"])
for movie in drama_movies:
    table2.add_row([movie['title'], movie['genres'], movie['year'], ', '.join(movie['directors']), ', '.join(movie['actors'])])
print("\nPelículas de drama del año 1998 que empiezan por 'The'")
print(table2)

#Consulta 3 peliculasen las que Faye Dunaway y Viggo Mortensen hayan trabajado juntos
query3 = {
    "actors": {"$all": ["Faye Dunaway", "Viggo Mortensen"]}
}

sharded_movies = db.france.find(query3)

#Mostrar los resultados
table3 = PrettyTable(["Title", "Genres", "Year", "Directors", "Actors"])
for movie in sharded_movies:
    table3.add_row([movie['title'], movie['genres'], movie['year'], ', '.join(movie['directors']), ', '.join(movie['actors'])])
print("\nPelículas en las que Faye Dunaway y Viggo Mortensen han trabajado juntos")
print(table3)


#Cerramos las conexiones
client.close()

