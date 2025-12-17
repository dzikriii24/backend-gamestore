# Stage 1: Builder - Instal semua dependensi, termasuk dev
FROM composer:2.8 AS builder

WORKDIR /app
COPY . .
RUN composer install --no-interaction --optimize-autoloader --no-dev

# Stage 2: Runner - Hanya ambil yang dibutuhkan untuk produksi
FROM php:8.3-fpm-alpine AS runner

# Install sistem dependencies yang diperlukan Laravel (pdo, opcache, dll)
RUN apk add --no-cache \
    nginx \
    supervisor \
    curl \
    libpng-dev \
    libzip-dev \
    postgresql-dev \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install pdo pdo_pgsql gd zip opcache \
    && rm -rf /var/cache/apk/*

# Konfigurasi opcache untuk performa production
RUN { \
    echo 'opcache.enable=1'; \
    echo 'opcache.memory_consumption=128'; \
    echo 'opcache.interned_strings_buffer=8'; \
    echo 'opcache.max_accelerated_files=4000'; \
    echo 'opcache.revalidate_freq=2'; \
    echo 'opcache.fast_shutdown=1'; \
    echo 'opcache.enable_cli=1'; \
} > /usr/local/etc/php/conf.d/opcache-recommended.ini

# Salin aplikasi dari stage builder
COPY --from=builder /app /var/www/html
WORKDIR /var/www/html

# Atur ownership dan permission yang benar
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 755 /var/www/html/storage \
    && chmod -R 755 /var/www/html/bootstrap/cache

# Salin konfigurasi Nginx dan supervisor
COPY conf/nginx/nginx-site.conf /etc/nginx/http.d/default.conf
COPY docker/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# Salin script startup dan beri izin eksekusi
COPY docker/start-container /usr/local/bin/start-container
RUN chmod +x /usr/local/bin/start-container

# Expose port 80
EXPOSE 80

# Jalankan supervisor yang akan mengelola PHP-FPM dan Nginx
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisor.conf"]