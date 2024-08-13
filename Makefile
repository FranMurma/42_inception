# Creamos las variables
DOCKER_COMPOSE_YAML = srcs/docker-compose.yml
MARIADB_DATA_DIR = /home/frmurcia/data/mariadb
WORDPRESS_DATA_DIR = /home/frmurcia/data/wordpress
IMAGES = nginx mariadb wordpress
VOLUMES = srcs_mariadb_data srcs_wordpress_data

# Objetivos
.PHONY: all build up down clean re restart create_dirs

all: create_dirs build up

# El objetivo up levanta y construye los contenedores definidos en el archivo docker-compose.yml
build:
# la @ silencia esa linea en la salida
# -f indica que lo siguiente será el archivo de configuración docker-compose.yml. Necesario porque no esta en el mismo dir
	@echo "Building..."
	@docker-compose -f $(DOCKER_COMPOSE_YAML) build

up: 
	@docker-compose -f $(DOCKER_COMPOSE_YAML) up -d

# Detiene y elimina los contenedores, pero mantiene los volúmenes
down:
	@docker-compose -f $(DOCKER_COMPOSE_YAML) down

# Limpia contenedores, imágenes no utilizadas, y redes personalizadas, pero preserva los volúmenes
# El if: Si el resultado de docker ps -aq (mostrar id's del listado de contenedores en marcha y no)

clean: down
	@docker image prune -af  # Elimina imágenes no utilizadas
	@if [ ! -z "$$(docker ps -aq)" ]; then \
		docker rm $$(docker ps -aq); \
	fi
	@if [ ! -z "$$(docker network ls -q --filter type=custom)" ]; then \
		docker network rm $$(docker network ls -q --filter type=custom); \
	fi

# Limpia absolutamente todo, incluyendo volúmenes y directorios de datos
fclean: clean
	@docker rmi -f $(IMAGES)  # Elimina las imágenes específicas del proyecto
	@docker volume rm -f $(VOLUMES)  # Elimina los volúmenes asociados
	@rm -rf $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)  # Elimina los datos persistentes de MariaDB y WordPress

# re ejecuta los objetivos clean y luego up
re: clean up

# Reinicia todo eliminando los directorios de datos y volviendo a crearlos
restart: fclean create_dirs up

# Crea los directorios que necesitamos para guardar las cosas
create_dirs:
	@mkdir -p $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)
