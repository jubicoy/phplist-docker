FROM jubicoy/nginx-php:php7
ENV PHPLIST_VERSION 3.3.1
ENV RSS_PLUGIN_VERSION 2.5.4

RUN apt-get update && \
	apt-get -y -o Dpkg::Options::=--force-confold install php7.0-mysql php7.0-xml php7.0-common php7.0-dom php7.0-xml \
	php7.0-simplexml php7.0-zip libxml2-dev php7.0-mbstring php7.0-curl curl \
	wget unzip vim golang-go git-core xvfb libfontconfig wkhtmltopdf && \
	apt-get clean


RUN curl -k https://netcologne.dl.sourceforge.net/project/phplist/phplist/${PHPLIST_VERSION}/phplist-${PHPLIST_VERSION}.tgz | tar zx -C /workdir/

RUN rm -f /workdir/phplist-${PHPLIST_VERSION}/public_html/lists/config/config.php
COPY config/config.php /workdir/config.php

RUN mkdir -p /var/www/phplist/public_html/lists

RUN mv /workdir/phplist-${PHPLIST_VERSION}/public_html/lists/* /var/www/phplist/public_html/lists/

#ADD config/config.php /workdir/config.php
RUN ln -s /volume/conf/config.php /var/www/phplist/public_html/lists/config/config.php

COPY config/default.conf /workdir/default.conf
RUN rm -rf /etc/nginx/conf.d/default.conf && ln -s /volume/conf/default.conf /etc/nginx/conf.d/default.conf

COPY entrypoint.sh /workdir/entrypoint.sh

RUN mkdir /volume && chmod 777 /volume

COPY config/nginx.conf /etc/nginx/nginx.conf
# Install common plugin
RUN wget -P /workdir/ https://github.com/bramley/phplist-plugin-common/archive/master.zip
RUN unzip master.zip && mv /workdir/phplist-plugin-common-master/plugins/* /var/www/phplist/public_html/lists/admin/plugins/ && rm -rfv /workdir/master.zip /workdir/phplist*

# Install rss plugin
RUN wget -P /workdir/ https://github.com/bramley/phplist-plugin-rssfeed/archive/${RSS_PLUGIN_VERSION}.zip
RUN unzip ${RSS_PLUGIN_VERSION}.zip && mv /workdir/phplist-plugin-rssfeed-${RSS_PLUGIN_VERSION}/plugins/* /var/www/phplist/public_html/lists/admin/plugins/ && rm -rfv /workdir/${RSS_VERSION_PLUGIN}.zip /workdir/phplist*

# Fetch latest translations from Github
RUN rm -rfv /var/www/phplist/public_html/lists/texts/ && git clone https://github.com/phpList/phplist-lan-texts.git /var/www/phplist/public_html/lists/texts/

# Install cron
COPY app /usr/src/cron
COPY build.sh /opt/build.sh
RUN /opt/build.sh

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create folder for RSS feed and images
RUN ln -s /volume/rss /var/www/phplist/public_html/ && ln -s /volume/image_generation /var/www/phplist/public_html/

# Set timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN chown -R 104:0 /var/www && chmod -R g+rw /var/www && \
	chmod a+x /workdir/entrypoint.sh && chmod g+rw /workdir

RUN sed -i '/auto_prepend_file =/c\; auto_prepend_file =' /etc/php/7.0/fpm/php.ini

COPY admin/index.php /var/www/phplist/public_html/lists/admin/index.php

VOLUME ["/volume"]
EXPOSE 5000

USER 100104
