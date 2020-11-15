FROM php:7.4-fpm-alpine

LABEL maintainer.name="Julian Murphy"
LABEL version="1.0"
LABEL description="Imagen php-docker para LibreDTE"

RUN apk update && \
    apk add --no-cache --virtual .phpize-deps $PHPIZE_DEPS \
        git mercurial curl wget \
        postgresql-client \
        #libraries for php
        freetype-dev libjpeg-turbo-dev libpng-dev \
        libxml2-dev \
        libzip-dev \
        curl-dev \
        oniguruma-dev \
        icu-dev \
        libbz2 bzip2-dev php7-bz2 php7-pear \
        php7-pgsql php7-fileinfo php7-session \
        bash
#RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install \
        -j$(nproc) gd       \
    && docker-php-ext-install \
        bz2 iconv dom      \
        zip soap curl       \
        mbstring exif intl  \
        bcmath opcache pdo  \
        ctype xml simplexml 
       #imap --with-kerberos --with-imap-ssl

RUN pear install Mail Mail_Mime Net_SMTP

RUN curl -sS https://getcomposer.org/installer | php -- \
        --filename=composer.phar \
        --install-dir=/usr/local/bin && \
	mv /usr/local/bin/composer.phar /usr/local/bin/composer


RUN  wget -c https://github.com/SowerPHP/sowerpkg/raw/master/sowerpkg.sh \
         && chmod +x sowerpkg.sh && mv sowerpkg.sh /usr/local/bin/sowerpkg \
         && sowerpkg install -e "app general" -W

WORKDIR /app
RUN cd /app && git clone --recursive https://github.com/LibreDTE/libredte-webapp.git . \
    && cd /app/website \
    && composer install

RUN mkdir /install_ldte
COPY ${PWD}/docker-entrypoint.sh ${PWD}/core-dist.php ${PWD}/routes-dist.php /install_ldte/

RUN chmod u+x /install_ldte/docker-entrypoint.sh

ENV CONFIG_DIR="/app/website/Config"
ENV CONFIG_FILE="${CONFIG_DIR}/core.php"
ENV ROUTE_FILE="${CONFIG_DIR}/routes.php"

RUN cp "/install_ldte/core-dist.php" "${CONFIG_FILE}" \
    && sed -i -e "s/%DB_USER%/${DB_USER}/g" \
              -e "s/%DB_PASSWORD%/${DB_PASSWORD}/g" \
              -e "s/%DB_HOSTNAME%/${DB_HOSTNAME}/g" \
              -e "s/%DB_NAME%/${DB_NAME}/g" \
           "${CONFIG_FILE}" \
    && cp "/install_ldte/routes-dist.php" "${ROUTE_FILE}"

CMD ["/install_ldte/docker-entrypoint.sh"]
