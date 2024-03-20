# MEMORIA DE SISTEMAS INFORMATICOS I

_______

## Práctica 1

## Parte 1

### Pregunta: user_rest.py

1. ¿Qué crees que hacen las anotaciones @app.route, @app.get, @app.put?
   - @app.route en Quart se utiliza para asociar una función con una ruta específica en una aplicación Quart. Define un manejador para solicitudes HTTP GET por defecto.

   - @app.get en Quart define un manejador para solicitudes HTTP GET asincrónicas en una ruta específica.

   - @app.put en Quart define un manejador para solicitudes HTTP PUT asincrónicas en una ruta específica.
2. ¿Qué ventajas o inconvenientes crees que pueden tener?
**Ventajas de las anotaciones en Quart:**
      - Las anotaciones, como `@app.route`, `@app.get`, y `@app.put`, proporcionan una sintaxis clara y declarativa para definir rutas y manejar solicitudes, facilitando la organización del código y la comprensión de la lógica de la aplicación.

**Inconvenientes de las anotaciones en Quart:**
      - Puede haber una curva de aprendizaje para los desarrolladores que no están familiarizados con el concepto de anotaciones o decoradores en Python, especialmente si no han trabajado previamente con marcos web similares, como Flask.

### Pregunta: ejecución de user_rest.py

1. ¿Qué crees que ha sucedido?
   - Estos comandos inician un entorno virtual, crean un directorio "build/users" si no existe, y ejecutan una aplicación Quart llamada `src.user_rest:app` en el puerto 5050, configurando así el entorno y la estructura antes de ejecutar la aplicación.

2. ¿Qué crees que ha sucedido al ejecutar el mandato curl?
   - Este comando curl envía una solicitud HTTP PUT al servicio user_rest.py en la URL <http://localhost:5050/user/myusername>. La solicitud incluye datos JSON que contienen información sobre el usuario, como el nombre.

3. ¿Cuál es la respuesta del microservicio?
   - {"status":"OK"}

4. ¿Se ha generado algún archivo? ¿Cuál es su ruta y contenido?
   - Sí se ha generado el archivo data.json en la ruta build/users/myusername y su contenido es el siguiente: {"firstName": "myFirstName", "username": "myusername"}

### Pregunta: petición HTTP

1. ¿Cuál es la petición HTTP que llega al programa nc?
   - La petición es la siguiente:

           PUT /user/myusername HTTP/1.1
           Host: localhost:8888
           User-Agent: curl/7.68.0
           Accept: */*
           Content-Type: application/json
           Content-Length: 28

2. ¿En qué campo de la cabecera HTTP se indica el tipo de dato del cuerpo (body) de la petición y cuál es ese tipo?
   - Se indica en el campo Content-Type y en este caso es una application/json

3. ¿Qué separa la cabecera del cuerpo?
   - La cabecera (header) y el cuerpo (body) de una solicitud HTTP están separados por una secuencia de dos caracteres de nueva línea (\r\n), que indica el final de la cabecera y el comienzo del cuerpo.

### Pregunta: ejecución hypercorn

1. ¿Qué crees que ha sucedido?
   - El comando hypercorn --bind 0.0.0.0:8080 --workers 2 src.user_rest:app está iniciando el servidor Hypercorn para ejecutar la aplicación Quart src.user_rest:app. Hypercorn está ejecutando el servidor en el 0.0.0.0:8080, lo que significa que está escuchando en todas las interfaces de red en el puerto 8080. Se están utilizando 2 workers (--workers 2), lo que podría mejorar la capacidad de manejar solicitudes simultáneas al utilizar múltiples procesos.

2. ¿Qué petición curl debes hacer ahora para hacer un GET de un usuario? ¿Qué ha cambiado respecto de la ejecución sin hypercorn?
   - La petición que hay que hacer ahora es curl <http://localhost:8080/user/{username}>. Y ha cambiado en que ahora se ejecuta el QUART en un servidor Hypercorn que es un servidor ASGI, más adecuado para entornos de producción, ya que maneja mejor las solicitudes concurrentes al utilizar 2 workers y escuchar en todas las interfaces en el puerto 8080 en este caso. Esto puede traducirse en un mejor rendimiento y escalabilidad en comparación con el servidor de desarrollo estándar de Quart.

### Pregunta: modo rootless

1. Revisa el contenido de /etc/subuid y la documentación de docker rootless: ¿para qué crees que sirve ese archivo?
   - /etc/subuid es un archivo en sistemas Linux utilizado en el modo "rootless" de Docker. Define rangos de IDs de usuario secundarios (subuids) permitidos para usuarios específicos. Estos archivos son cruciales para asignar IDs de usuario de manera segura en contenedores sin necesidad de privilegios de root en el sistema host.

### Pregunta: docker info

1. ¿Dónde se guarda la configuración del demonio arrancado?
      - La configuración del demonio Docker en el modo "rootless" se encuentra en el archivo daemon.json dentro del directorio de configuración del usuario. En este caso, el directorio es /home/myuser/.local/share/docker.

2. ¿Dónde se almacenan los contenedores?
      - Los contenedores se almacenan en el directorio de Docker específico del usuario, que en este caso es /home/bernardo/.local/share/docker/containers/.

3. ¿Qué tecnología de almacenamiento se usa para los contenedores? ¿Qué es copy-on-write? ¿Lo usa docker?
      - La tecnología de almacenamiento utilizada es overlay2. Copy-on-write (COW): Es una estrategia en la que los datos se copian solo cuando se modifican, optimizando el uso del espacio y las operaciones de copia y escritura. Docker sí utiliza copy-on-write a través del controlador de almacenamiento Overlay2 para mejorar la eficiencia del almacenamiento de contenedores.

### Pregunta: run whoami

1. ¿Qué crees que ha sucedido?
    - Docker ha descargado la imagen de Alpine. Posteriormente ha creado un contenedor basado en la imagen de Alpine y despues ha ejecutado el comando whoami dentro del Docker.
2. ¿Crees que el usuario root del contenedor es el mismo que el del host?
    - No ya que el root que sale es de dentro del contenedor Alpine y no es el mismo que ejecutando whoami fuera del contenedor.

### Pregunta: list images

1. ¿Qué crees que tiene que ver con el mandato docker pull?
   - Al usar docker images, obtienes una lista de las imágenes de Docker presentes localmente. Esto está relacionado con docker pull, ya que docker pull se utiliza para descargar nuevas imágenes desde un registro remoto a la máquina local, y las imágenes descargadas se reflejan en la salida de docker images.

### Pregunta: docker ps

1. ¿Qué crees que muestra la salida?
   - El comando docker ps -a muestra una lista detallada de todos los contenedores, incluidos los que están en ejecución y los que han sido detenidos.

### Pregunta: docker pull y run -ti

1. ¿Qué hacen las opiones -ti?
   - Las banderas hacen lo siguiente -t asigna una terminal al contenedor y la bandera -i vuelve dicha terminal en interactiva.

2. ¿Qué ha sucedido?
   - Se ha creado y ejecutado un contenedor interactivo basado en la imagen de Ubuntu con la etiqueta "22.04", permitiendo la interacción directa con el sistema operativo del contenedor. El contenedor se ha nombrado como "u22.04".

### Pregunta: docker inspect

1. ¿Qué hace el mandato jq?
   - jq es una herramienta de procesamiento de datos JSON en la línea de comandos. En este contexto, está formateando y filtrando la salida JSON generada por el comando docker inspect. La expresión .[].Config.Cmd[] extrae y lista los elementos del array Cmd en la configuración del contenedor.

2. ¿Qué tiene que ver el resultado del mandato con la tarea anterior?
   - El resultado muestra el comando que se ejecutó al iniciar el contenedor. Específicamente, se está mostrando el comando CMD definido en la configuración del contenedor creado anteriormente con docker run -ti --name u22.04 ubuntu. Esto proporciona información sobre qué proceso o aplicación se inició en el contenedor cuando fue creado.

### Pregunta: docker start

1. ¿Qué ha sucedido?
   - El comando docker start u22.04 inicia el contenedor llamado "u22.04" que fue previamente creado y detenido. Esto significa que se reinicia el contenedor, permitiendo que vuelva a ejecutarse.

2. ¿Cómo se borra el contenedor u22.04?
   - Para borrar el contenedor "u22.04", se puede utilizar el siguiente comando: docker rm u22.04.

### Pregunta: docker run -d

1. ¿Qué hace la opción -d?
   - Cuando se usa -d, el contenedor se inicia y se ejecuta en segundo plano, y el terminal del host se libera para que puedas seguir utilizando la consola sin que esté vinculada al contenedor.

### Pregunta: docker exec

1. ¿Qué ha sucedido?
   - Dentro del contenedor "u22.04d", se ha creado un directorio llamado "users" y dentro de ese directorio se ha creado un archivo llamado "test". Estos cambios son específicos del sistema de archivos dentro del contenedor y no afectan a mi sistema de archivos como host.

### Pregunta: docker volume

1. ¿Qué hace la opción -v?
   - La opción -v en el comando docker run se utiliza para montar un volumen en el contenedor. En este caso, se está montando el directorio local ${PWD}/si1/users/testv en el contenedor en la ruta /si1/users/testv.

2. ¿Qué ha sucedido al ejecutar los mandatos anteriores?
   - [[ -d si1/users/testv ]] || mkdir -p si1/users/testv: Crea el directorio local si1/users/testv si no existe.

   - docker run -ti -v ${PWD}/si1/users/testv:/si1/users/testv alpine touch /si1/users/testv/afile: Crea un contenedor Alpine y utiliza el volumen montado para crear un archivo llamado "afile" en el directorio /si1/users/testv dentro del contenedor.

   - docker run -ti -v ${PWD}/si1/users/testv:/si1/users/testv alpine ls -al /si1/users/testv/afile: Ejecuta un contenedor Alpine para listar detalles del archivo "afile" dentro del contenedor. Este comando no mostrará nada si el archivo no existe.

   - ls -al si1/users/testv/afile: Lista detalles del archivo "afile" en el sistema de archivos local. Este comando también dará como resultado un archivo vacío o no mostrará nada si el archivo no existe.

   - echo "a test" >>si1/users/testv/afile: Agrega el texto "a test" al archivo "afile" en el sistema de archivos local.

   - docker run -ti -v ${PWD}/si1/users/testv:/si1/users/testv alpine cat /si1/users/testv/afile: Ejecuta un contenedor Alpine para mostrar el contenido del archivo "afile". Muestra el contenido del archivo que ahora incluye la línea "a test".

### Pregunta: limpieza

1. ¿Qué mandato has usado para eliminar los contenedores?
   - Para eliminar todos los contenedores he usado el siguiente comando: docker rm -f $(docker ps -aq)

2. ¿Qué mandato has usado para eliminar las imágenes?
   - Para eliminar todas las imagenes he usado el siguiente comando: docker rmi -f $(docker images -q)

### Pregunta: Dockerfile

1. ¿Qué hace la sentencia FROM?
   - La sentencia `FROM` establece la imagen base para construir la nueva imagen. Define el punto de partida del Dockerfile.

2. ¿Qué hace la sentencia ENV?
   - La sentencia `ENV` establece variables de entorno en la imagen. Estas variables pueden ser referenciadas durante el proceso de construcción de la imagen y también estarán disponibles en los contenedores que se crean a partir de la imagen.

3. ¿Qué diferencia presenta ENV respecto de ARG?
   - `ENV` establece variables de entorno que estarán disponibles tanto durante la construcción de la imagen como en los contenedores derivados. `ARG`, por otro lado, define argumentos que solo están disponibles durante el proceso de construcción y no se mantienen en los contenedores resultantes.

4. ¿Qué hace la sentencia RUN?
   - La sentencia `RUN` ejecuta comandos en una nueva capa de la imagen durante el proceso de construcción. Puede utilizarse para instalar paquetes, configurar el entorno, o realizar cualquier tarea necesaria durante la construcción.

5. ¿Qué hace la sentencia COPY?
   - La sentencia `COPY` copia archivos o directorios desde el sistema de archivos del host al sistema de archivos del contenedor durante la construcción de la imagen.

6. ¿Qué otra sentencia del Dockerfile tienen un cometido similar a COPY?
   - La sentencia `ADD` tiene un cometido similar a `COPY`. Sin embargo, `ADD` tiene funcionalidades adicionales, como la posibilidad de descomprimir archivos automáticamente y la capacidad de copiar archivos desde una URL.

7. ¿Qué hace la sentencia EXPOSE?
   - La sentencia `EXPOSE` indica los puertos en los que el contenedor escuchará durante el tiempo de ejecución. No publica automáticamente los puertos, pero proporciona información sobre los puertos que se espera que el contenedor utilice.

8. ¿Qué hace la sentencia CMD?
   - La sentencia `CMD` proporciona un comando predeterminado que se ejecutará cuando se inicie un contenedor basado en la imagen. Puede ser reemplazado por un comando especificado al ejecutar el contenedor.

9. ¿Qué otras sentencias del Dockerfile tienen un cometido similar a CMD?
   - La sentencia `ENTRYPOINT` también se utiliza para proporcionar un comando predeterminado, pero a diferencia de `CMD`, `ENTRYPOINT` no se puede anular al ejecutar el contenedor. Sin embargo, se pueden combinar `CMD` y `ENTRYPOINT` para tener un comando predeterminado y permitir la sustitución del comando en ejecución.

### Pregunta: docker build

1. ¿Por qué es mucho más rápido la creación de la segunda imagen?
   - La creación más rápida de la segunda imagen se debe al sistema de caché de Docker. Si las instrucciones en el Dockerfile no han cambiado desde la primera imagen, Docker reutiliza las capas existentes desde la caché, evitando la necesidad de volver a ejecutar ciertas partes del proceso de construcción.
  
2. Las imágenes constan de distintas capas: ¿Qué quiere decir esto?
   - Las imágenes Docker están compuestas por capas. Cada instrucción en un Dockerfile crea una nueva capa en la imagen. Las capas son reutilizables y se almacenan en caché, lo que acelera la construcción al evitar repetir pasos ya realizados. La gestión por capas también facilita la distribución eficiente de imágenes.
  
### Pregunta: docker build with user

1. ¿Por qué en los últimos pasos no utiliza la caché?
   - Porque al introducir cambios en el Dockerfile de ese punto en adelante se invalida la cache del mismo.

### Pregunta: docker run myimage

1. ¿Cuántos subprocesos de hypercorn aparecen? ¿Por qué?
   - Aparecen 5 subprocesos esto se debe a que al establecer el numero de workers a 5 se establecen 5 subprocesos para gestionar las peticiones.
  
2. ¿Qué hace la opción ‘-p’ del comando docker run?
   - La opcion -p lo que hace es mapear los puertos del host al puerto definido del contenedor en este caso mapeamos el puerto del host 8080 con el 8000 del contenedor.

3. Si deseáramos ejecutar otra réplica (contenedor) del microservicio, ¿qué deberíamos cambiar en
la sentencia docker run?
   - Habria que cambiarle el nombre al contenedor y el puerto de mapeo del host y del contenedor.

### Pregunta: docker run myimage on ./si1

1. ¿Qué mandato has ejecutado?
   - Primero he creado el directorio local con `mkdir ./si1` y posteriormente he utilizado el siguiente comando `docker run --name si1p1_replica2 -e NUMWORKERS=5 -d -p 8081:8000 -v $(pwd)/si1:/si1 si1p1`

2. De cara a la realización de backups, ¿cuál crees que es la utilidad de montar volúmenes externos
respecto de usar los internos de docker?
   - Montar volúmenes externos en lugar de utilizar volúmenes internos de Docker ofrece ventajas significativas para la realización de backups. Proporciona persistencia de datos independiente de los contenedores, facilita la realización de copias de seguridad, ofrece flexibilidad en la ubicación de almacenamiento, es compatible con herramientas externas de backup, y simplifica procesos de migración y actualización de la infraestructura. En resumen, los volúmenes externos son más flexibles y robustos para la gestión de datos críticos.

### Pregunta: docker registry

1. ¿Qué mandato has usado para descargar la imagen del registry?
   - He usado `docker pull registry` ya que de default el tag latest.

2. ¿Cuál es el número de versión de dicha imagen?
   - El numero de  version de la imagen es latest
  
3. ¿Qué mandato has usado para ejecutar el contenedor del registry?
   - El comando que he usado es el siguiente `docker run --name si1_registry -d -p 5050:5000 registry:latest`
  
4. ¿En qué puerto escucha por defecto el contenedor del registry?
   - Por defecto, el registry escucha en el puerto 5000 dentro del contenedor. En el comando se ha mapeado al puerto 5050 del host.

### Pregunta: docker tag push

1. ¿Qué ha sucedido?
   - He tomado la imagen de Ubuntu, le he asignado una nueva etiqueta específica para mi registro local, y luego la he empujado a mi registro local para que esté disponible para su uso en ese registro.

### Pregunta: docker app from local

1. ¿Qué mandatos has usado?
   - He usado os siguientes comandos:
       `docker build --tag localhost:5000/si1p1:latest .`
       `docker push localhost:5000/si1p1:latest`
       `docker run --name si1_app -d -p 8082:8000 localhost:5000/si1p1:latest`

## Parte 2

### Pregunta: AWS S3

1. ¿Qué hacen los distintos subcomandos de awslocal s3?
   - `mb`: Crea un nuevo bucket.
   - `cp`: Copia archivos o directorios a/desde un bucket de S3 local.
   - `ls`: Lista el contenido de un bucket o carpeta en S3 local.
  
2. ¿Qué comando podemos usar para descargar el archivo user_rest.py desde el bucket que hemos
creado, dándole otro nombre para evitar sobreescribirlo ?
   - Se puede usar el comando `awslocal s3 cp` con la opción `--no-clobber` para evitar la sobrescritura.

### Pregunta: Lambdas

1. ¿Qué runtime podríamos usar si por ejemplo queremos implementar una función Lambda en JavaScript ?
   - Para implementar una función Lambda en JavaScript, puedes usar el entorno de ejecución Node.js como runtime. Algunos runtimes comunes para JavaScript en AWS Lambda son nodejs14.x, nodejs12.x, etc., donde x es la versión específica.

2. ¿Cómo recibe la función lambda el usuario los datos que hemos enviado con el comando curl?
   - La función Lambda recibe los datos a través de la carga útil (payload) de la solicitud HTTP.

3. Comprueba que ha funcionado descargando del bucket el fichero creado por la función. ¿Qué
comandos has utilizado para ello?
   - Para descagarlo he utilizado el siguiente comando `awslocal s3 cp s3://si1p1/users/pepe local/`
