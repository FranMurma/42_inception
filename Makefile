# Creamos las variables
DOCKER_COMPOSE_YAML = srcs/docker-compose.yml
MARIADB_DATA_DIR = /home/frmurcia/data/mariadb
WORDPRESS_DATA_DIR = /home/frmurcia/data/wordpress
IMAGES = nginx:1.20.2 mariadb:10.5.9 wordpress:5.7.2-php7.4-apache 
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
	@docker rmi -f $(IMAGES) 2>/dev/null || true  # Elimina las imágenes específicas del proyecto, ignora errores
	@docker volume rm -f $(VOLUMES) 2>/dev/null || true  # Elimina los volúmenes asociados especificados, ignora errores
	@docker volume prune -f 2>/dev/null || true  # Elimina todos los volúmenes no utilizados por contenedores, ignora errores
	@docker network rm inception 2>/dev/null || true  # Elimina la red si existe, ignora errores y advertencias
	@rm -rf $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)  # Elimina los datos persistentes de MariaDB y WordPress
	@docker system prune -af 2>/dev/null || true  # Limpia todo lo posible (contenedores, imágenes, volúmenes, redes), ignora errores

# re ejecuta los objetivos clean y luego up
re: clean up
	docker-compose -f $(DOCKER_COMPOSE_YAML) up --build -d

# Reinicia todo eliminando los directorios de datos y volviendo a crearlos
restart: fclean create_dirs up

# Crea los directorios que necesitamos para guardar las cosas
create_dirs:
	@mkdir -p $(MARIADB_DATA_DIR) $(WORDPRESS_DATA_DIR)
