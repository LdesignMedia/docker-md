#!/bin/bash

# COLORS
red=`tput setaf 1`
green=`tput setaf 2`
yellow=`tput setaf 3`
magenta=`tput setaf 5`
reset=`tput sgr0`


echo "placeholder" > /var/moodledata/placeholder
chown -R www-data:www-data /var/moodledata
chmod 777 /var/moodledata

read pid cmd state ppid pgrp session tty_nr tpgid rest < /proc/self/stat
trap "kill -TERM -$pgrp; exit" EXIT TERM KILL SIGKILL SIGTERM SIGQUIT

#start up cron
/usr/sbin/cron


if [ ! -f "/opt/moodle_installed" ]; then

   echo -e "${green}Start install moodle ${reset}"
   echo $DB_ENV_MYSQL_DATABASE	 
   sleep 15
commands="--chmod=2777 \
        --dataroot=/var/moodledata \
        --lang=en \
        --wwwroot=$MOODLE_URL \
        --dbhost=$DB_PORT_3306_TCP_ADDR \
        --dbtype=mysqli \
        --dbname=$DB_ENV_MYSQL_DATABASE \
        --dbuser=$DB_ENV_MYSQL_USER \
        --dbpass=$MYSQL_ROOT_PASSWORD \
        --adminemail=$MOODLE_EMAIL \
        --fullname=$SITE_FULLNAME \
        --shortname=$SITE_FULLNAME \
        --agree-license \
        --adminuser=$MOODLE_EMAIL \
        --adminpass=$MOODLE_PASSWORD \
        --non-interactive"

    rm /var/www/html/config.php

    echo $commands
	php /var/www/html/admin/cli/install.php ${commands}
	
	chown www-data:www-data /var/www/html/config.php

	# Installed.
   	echo "true" > /opt/moodle_installed

else
 	echo -e "${red}Already Installed${reset}"
fi


source /etc/apache2/envvars
tail -F /var/log/apache2/* &
exec apache2 -D FOREGROUND