#!/bin/bash

echo "Début du script."

# Attente dynamique pour la base de données
echo "Attente de la disponibilité de la base de données..."
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
    echo "En attente de la base de données..."
done
echo "La base de données est prête."

# Vérification de l'existence de wp-config.php
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    echo "Création de wp-config.php pour le site ecullier.42.fr"

    # Utilisation de wp-cli pour générer le fichier de configuration
    echo "Génération du fichier de configuration wp-config.php..."
    wp config create \
        --dbname="${WORDPRESS_DB}" \
        --dbuser="${WORDPRESS_USER}" \
        --dbpass="${WORDPRESS_MDP}" \
        --dbhost="mariadb:3306" \
        --allow-root \
        --path='/var/www/wordpress' \
        --skip-check
    echo "Fichier wp-config.php généré."

    echo "Installation de WordPress..."
    # Installation de WordPress en utilisant wp_cli
    wp core install --url=ecullier.42.fr \
        --title="${SITE_TITLE}" \
        --admin_user="${WP_USER}" \
        --admin_password="${WP_MDP}" \
        --admin_email="${WP_MAIL}" \
        --allow-root \
        --path='/var/www/wordpress'
    echo "WordPress installé."

    echo "Création d'un utilisateur supplémentaire..."
    # Création d'un utilisateur supplémentaire
    wp user create "${WP_USER1}" "${WP_MAIL1}" \
        --role=author \
        --user_pass="${WP_MDP1}" \
        --allow-root \
        --path='/var/www/wordpress'
    echo "Utilisateur supplémentaire créé."
else
    echo "Le fichier wp-config.php existe déjà."
fi

# Vérification et création du répertoire pour PHP-FPM
if [ ! -d /run/php ]; then
    echo "Création du répertoire /run/php pour PHP-FPM"
    mkdir -p /run/php
    chown -R www-data:www-data /run/php
    echo "Répertoire /run/php créé."
else
    echo "Le répertoire /run/php existe déjà."
fi

# Démarrage de PHP-FPM
echo "Démarrage de PHP-FPM..."
exec php-fpm8.1 -F
echo "PHP-FPM démarré."