#!/bin/bash

# Démarrer le service MariaDB
service mysql start;

# Exécuter les commandes SQL pour configurer la base de données et les utilisateurs
mysql -e "CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${SQL_USER}\`@'localhost' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO \`${SQL_USER}\`@'%' IDENTIFIED BY '${SQL_PASSWORD}';"
mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';"
mysql -e "FLUSH PRIVILEGES;"

# Arrêter MySQL pour que le conteneur puisse le redémarrer
mysqladmin -u root -p$SQL_ROOT_PASSWORD shutdown

# Démarrer MariaDB en mode sécurisé
exec mysqld_safe


