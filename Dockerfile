# Docker-Moodle
# Dockerfile for moodle instance. more dockerish version of https://github.com/sergiogomez/docker-moodle
# Forked from Jon Auer's docker version. https://github.com/jda/docker-moodle
FROM ubuntu:16.04
MAINTAINER Luuk Verhoeven luuk@moodlefreak.com

VOLUME ["/var/moodledata"]
EXPOSE 80 443 3306

ARG moodle_version=35
ENV MOODLE_VERSION=$moodle_version
ENV MOODLE_EMAIL luuk@moodlefreak.com

# Keep upstart from complaining
# RUN dpkg-divert --local --rename --add /sbin/initctl
# RUN ln -sf /bin/true /sbin/initctl

# Let the container know that there is no tty
ENV DEBIAN_FRONTEND noninteractive

# Database info and other connection information derrived from env variables. See readme.
# Set ENV Variables externally Moodle_URL should be overridden.
ENV MOODLE_URL http://127.0.0.1

# MYSQL DB
RUN apt-get update && \
    apt-get -y install vim mysql-client pwgen python-setuptools curl git unzip apache2 php \
        php-gd libapache2-mod-php postfix wget supervisor php-pgsql curl libcurl3 \
        libcurl3-dev php-curl php-xmlrpc php-intl php-mysql git-core php-xml php-mbstring \
        php-zip php-soap cron php7.0-ldap python-pip

# NODE
RUN pip install supervisor-stdout

RUN	cd /tmp && \
    wget -O moodle.zip https://download.moodle.org/download.php/direct/stable$MOODLE_VERSION/moodle-3.5.zip && \
    unzip moodle.zip && \
    mv /tmp/moodle/* /var/www/html/ && \
    rm /var/www/html/index.html

# cron
COPY moodlecron /etc/cron.d/moodlecron
RUN chmod 0644 /etc/cron.d/moodlecron

# Enable SSL, moodle requires it
RUN a2enmod ssl && a2ensite default-ssl  #if using proxy dont need actually secure connection

# Fix some server settings.
RUN sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/cli/php.ini && \
    sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/display_errors = .*/display_errors = On/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/upload_max_filesize = .*/upload_max_filesize = 100M/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/post_max_size = .*/post_max_size = 100M/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/;date.timezone.*/date.timezone = UTC/" /etc/php/7.0/apache2/php.ini && \
    sed -i "s/AllowOverride None*/AllowOverride All/" /etc/apache2/apache2.conf && \
    find /etc/php/7.0/cli/conf.d/ -name "*.ini" -exec sed -i -re 's/^(\s*)#(.*)/\1;\2/g' {} \;

# install composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc

# NVM install
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.9/install.sh | bash

RUN export NVM_DIR="$HOME/.nvm" && \
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
	 nvm install 8.9 && \
	 nvm use 8.9

# Moodle testing suite.
RUN export NVM_DIR="$HOME/.nvm" && \
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
	cd /var/www/html/ && \
	composer create-project -n --no-dev --prefer-dist moodlerooms/moodle-plugin-ci ci ^2 && \
	export PATH="$(cd ci/bin; pwd):$(cd ci/vendor/bin; pwd):$PATH"

# This takes a while.........
#RUN cd /var/www/html/ && \
#	ln -s /usr/bin/nodejs /usr/bin/node && \
#	npm set progress=false && \
#	npm install --save yarn-install && \
#    npm install --no-cache --dev --loglevel verbose

# Install yarn.
RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    npm install -g yarn async

RUN cd /var/www/html/ && composer install

RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    cd /var/www/html/ && \
    ln -s /usr/bin/nodejs /usr/bin/node && \
    yarn install --prefer-offline


# Make navigation better.
RUN wget -O /tmp/local_commander.zip https://moodle.org/plugins/download.php/16351/local_commander_moodle34_2018032702.zip && \
    cd /tmp  && \
    unzip local_commander.zip && \
    mkdir /var/www/html/local/commander && \
    mv /tmp/commander/* /var/www/html/local/commander

# Cleanup, this is ran to reduce the resulting size of the image.
RUN apt-get clean autoclean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/lib/dpkg/* /var/lib/cache/* /var/lib/log/*

# Testing your plugin.
COPY plugin-test.sh /var/www/html/plugin-test.sh
RUN chmod +x /var/www/html/plugin-test.sh

COPY directlogin.php /var/www/html/directlogin.php
COPY privacy_export.php /var/www/html/privacy_export.php
COPY privacy_test.php /var/www/html/privacy_test.php

# Make all www owned by www
RUN chown -R www-data:www-data /var/www/html

ADD ./foreground.sh /etc/apache2/foreground.sh
RUN chmod +x /etc/apache2/foreground.sh

RUN echo "AcceptPathInfo On" >> /etc/apache2/apache2.ini

RUN export NVM_DIR="$HOME/.nvm" && \
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && \
    npm install -g grunt

# Fix line endings, if there are problems
RUN sed -i -e 's/\r$//' /var/www/html/plugin-test.sh

CMD ["/etc/apache2/foreground.sh"]

# Internal notes for the developer.
# Testing after build 
# docker build -t moodlefreak/docker-md:moodle34 .
# docker run -d -P --rm --name moodle -e MOODLE_URL=http://localhost:8080 -p 8080:80 moodle-md:moodle34
# compose the app with docker-compose up --force-recreate