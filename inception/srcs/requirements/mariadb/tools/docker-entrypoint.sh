#!/bin/bash
set -e

# Initialisation de la base de données si nécessaire
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."
    mysql_install_db
fi

# Démarrage de MariaDB en arrière-plan pour les opérations initiales
echo "Démarrage de MariaDB en arrière-plan..."
mariadbd-safe &

# Attendre que MariaDB démarre
echo "Attente que MariaDB démarre..."
sleep 10

# Vérifier si MariaDB est déjà en cours d'exécution
if ! mysqladmin ping -h localhost --silent; then
    # MariaDB n'est pas en cours d'exécution, définir le mot de passe root par défaut
    if [ -z "$DB_MDP_ROOT" ]; then
        DB_MDP_ROOT='password'
    fi

    # Changer le mot de passe root uniquement si MariaDB n'est pas en cours d'exécution
    echo "Changement du mot de passe root..."
    mariadb -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_MDP_ROOT}'"
else
    echo "MariaDB est déjà en cours d'exécution, pas de réinitialisation du mot de passe."
fi

# Supprimer et recréer l'utilisateur si nécessaire
mariadb -u root -p"${DB_MDP_ROOT}" -e "DROP USER IF EXISTS '${DB_USER}'@'%';"
mariadb -u root -p"${DB_MDP_ROOT}" -e "CREATE USER '${DB_USER}'@'%' IDENTIFIED BY '${DB_MDP}';"
mariadb -u root -p"${DB_MDP_ROOT}" -e "GRANT ALL PRIVILEGES ON *.* TO '${DB_USER}'@'%';"

# Créer la base de données WordPress
mariadb -u root -p"${DB_MDP_ROOT}" -e "CREATE DATABASE IF NOT EXISTS ${WORDPRESS_DB};"

# Supprimer et recréer l'utilisateur WordPress si nécessaire
mariadb -u root -p"${DB_MDP_ROOT}" -e "DROP USER IF EXISTS '${WORDPRESS_USER}'@'%';"
mariadb -u root -p"${DB_MDP_ROOT}" -e "CREATE USER '${WORDPRESS_USER}'@'%' IDENTIFIED BY '${WORDPRESS_MDP}';"
mariadb -u root -p"${DB_MDP_ROOT}" -e "GRANT ALL PRIVILEGES ON ${WORDPRESS_DB}.* TO '${WORDPRESS_USER}'@'%';"

mariadb -u root -p"${DB_MDP_ROOT}" -e "FLUSH PRIVILEGES;"

# Maintenir le conteneur en vie en exécutant mariadbd en premier plan
echo "Démarrage de mariadbd en premier plan..."
wait

