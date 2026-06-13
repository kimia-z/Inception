#!/bin/bash

set -e

LOG_FILE=/var/log/wordpress_setup.log
exec > >(tee -a "$LOG_FILE") 2>&1

echo "Starting WordPress setup..."

mkdir -p /var/www/wordpress
cd /var/www/wordpress

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

# Download WordPress if not already installed
if ! wp core is-installed --allow-root 2>/dev/null; then

    echo "Starting core download..."

    wp core download --allow-root

    echo "Starting config create..."

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

exec php-fpm8.2 -F
