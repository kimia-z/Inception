FROM debian:bullseye

RUN apt-get update && apt-get install -y \
	php7.4 \
	php7.4-fpm \
	php7.4-mysql \
	curl \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html
RUN mkdir -p /run/php

WORKDIR /var/www/html

RUN curl -O https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
	&& mv wordpress/* . \
	&& rmdir wordpress \
	&& rm latest.tar.gz \
	&& chown -R www-data:www-data /var/www/html

RUN find /var/www/html -type d -exec chmod 755 {} \; \
 && find /var/www/html -type f -exec chmod 644 {} \;

COPY conf/wp-config.php /var/www/html/wp-config.php

RUN sed -i 's|listen = /run/php/php7.4-fpm.sock|listen = 9000|' \
	/etc/php/7.4/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm7.4", "-F"]