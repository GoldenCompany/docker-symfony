ARG PHP_VERSION=7.4
FROM php:${PHP_VERSION}-fpm as php

RUN apt-get update && \
    apt-get install -y libicu-dev libpq-dev libzip-dev unzip

RUN docker-php-ext-configure intl && \
    docker-php-ext-configure pgsql --with-pgsql=/usr/local/pgsql

RUN docker-php-ext-install intl pdo_pgsql zip
RUN docker-php-ext-enable \
    opcache

COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
COPY ./ /srv/api

WORKDIR /srv/api/

RUN mkdir -p var/cache var/log && \
    composer install --no-dev --classmap-authoritative --optimize-autoloader --no-scripts --no-progress --no-suggest && \
    php bin/console secrets:decrypt-to-local --force --env=prod && \
    composer dump-env prod && \
    composer clear-cache && \
    php bin/console cache:clear && \
    chown -R www-data:www-data var

ENTRYPOINT ["docker-php-entrypoint"]

CMD ["php-fpm"]
