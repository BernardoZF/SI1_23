from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import redis
import random

# Configuración de la conexión a PostgreSQL
engine = create_engine('postgresql://alumnodb:alumnodb@localhost:5432/si1')
Session = sessionmaker(bind=engine)
session = Session()

# Prueba de conexión a PostgreSQL
try:
    session.execute('SELECT 1')
    print("Conexión a la base de datos PostgreSQL establecida")
except Exception as e:
    print("Error en la conexión a la base de datos PostgreSQL:", e)

# Configuración de la conexión a Redis
r = redis.Redis(host='localhost', port=6379, db=0)

# Prueba de conexión a Redis
try:
    r.ping()
    print("Conexión a Redis establecida")
except Exception as e:
    print("Error en la conexión a Redis:", e)

# Definir la consulta para extraer usuarios de España
query = """
SELECT
    c.email,
    c.firstname || ' ' || c.lastname AS name,
    c.phone
FROM
    customers c
WHERE
    c.country = 'Spain'
"""

# Ejecutar la consulta
customers = session.execute(query).fetchall()

# Guardar los datos en Redis
for customer in customers:
    email = customer.email
    name = customer.name
    phone = customer.phone
    visits = random.randint(1, 99)

    r.hset(f"customers:{email}", mapping={
        "name": name,
        "phone": phone,
        "visits": visits
    })

print("Datos transferidos exitosamente a Redis")

# Definir las funciones requeridas

def increment_by_email(email):
    if r.hexists(f"customers:{email}", "visits"):
        r.hincrby(f"customers:{email}", "visits", 1)
        print(f"Visitas incrementadas para {email}")
    else:
        print(f"No se encontró el cliente con el email {email}")

def customer_most_visits():
    keys = r.keys("customers:*")
    max_visits = -1
    max_email = None

    for key in keys:
        visits = int(r.hget(key, "visits"))
        if visits > max_visits:
            max_visits = visits
            max_email = key.decode().split(":", 1)[1]

    return max_email

def get_field_by_email(email):
    if r.hexists(f"customers:{email}", "name"):
        name = r.hget(f"customers:{email}", "name").decode()
        phone = r.hget(f"customers:{email}", "phone").decode()
        visits = int(r.hget(f"customers:{email}", "visits"))
        return {"name": name, "phone": phone, "visits": visits}
    else:
        print(f"No se encontró el cliente con el email {email}")
        return None

# Ejecución de las funciones requeridas para los puntos del ejercicio

# Incrementar visitas para un email específico
test_email = "ballsy.cobra@jmail.com"
increment_by_email(test_email)

# Obtener el cliente con más visitas
most_visits_email = customer_most_visits()
print(f"Cliente con más visitas: {most_visits_email}")

# Obtener campos para un email específico
fields = get_field_by_email(test_email)
if fields:
    print(f"Datos del cliente {test_email}: {fields}")
