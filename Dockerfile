# Dockerfile
FROM richarvey/nginx-php-fpm:3.1.6

COPY . /var/www/html
WORKDIR /var/www/html

# Environment variables
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

# Laravel production settings
ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV COMPOSER_ALLOW_SUPERUSER 1

# Copy custom Nginx config
COPY conf/nginx/nginx-site.conf /etc/nginx/sites-available/default.conf

# Expose port 80
EXPOSE 80

CMD ["/start.sh"]