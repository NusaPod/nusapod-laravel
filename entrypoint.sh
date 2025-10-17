#!/bin/sh
set -e

# Buat struktur storage jika belum ada
mkdir -p \
  storage/app/public \
  storage/framework/cache \
  storage/framework/sessions \
  storage/framework/views \
  storage/logs

# Pastikan izin benar
chmod -R 777 storage

# Jalankan Laravel artisan command
php artisan storage:link || true

# Jalankan proses utama (php-fpm + nginx)
php-fpm -D
nginx -g 'daemon off;'
