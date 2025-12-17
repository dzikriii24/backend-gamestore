# Gunakan image dengan PHP dan Nginx
FROM richarvey/nginx-php-fpm:3.1.6

# Salin semua kode proyek ke container
COPY . /var/www/html

# Set working directory
WORKDIR /var/www/html

# Konfigurasi environment untuk production
ENV SKIP_COMPOSER 1
ENV WEBROOT /var/www/html/public
ENV PHP_ERRORS_STDERR 1
ENV RUN_SCRIPTS 1
ENV REAL_IP_HEADER 1

ENV APP_ENV production
ENV APP_DEBUG false
ENV LOG_CHANNEL stderr
ENV COMPOSER_ALLOW_SUPERUSER 1

# Jalankan script startup saat container mulai
CMD ["/start.sh"]