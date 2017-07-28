FROM jubicoy/nginx-php:php7
ENV PHPLIST_VERSION 3.3.1

RUN apt-get update && \
	apt-get -y install php7.0-mysql php7.0-xml php7.0-common php7.0-dom php7.0-xml \
	php7.0-simplexml libxml2-dev curl \
	nano wget unzip && \
	apt-get clean


RUN curl -k https://netcologne.dl.sourceforge.net/project/phplist/phplist/${PHPLIST_VERSION}/phplist-${PHPLIST_VERSION}.tgz | tar zx -C /workdir/

RUN rm -f /workdir/phplist-${PHPLIST_VERSION}/public_html/lists/config/config.php
ADD config/config.php /workdir/config.php

RUN mkdir -p /var/www/phplist/public_html/lists

RUN mv /workdir/phplist-${PHPLIST_VERSION}/public_html/lists/* /var/www/phplist/public_html/lists/

#ADD config/config.php /workdir/config.php
RUN ln -s /volume/conf/config.php /var/www/phplist/public_html/lists/config/config.php

ADD config/default.conf /workdir/default.conf
RUN rm -rf /etc/nginx/conf.d/default.conf && ln -s /volume/conf/default.conf /etc/nginx/conf.d/default.conf

ADD entrypoint.sh /workdir/entrypoint.sh

RUN mkdir /volume && chmod 777 /volume

ADD config/nginx.conf /etc/nginx/nginx.conf
# Install common plugin
RUN wget -P /workdir/ https://github.com/bramley/phplist-plugin-common/archive/master.zip
RUN unzip master.zip && mv /workdir/phplist-plugin-common-master/plugins/* /var/www/phplist/public_html/lists/admin/plugins/ && rm -rfv /workdir/master.zip /workdir/phplist*

# Install rss plugin
RUN wget -P /workdir/ https://github.com/bramley/phplist-plugin-rssfeed/archive/master.zip
RUN unzip master.zip && mv /workdir/phplist-plugin-rssfeed-master/plugins/* /var/www/phplist/public_html/lists/admin/plugins/ && rm -rfv /workdir/master.zip /workdir/phplist*

RUN chown -R 104:0 /var/www && chmod -R g+rw /var/www && \
	chmod a+x /workdir/entrypoint.sh && chmod g+rw /workdir

VOLUME ["/volume"]
EXPOSE 5000

USER 100104
