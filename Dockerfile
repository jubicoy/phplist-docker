FROM jubicoy/nginx-php:latest
ENV PHPLIST_VERSION 3.3.1

RUN apt-get update && \
	apt-get -y install php5-fpm php5-mysql php-apc \
	php5-imagick php5-imap php5-mcrypt php5-curl \
	php5-cli php5-gd php5-pgsql php5-sqlite \
	php5-common php-pear curl php5-json php5-redis php5-memcache \
	gzip netcat mysql-client && \
	apt-get clean


RUN curl -k https://netcologne.dl.sourceforge.net/project/phplist/phplist/${PHPLIST_VERSION}/phplist-${PHPLIST_VERSION}.tgz | tar zx -C /workdir/

RUN rm -f /workdir/phplist-${PHPLIST_VERSION}/public_html/lists/config/config.php
ADD config/config.php /workdir/config.php

RUN mkdir -p /var/www/phplist/public_html/lists

RUN mv /workdir/phplist-${PHPLIST_VERSION}/public_html/lists/* /var/www/phplist/public_html/lists/ && mv /workdir/config.php /var/www/phplist/public_html/lists/config/config.php

ADD config/default.conf /workdir/default.conf
RUN rm -rf /etc/nginx/conf.d/default.conf && ln -s /volume/conf/default.conf /etc/nginx/conf.d/default.conf

ADD entrypoint.sh /workdir/entrypoint.sh

RUN mkdir /volume && chmod 777 /volume

ADD config/nginx.conf /etc/nginx/nginx.conf

RUN chown -R 104:0 /var/www && chmod -R g+rw /var/www && \
	chmod a+x /workdir/entrypoint.sh && chmod g+rw /workdir

VOLUME ["/volume"]
EXPOSE 5000

USER 104
