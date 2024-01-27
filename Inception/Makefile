# Définition des chemins pour les volumes
WP_VOLUME_PATH := /home/ecullier/data/wordpress
DB_VOLUME_PATH := /home/ecullier/data/mariadb

all: create-volumes up

# Commande pour créer les répertoires des volumes s'ils n'existent pas
create-volumes:
	@echo "Création des répertoires pour les volumes..."
	mkdir -p $(WP_VOLUME_PATH)
	mkdir -p $(DB_VOLUME_PATH)

# Commande pour démarrer les services avec docker-compose
up:
	@echo "Démarrage des conteneurs..."
	docker compose -f ./srcs/docker-compose.yml up -d --build

# Commande pour arrêter et supprimer les conteneurs, réseaux, volumes et images créés par 'up'
down:
	@echo "Arrêt des conteneurs et nettoyage..."
	docker compose -f ./srcs/docker-compose.yml down

# Commande pour reconstruire et redémarrer les conteneurs
re: down up

# Commande pour nettoyer l'environnement Docker et supprimer les répertoires des volumes
clean: down
	@echo "Suppression des répertoires des volumes..."
	rm -rf $(WP_VOLUME_PATH)
	rm -rf $(DB_VOLUME_PATH)

.PHONY: all create-volumes up down re clean