# Gunakan image PHP dengan FPM dan Nginx yang sudah terintegrasi
FROM webdevops/php-nginx:8.3-alpine

# Set working directory
WORKDIR /app

# Install PostgreSQL driver
RUN docker-php-ext-install pdo pdo_pgsql

# Salin kode aplikasi
COPY . /app

# Install Composer dependencies (tanpa dev untuk production)
RUN composer install --no-dev --optimize-autoloader --no-interaction

# Setup permission untuk Laravel
RUN chown -R application:application /app \
    && chmod -R 755 /app/storage \
    && chmod -R 755 /app/bootstrap/cache

# Copy konfigurasi PHP custom
COPY docker/php/php.production.ini /opt/docker/etc/php/php.ini

# Expose port 80
EXPOSE 80