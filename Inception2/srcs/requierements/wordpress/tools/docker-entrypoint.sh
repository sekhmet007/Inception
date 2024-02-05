#!/bin/bash

# Attente dynamique pour la base de données
echo "Attente de la disponibilité de la base de données..."
while ! mysqladmin ping -h"mariadb" --silent; do
    sleep 1
    echo "En attente de la base de données..."
done

# Vérification de l'existence de wp-config.php
if [ ! -e /var/www/wordpress/wp-config.php ]; then
    echo "Création de wp-config.php pour le site ecullier.42.fr"

    sed -i "s/username_here/$WORDPRESS_USER/g" /var/www/wordpress/wp-config-sample.php
	    sed -i "s/password_here/$WORDPRESS_MDP/g" /var/www/wordpress/wp-config-sample.php
	    sed -i "s/localhost/mariadb:3306/g" /var/www/wordpress/wp-config-sample.php
	    sed -i "s/database_name_here/$WORDPRESS_DB/g" /var/www/wordpress/wp-config-sample.php
	    cp /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

    # Install WordPress using wp-cli
    wp core install --url=ecullier.42.fr \
        --title=$SITE_TITLE \
        --admin_user=$WP_USER \
        --admin_password=$WP_MDP \
        --admin_email=$WP_MAIL \
        --allow-root --path='/var/www/wordpress'

    # Create a user using wp-cli
    wp user create --allow-root --role=author $WP_USER1 $WP_MAIL1 \
        --user_pass=$WP_MDP1 --path='/var/www/wordpress' >> /log.txt

fi

# Vérification et création du répertoire pour PHP-FPM
if [ ! -d /run/php ]; then
    echo "Création du répertoire /run/php pour PHP-FPM"
    mkdir -p /run/php
    chown -R www-data:www-data /run/php
fi

# Démarrage de PHP-FPM
echo "Démarrage de PHP-FPM..."
exec php-fpm8.1 -F

