# Usa Debian Bullseye como imagen base
FROM debian:11.9

# Instala PHP y las extensiones necesarias
RUN apt-get update && apt-get install -y \
    php \
    php-mysql \
    && rm -rf /var/lib/apt/lists/*

# Crea el directorio donde se alojará Adminer
RUN mkdir -p /var/www/html

# Copia el archivo adminer.php al contenedor
COPY ./adminer.php /var/www/html/index.php

# Exponer el puerto 8080
EXPOSE 8080

# Comando para iniciar PHP en modo servidor web
CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
