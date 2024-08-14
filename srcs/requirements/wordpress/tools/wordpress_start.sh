#!/bin/bash

# Espera a que la base de datos esté lista antes de continuar
# Esto es crucial para evitar errores en la instalación de WordPress si la base de datos no está lista
echo "Waiting for database to be ready..."
while ! nc -z $DB_HOST 3306; do
  sleep 1 # Espera 1 segundo antes de verificar nuevamente
done
echo "Database is ready!"

# Cambia la configuración de PHP-FPM para escuchar en el puerto 9000 en lugar de un socket Unix
# Esto asegura que PHP-FPM esté disponible para Nginx a través del puerto 9000
if [ -f /etc/php/7.4/fpm/pool.d/www.conf ]; then
    sed -i '/^listen = /s/.*/listen = 0.0.0.0:9000/' /etc/php/7.4/fpm/pool.d/www.conf
    echo "Successfully edited www.conf: Listening on port 9000."
else
    echo "Error: www.conf file doesn't exist"
fi

# Verifica si el archivo de configuración de WordPress (wp-config.php) ya existe
# Si no existe, instala y configura WordPress usando wp-cli
if [ ! -f /var/www/html/wp-config.php ]; then
    mkdir -p /var/www/html
    cd /var/www/html

    # Descarga e instala WordPress utilizando wp-cli
    wp core download --allow-root
    wp config create --allow-root --dbname=$DB_NAME --dbuser=$DB_USER --dbpass=$DB_PASS --dbhost=$DB_HOST --dbprefix=$DB_PREFIX
    wp core install --url=$DOMAIN_NAME --title="$WP_TITLE" --admin_user=$WP_ADMIN_USER --admin_password=$WP_ADMIN_PASS --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
    wp user create $WP_USER $WP_EMAIL --role=author --user_pass=$WP_PASS --allow-root
    
    # Instala y activa un tema en WordPress
    wp theme install twentysixteen --activate --allow-root
fi

# Ejecuta PHP-FPM en primer plano, lo que es necesario para que Docker mantenga el contenedor en ejecución
echo "Executing php-fpm7.4 -F..."
/usr/sbin/php-fpm7.4 -F

