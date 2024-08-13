FROM debian:11.9

# Actualiza e instala nginx y openssl
RUN apt-get -y update && apt-get install -y nginx openssl

# Crear directorio para SSL y generar certificados
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes \
    -out /etc/nginx/ssl/frmurcia.42.fr.crt \
    -keyout /etc/nginx/ssl/frmurcia.42.fr.key \
    -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=frmurcia.42.fr/UID=frmurcia"

# Configura Nginx
COPY conf/frmurcia.42.fr /etc/nginx/sites-available
RUN ln -s /etc/nginx/sites-available/frmurcia.42.fr /etc/nginx/sites-enabled

# Configuración de archivos y scripts adicionales
RUN mkdir -p /var/www/frmurcia
COPY tools/index.html /var/www/frmurcia

# Exponer el puerto HTTPS
EXPOSE 443

# Ejecutar Nginx
CMD ["nginx", "-g", "daemon off;"]

