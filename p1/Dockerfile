# Utilizando la imagen base de Python
FROM python:3.9-slim

# Establecer el directorio de trabajo dentro del contenedor
WORKDIR /app

# Copiar el archivo de requisitos y luego instalar las dependencias necesarias
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copiar el resto de los archivos de la aplicación al contenedor
COPY . .

# Exponer el puerto en el que la aplicación escuchará
EXPOSE 5000

# Comando por defecto para ejecutar la aplicación
CMD ["python", "app.py"]
