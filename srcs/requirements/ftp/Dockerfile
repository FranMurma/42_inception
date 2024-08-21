FROM debian:11.9

# Instalar vsftpd
RUN apt-get update && apt-get install -y vsftpd

# Crear el directorio de trabajo y establecer permisos
RUN useradd -m -s /bin/bash ftpuser && echo "ftpuser:ftppassword" | chpasswd
RUN mkdir -p /home/ftpuser/ftp && \
    mkdir -p /home/ftpuser/ftp/wp-content/uploads && \
    chown -R ftpuser:ftpuser /home/ftpuser/ftp && \
    chmod -R 755 /home/ftpuser/ftp

# Crear el directorio para secure_chroot_dir
RUN mkdir -p /var/run/vsftpd/empty

# Copiar el archivo de configuración para vsftpd desde la carpeta conf
COPY conf/vsftpd.conf /etc/vsftpd.conf

# Exponer el puerto 21
EXPOSE 21

# Comando para iniciar vsftpd
CMD ["/usr/sbin/vsftpd", "/etc/vsftpd.conf"]

