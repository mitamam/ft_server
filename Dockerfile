# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Dockerfile                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mmasuda <mmasuda@student.42tokyo.jp>       +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2021/06/24 19:57:49 by mmasuda           #+#    #+#              #
#    Updated: 2021/06/26 13:34:23 by mmasuda          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# Pull image
FROM debian:buster

RUN set -ex; \
	DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y install \
	mariadb-server \
	mariadb-client \
	nginx \
	openssl \
	wget \
	vim \
	php-cgi php-common php-fpm php-pear php-mbstring php-zip php-net-socket php-gd php-xml-util php-gettext php-mysql php-bcmath \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY srcs/nginx.conf /etc/nginx/
COPY srcs/wp-config.php /tmp/
COPY srcs/start.sh /tmp/

ENV AUTOINDEX="on"

EXPOSE 80 443

CMD [ "/tmp/start.sh" ]