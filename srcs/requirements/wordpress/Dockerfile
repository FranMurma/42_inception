# Utilizamos Debian 11.9 como la imagen base, que proporciona un sistema operativo estable y seguro
FROM debian:11.9

# Exponemos el puerto 9000, que es donde PHP-FPM escuchará para manejar solicitudes FastCGI
EXPOSE 9000

# Actualizamos la lista de paquetes e instalamos PHP, el módulo MySQL para PHP y PHP-FPM
# PHP-FPM (FastCGI Process Manager) es un manejador de procesos PHP que se integra con servidores web como Nginx para ejecutar scripts PHP
RUN apt-get update -y && \
    apt-get install -y curl php7.4-mysql php7.4-fpm

# Descargamos e instalamos wp-cli, una herramienta de línea de comandos para administrar WordPress
# wp-cli nos permite realizar tareas comunes de administración de WordPress, como instalar y actualizar WordPress, gestionar plugins y temas, y realizar copias de seguridad, todo desde la línea de comandos
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

RUN apt-get update -y && \
    apt-get install -y curl php7.4-mysql php7.4-fpm netcat

# Creamos el directorio necesario para los sockets de PHP-FPM, que PHP-FPM utilizará para comunicarse con otros procesos, como Nginx
RUN mkdir -p /run/php && chmod 755 /run/php

# Copiamos un archivo de configuración personalizado para PHP-FPM
# Este archivo www.conf contiene configuraciones específicas para optimizar cómo PHP-FPM maneja las solicitudes, ajustando parámetros como los límites de memoria y las conexiones
#COPY ./conf/www.conf /etc/php/7.4/fpm/pool.d/	
# revisar


# Copiamos el script de inicio al contenedor
# Este script se ejecutará cuando se inicie el contenedor y suele usarse para realizar configuraciones iniciales de WordPress, como la descarga de archivos o la configuración del entorno
COPY ./tools/wordpress_start.sh /etc
# Otorgamos permisos de ejecución al script para asegurarnos de que pueda ejecutarse correctamente cuando se inicie el contenedor
RUN chmod a+x /etc/wordpress_start.sh

# Establecemos el directorio de trabajo en /var/www/html
# Este es el directorio raíz donde WordPress y sus archivos estarán almacenados, y donde Nginx buscará los archivos para servirlos
WORKDIR /var/www/html

# Definimos el ENTRYPOINT del contenedor, que es el script de inicio que hemos copiado previamente
# Este script wordpress_start.sh puede realizar tareas como configurar la base de datos, descargar y configurar WordPress, y preparar el entorno antes de que PHP-FPM comience a manejar las solicitudes
ENTRYPOINT ["/etc/wordpress_start.sh"]
