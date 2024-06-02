from sqlalchemy import create_engine, text


def execute_get_top_sales():
    # Establecer la conexión a la base de datos
    engine = create_engine('postgresql://alumnodb:alumnodb@localhost:5432/si1')

    # Definir la consulta como una cadena de texto
    query = text("SELECT * FROM getTopSales(:year1, :year2)")

    # Ejecutar la consulta y obtener los resultados
    with engine.connect() as connection:
        
        result = connection.execute(query.bindparams(year1=2021, year2=2022))
        
        for row in result.fetchmany(10):
            print(row)

if __name__ == "__main__":
    execute_get_top_sales()
