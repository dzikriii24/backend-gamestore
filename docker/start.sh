#!/bin/sh

echo "🚀 Starting Laravel application..."

# Generate application key jika belum ada
if [ ! -f /app/.env ]; then
    echo "📝 Copying .env.example to .env..."
    cp /app/.env.example /app/.env
fi

if [ -z "$(grep '^APP_KEY=' /app/.env)" ] || [ "$(grep '^APP_KEY=' /app/.env | cut -d= -f2)" = "" ]; then
    echo "🔑 Generating application key..."
    php /app/artisan key:generate --force
fi

# Cache config untuk production
echo "⚡ Caching configuration..."
php /app/artisan config:cache
php /app/artisan route:cache
php /app/artisan view:cache

echo "✅ Laravel is ready!"