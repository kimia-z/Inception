#!/bin/bash
set -e

DATADIR="/var/lib/mysql"

echo "Starting MariaDB setup..."

# Ensure correct permissions
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
chown -R mysql:mysql $DATADIR

# Initialize database if not already initialized
if [ ! -d "$DATADIR" ]; then
    echo "Initializing database..."

    mysqld --initialize-insecure --user=mysql --datadir=$DATADIR

    echo "Starting temporary MariaDB server..."
    mysqld --skip-networking --datadir=$DATADIR &
    pid="$!"

    # Wait until server is ready
    until mysqladmin ping --silent; do
        sleep 1
    done

    echo "Creating database and users..."

    mysql -u root <<EOF
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

    echo "Shutting down temporary server..."
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

    wait $pid
fi

echo "Starting MariaDB in foreground..."
exec mysqld --bind-address=0.0.0.0 --datadir=$DATADIR
