#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

chown -R mysql:mysql /var/lib/mysql /var/run/mysqld

echo "entrypoint is running."

if [ ! -d "$DATADIR/wordpress" ]; then
    echo "Initializing MariaDB database..."

    mysql_install_db --user=mysql --datadir="$DATADIR"

    mysqld --skip-networking --datadir="$DATADIR" &
    pid="$!"

    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "Running init.sql..."
    mysql --protocol=socket -u root < /tmp/init.sql

    mysqladmin shutdown
    wait "$pid"
fi

echo "Starting MariaDB..."
exec mysqld --bind-address=0.0.0.0 --datadir="$DATADIR"
