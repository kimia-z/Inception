NAME = inception

COMPOSE_FILE = ./srcs/docker-compose.yml
ENV_FILE = ./srcs/.env
HOME = kziari

all: checker folder up

checker:
	@if [ ! -f $(ENV_FILE) ]; then \
		echo "Error: .env not found!"; \
		exit 1; \
	fi


folder:
	@mkdir -p $(HOME)/data/mariadb
	@mkdir -p $(HOME)/data/wordpress
	@echo "--Data Folders Created--"

up:
	@docker compose -f $(COMPOSE_FILE) up --build -d

down:
	@docker compose -f $(COMPOSE_FILE) down


clean: down
	@docker system prune -af
	@docker volume prune -f
	@echo "Clean unused volumes and stopped containers!"

re: down up
	@echo " UP UP DOWN DOWN, Elevator Operator! "

fclean: 
	@docker system prune -af
	@docker compose -f ${COMPOSE_FILE} down --volumes
	@docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	@docker rmi -f $$(docker images -q) 2>/dev/null || true
	@sudo rm -rf $(HOME)/data/mariadb
	@sudo rm -rf $(HOME)/data/wordpress
	@sudo rm -rf $(HOME)/data
	@echo "--COMPLETE DELETION: volumes, images and directories were removed!"

.PHONY: all checker folder up down clean re fclean