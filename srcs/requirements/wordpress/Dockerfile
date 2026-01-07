FROM debian:buster

RUN apt-get update && apt-get install -y \
	php7.3 \
	php7.3-fpm \
	php7.3-mysql \
	curl \
	mariadb-client \
	&& rm -rf /var/lib/apt/lists/*

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN curl -O https://wordpress.org/latest.tar.gz \
	&& tar -xzf latest.tar.gz \
	&& rm latest.tar.gz \
	&& chown -R www-data:www-data /var/www/html

COPY conf/wp-config.php /var/www/html/wp-config.php

RUN sed -i 's|listen = /run/php/php7.3-fpm.sock|listen = 9000|' \
	/etc/php/7.3/fpm/pool.d/www.conf

EXPOSE 9000

CMD ["php-fpm7.3", "-F"]