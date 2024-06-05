from neo4j import GraphDatabase

# Conexión a la base de datos Neo4j
uri = "bolt://localhost:7687"
driver = GraphDatabase.driver(uri, auth=("neo4j", "si1-password"))

def execute_query(query_file):
    with driver.session() as session:
        with open(query_file, 'r') as file:
            query = file.read()
        result = session.run(query)
        return list(result)  # Recolectar todos los registros en una lista

# Ejecutar y mostrar los resultados de las consultas
queries = [
    ("winston-hattie-co-co-actors.cypher", "Actores que no han trabajado con 'Winston, Hattie' pero han trabajado con un tercero en común:"),
    ("pair-persons-most-occurrences.cypher", "Pares de personas que han trabajado juntas en más de una película:"),
    ("degrees-reiner-to-smyth.cypher", "Camino mínimo entre 'Reiner, Carl' y 'Smyth, Lisa (I)':")
]

for query_file, description in queries:
    print(description)
    result = execute_query(f"app-neo4j-etl/{query_file}")
    for record in result:
        print(record)
    print("\n")

driver.close()
