#!/bin/bash

# Attente de la disponibilité de la base de données
sleep 10

# Configuration de WordPress si wp-config.php n'existe pas
if [ ! -f /var/www/wordpress/wp-config.php ]; then
    wp config create --allow-root \
                     --dbname=$SQL_DATABASE \
                     --dbuser=$SQL_USER \
                     --dbpass=$SQL_PASSWORD \
                     --dbhost=mariadb:3306 --path='/var/www/wordpress'
    # Autres commandes WP-CLI pour configurer WordPress
fi

# Démarrage de PHP-FPM
/usr/sbin/php-fpm7.3 -F
