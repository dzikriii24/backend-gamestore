# Gunakan image PHP dengan FPM dan Nginx yang sudah terintegrasi
FROM webdevops/php-nginx:8.3-alpine

# Set working directory
WORKDIR /app

# INSTALL DEPENDENSI POSTGRESQL TERLEBIH DAHULU
# Untuk Alpine Linux (image 'alpine'), pakai apk:
RUN apk update && apk add --no-cache \
    postgresql-dev \
    postgresql-client \
    && docker-php-ext-install pdo pdo_pgsql \
    && apk del --purge

# Salin kode aplikasi
COPY . /app

# Install Composer dependencies
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Setup permission untuk Laravel
RUN chown -R application:application /app \
    && chmod -R 755 /app/storage \
    && chmod -R 755 /app/bootstrap/cache

# Expose port 80
EXPOSE 80

# Copy custom startup script
COPY docker/start.sh /opt/docker/provision/entrypoint.d/99-laravel.sh
RUN chmod +x /opt/docker/provision/entrypoint.d/99-laravel.sh