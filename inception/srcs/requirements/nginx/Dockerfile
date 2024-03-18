FROM debian:bookworm

# Installer Nginx et OpenSSL
RUN apt-get update -y && \
    apt-get install nginx openssl -y

# Ajouter la configuration de Nginx
ADD ./conf/login.42.fr.conf /etc/nginx/conf.d/login.42.fr.conf

# Supprimer les configurations par défaut
RUN rm /etc/nginx/sites-available/default && \
    rm /etc/nginx/sites-enabled/default

# Générer un certificat SSL auto-signé
RUN openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=FR/ST=France/L=Perpignan/O=42Perpignan/CN=ecullier.42.fr" \
    -keyout /etc/ssl/certs/login.42.fr.key  \
    -out /etc/ssl/certs/login.42.fr.crt

# Exposer le port 443 pour le trafic HTTPS
EXPOSE 443

# Ajouter un script d'entrée
ADD ./tools/docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Utiliser le script d'entrée comme commande par défaut
CMD ["/docker-entrypoint.sh"]

