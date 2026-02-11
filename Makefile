NAME = inception

COMPOSE = docker-compose
SRC = srcs/docker-compose.yml

*************
DATA_DIR = /Users/kimiaziari/dockervols
*************

all: build up

build:
	$(COMPOSE) -f $(SRC) build

up:
	$(COMPOSE) -f $(SRC) up -d

down:
	$(COMPOSE) -f $(SRC) down

stop:
	$(COMPOSE) -f $(SRC) stop

restart: down up

logs:
	$(COMPOSE) -f $(SRC) logs

ps:
	$(COMPOSE) -f $(SRC) ps

clean:
	$(COMPOSE) -f $(SRC) down -v

fclean: clean
	rm -rf $(DATA_DIR)/mariadb/*
	rm -rf $(DATA_DIR)/wordpress/*

re: fclean all

.PHONY: all build up down stop restart logs ps clean fclean re
