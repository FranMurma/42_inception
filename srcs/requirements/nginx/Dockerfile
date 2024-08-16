FROM debian:11.9

# Actualiza e instala nginx y openssl
RUN apt-get -y update && apt-get install -y nginx openssl && apt-get clean && rm -rf /var/lib/apt/lists/*

# Exponer el puerto HTTPS
EXPOSE 443

# Configura Nginx
COPY ./conf/mandatory.conf /etc/nginx/sites-enabled/
COPY ./tools/nginx_start.sh /etc

RUN chmod +x /etc/nginx_start.sh

# Configurar ENTRYPOINT para ejecutar el script de inicio
ENTRYPOINT ["/etc/nginx_start.sh"]

CMD ["nginx", "-g", "daemon off;"]
