#!/bin/bash
CONFIG=/var/www/phplist/public_html/lists/config/config.php
export USER_ID=$(id -u)
export GROUP_ID=$(id -g)
envsubst < /workdir/passwd.template > /tmp/passwd
#export LD_PRELOAD=libnss_wrapper.so
#export NSS_WRAPPER_PASSWD=/tmp/passwd
#export NSS_WRAPPER_GROUP=/etc/group

#envsubst < /var/www/phplist/public_html/lists/config/config.php > /var/www/phplist/public_html/lists/config/config.php

sed -i "s/MYSQL_HOST/${MYSQL_HOST}/g" $CONFIG
sed -i "s/MYSQL_DATABASE/${MYSQL_DATABASE}/g" $CONFIG
sed -i "s/MYSQL_USER/${MYSQL_USER}/g" $CONFIG
sed -i "s/MYSQL_PASSWORD/${MYSQL_PASSWORD}/g" $CONFIG
sed -i "s/SMTP_HOST/${SMTP_HOST}/g" $CONFIG
sed -i "s/SMTP_USER/${SMTP_USER}/g" $CONFIG
sed -i "s/SMTP_PASS/${SMTP_PASS}/g" $CONFIG
sed -i "s/SMTP_PORT/${SMTP_PORT}/g" $CONFIG


# Move Nginx configuration if does not exist
if [ ! -f /volume/conf/default.conf ]; then
	mkdir -p /volume/conf/
	mv /workdir/default.conf /volume/conf/default.conf
fi

exec "/usr/bin/supervisord"
