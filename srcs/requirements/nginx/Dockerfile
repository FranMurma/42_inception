FROM debian:11.9

# Actualiza e instala nginx y openssl
RUN apt-get -y update && apt-get install -y nginx openssl

# Exponer el puerto HTTPS
EXPOSE 443

# Configura Nginx
COPY conf/mandatory.conf /etc/nginx/sites-available
COPY ./tools/nginx_start.sh /etc

RUN chmod +x /etc/nginx_start.sh

ENTRYPOINT ["/etc/nginx_start.sh"]

# Ejecutar Nginx
CMD ["nginx", "-g", "daemon off;"]

