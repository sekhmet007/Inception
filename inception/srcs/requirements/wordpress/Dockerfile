FROM debian:bookworm

RUN apt-get update -y && \
    apt-get install -y curl && \
    apt-get install -y ca-certificates apt-transport-https software-properties-common wget lsb-release

RUN apt-get update -y \
    && curl -sSL https://packages.sury.org/php/README.txt | bash -x \
    && apt-get update -y \
    && mkdir -p /run/php/ \
    && touch /run/php/php8.1-fpm.sock \
    && chmod 777 /run/php/php8.1-fpm.sock \
    && apt-get install php8.1 php8.1-fpm php8.1-cli php8.1-curl php8.1-mysql php8.1-gd php8.1-xml php8.1-mbstring php8.1-zip php8.1-soap php8.1-dev -y \
    && update-alternatives --set php /usr/bin/php8.1

COPY ./conf/www.conf ./etc/php/8.1/fpm/pool.d/

WORKDIR /var/www

RUN apt-get update -y \
    && curl -O https://wordpress.org/latest.tar.gz \
    && tar -xvf latest.tar.gz \
    && rm latest.tar.gz \
    && chown -R www-data:www-data /var/www/wordpress \
    && chmod -R 777 /var/www/wordpress

RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

STOPSIGNAL SIGTERM

COPY ./tools/docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

RUN chmod +x /usr/bin/docker-entrypoint.sh

ENTRYPOINT ["bash", "docker-entrypoint.sh"]

CMD ["/bin/bash", "-c", "php-fpm8.1 -F"]
