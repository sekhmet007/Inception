#!/bin/bash
set -e

# Initialisation de la base de données si nécessaire
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."
    mariadb-install-db
fi

# Démarrage de MariaDB en arrière-plan pour les opérations initiales
echo "Démarrage de MariaDB en arrière-plan..."
mariadbd --skip-networking --socket=/var/run/mysqld/mysqld.sock &

PID="$!"

# Attendre que MariaDB démarre
echo "Attente que MariaDB démarre..."
while ! mysqladmin ping --socket=/var/run/mysqld/mysqld.sock --silent; do
    sleep 1
    echo "En attente de la base de données..."
done

# Changer le mot de passe root si nécessaire
if [ -n "$DB_MDP_ROOT" ]; then
    echo "Changement du mot de passe root..."
    mysql --user=root --socket=/var/run/mysqld/mysqld.sock <<EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_MDP_ROOT}';
FLUSH PRIVILEGES;
EOF
fi

# Créer l'utilisateur et la base de données si nécessaire
if [ -n "$DB_USER" ] && [ -n "$DB_MDP" ] && [ -n "$WORDPRESS_DB" ]; then
    echo "Création de l'utilisateur et de la base de données..."
    mysql --user=root --password="$DB_MDP_ROOT" --socket=/var/run/mysqld/mysqld.sock <<EOF
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_MDP}';
CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB};
GRANT ALL PRIVILEGES ON ${WORDPRESS_DB}.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
EOF
fi

# Arrêter le processus de fond de MariaDB
if ! kill -s TERM "$PID" || ! wait "$PID"; then
    echo >&2 'MariaDB init process failed.'
    exit 1
fi

# Démarrer MariaDB en premier plan
echo "Démarrage de MariaDB en premier plan..."
exec mariadbd


