#!/bin/sh

# Tester la configuration Nginx
echo "Test de la configuration Nginx..."
nginx -t
if [ $? -ne 0 ]; then
    echo "La configuration Nginx a échoué, arrêt du conteneur..."
    exit 1
fi

# Démarrer Nginx en avant-plan
echo "Démarrage de Nginx..."
exec nginx -g "daemon off;"

