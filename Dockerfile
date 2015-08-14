FROM php:5.6-apache

VOLUME /var/www/html

ENV WORDPRESS_VERSION 4.2.4
ENV WORDPRESS_SHA1 9c90d175e0e64f51681101058a820cd76475949a
ENV WORDPRESS_NAME dockerpress
ENV WORDPRESS_AUTH_KEY ""
ENV WORDPRESS_AUTH_SALT ""
ENV WORDPRESS_DB_HOST localhost
ENV WORDPRESS_DB_NAME wordpress_dev_${WORDPRESS_NAME}
ENV WORDPRESS_DB_PASSWORD ""
ENV WORDPRESS_DB_USER ${WORDPRESS_NAME}_db
ENV WORDPRESS_LOGGED_IN_KEY ""
ENV WORDPRESS_LOGGED_IN_SALT ""
ENV WORDPRESS_NONCE_KEY ""
ENV WORDPRESS_NONCE_SALT ""
ENV WORDPRESS_SECURE_AUTH_KEY ""
ENV WORDPRESS_SECURE_AUTH_SALT ""

RUN a2enmod rewrite ssl \
    && apt-get update \
    && apt-get install -y \
        libpng12-dev \
        libjpeg-dev \
    && rm -rf /var/lib/apt/lists/* \
	&& docker-php-ext-configure gd --with-png-dir=/usr --with-jpeg-dir=/usr \
	&& docker-php-ext-install gd \
	&& docker-php-ext-install mysqli \
    && curl -o wordpress.tar.gz -SL https://wordpress.org/wordpress-${WORDPRESS_VERSION}.tar.gz \
	&& echo "$WORDPRESS_SHA1 *wordpress.tar.gz" | sha1sum -c - \
	&& tar -xzf wordpress.tar.gz -C /usr/src/ \
	&& rm wordpress.tar.gz \
	&& chown -R www-data:www-data /usr/src/wordpress

COPY docker-entrypoint.sh /entrypoint.sh

# grr, ENTRYPOINT resets CMD now
ENTRYPOINT ["/entrypoint.sh"]
CMD ["apache2-foreground"]
