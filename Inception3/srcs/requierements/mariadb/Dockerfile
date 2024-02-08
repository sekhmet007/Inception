FROM debian:bullseye

RUN apt-get update -y && apt-get install -y mariadb-server
RUN apt-get update && apt-get install -y net-tools

# Ajoutez votre fichier de configuration personnalisé si nécessaire
ADD ./conf/50-server.cnf /etc/mysql/mariadb.conf.d

COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["mariadbd-safe"]

