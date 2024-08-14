#!/bin/bash

#Create TLS certificates to send data over https
echo "Creating SSL certificates..."
if [ ! -f /etc/ssl/certs/nginx.crt ]; then
        openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/nginx.key -out /etc/ssl/certs/nginx.crt -subj "/C=ES/ST=Catalonia/L=Barcelona/O=42/OU=Software/CN=frmurcia.42.fr"
fi
echo "Successful creation of SSL certificates!"
exec "$@"

