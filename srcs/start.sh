#!/bin/bash

# Generate SSL certificate with using OpenSSL
cd /etc/nginx/
openssl req -newkey rsa:4096 \
-x509 \
-sha256 \
-days 365 \
-nodes \
-out example.crt \
-keyout example.key \
-subj "/C=JP/ST=Tokyo/L=Tokyo/O=42Tokyo/OU=IT/CN=localhost"

# Create a database for wordpress and a user in MySQL
service mysql start
mysql -h localhost -proot -e "CREATE DATABASE wordpress; \
CREATE USER 'mmasuda'@'localhost' identified by 'lanoixde55'; \
GRANT ALL PRIVILEGES ON wordpress.* TO 'mmasuda'@'localhost';"

# Install WordPress
cd /var/www/html/
wget https://wordpress.org/latest.tar.gz
tar xvf latest.tar.gz && rm latest.tar.gz
mv /tmp/wp-config.php /var/www/html/wordpress
chown -R www-data:www-data /var/www/html/wordpress

# Install phpMyAdmin
cd /tmp/
wget https://www.phpmyadmin.net/downloads/phpMyAdmin-latest-all-languages.tar.gz
mkdir /var/www/html/phpmyadmin/
tar xvf phpMyAdmin-latest-all-languages.tar.gz -C /var/www/html/phpmyadmin/ --strip-components 1
cp /var/www/html/phpmyadmin/config.sample.inc.php /var/www/html/phpmyadmin/config.inc.php
rm phpMyAdmin-latest-all-languages.tar.gz

# Create directory for autoindex test
mkdir /var/www/html/files/
echo "Welcome to test.txt!" > /var/www/html/files/test.txt
echo "Welcome to test2.txt!" > /var/www/html/files/test2.txt

# Delete a symbolic link
unlink /etc/nginx/sites-enabled/default

# If the autoindex variable is specified as off, turn off autoindex.
if [ "$AUTOINDEX" = "off" ]
then
	sed -i "s/autoindex on;/autoindex off;/g" /etc/nginx/nginx.conf
	echo "Turn off autoindex."
fi

# Start services
service php7.3-fpm stop
service php7.3-fpm start
service nginx start

# Keep move
tail -f /dev/null