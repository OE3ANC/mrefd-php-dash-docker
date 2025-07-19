FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    lighttpd \
    php \
    php-fpm \
    tzdata \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

RUN git clone https://github.com/n7tae/mrefd.git /tmp/mrefd \
    && rm -rf /var/www/html \
    && cp -r /tmp/mrefd/php-dash /var/www/html \
    && rm -rf /tmp/mrefd

RUN cp /var/www/html/include/config.inc.php.dist /var/www/html/include/config.inc.php

COPY lighttpd.conf /etc/lighttpd/lighttpd.conf

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html \
    && mkdir -p /var/cache/lighttpd/compress /var/cache/lighttpd/uploads \
    && chown -R www-data:www-data /var/cache/lighttpd

EXPOSE 80

CMD service php8.2-fpm start && lighttpd -D -f /etc/lighttpd/lighttpd.conf
