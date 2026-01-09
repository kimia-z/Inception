#!/bin/bash

set -e

if [ ! -d"/var/lib/mysql/mysql" ];then
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql

    mysqld --skip-networking &
    pid="$!"

until mysqladmin ping --silent;do
sleep 1
done

    mysql < /tmp/init.sql

    mysqladmin shutdown
wait"$pid"
fi

exec mysqld --bind-address=0.0.0.0