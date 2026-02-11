#!/bin/bash

set -e

mkdir -p /var/www/wordpress
cd /var/www/wordpress

# Install WP-CLI
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

# Download WordPress if not already installed
if [ ! -f wp-config.php ]; then

    wp core download --allow-root

    wp config create \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --allow-root

    wp core install \
        --url=$DOMAIN_NAME \
        --title="$SITE_TITLE" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --allow-root

    wp user create \
        $WP_USER $WP_USER_EMAIL \
        --user_pass=$WP_USER_PASSWORD \
        --role=editor \
        --allow-root
fi

mkdir -p /run/php

exec php-fpm7.4 -F
