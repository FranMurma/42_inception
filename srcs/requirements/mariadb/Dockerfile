# Especificamos la imagen base desde la que construimos el contenedor: Debian Buster.
FROM debian:11.9

# RUN ejecuta comandos durante el proceso de construcción de la imagen
# Actualiza el sistema e instala los paquetes necesarios. -y es contestar yes
#RUN apt update -y && \
#	apt upgrade -y && \
#	apt-get install -y mariadb-server && \
#	apt-get clean && \
#	rm -rf /var/lib/apt/lists/*
RUN apt-get -y update && apt-get install -y mariadb-server

# COPY copia archivos desde el sistema de archivos local al sistema de archivos del contenedor
COPY ./conf/init.cnf /etc/mysql/mariadb.conf.d/

# Copiamos el archivo de configuracion
COPY ./tools/mariadb_start.sh /etc

# Damos los permisos necesarios, verificar si es necesario
RUN chmod a+x /etc/mariadb_start.sh

#Crea /var/run/mysqld si no existe, porque lo necesita mysql para guardar los archivos socket y PID
RUN mkdir -p /var/run/mysqld && \
                chown -R mysql:mysql /var/run/mysqld && \
                chmod 775 /var/run/mysqld

# EXPOSE informa a Docker que el contenedor escucha en el puerto especificado en tiempo de ejecución
# (es el puerto predeterminado para MariaDb y el que manda el subject)
EXPOSE 3306

# ENTRYPOINT define el script /mariadb.sh como el comando que se ejecutará siempre (en bash)
# cuando se inicie el contenedor
ENTRYPOINT ["/etc/mariadb_start.sh"]
