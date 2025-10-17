FROM php:8.3-fpm-alpine AS base

RUN apk add --no-cache nginx git unzip curl libpng-dev oniguruma-dev libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring bcmath gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

WORKDIR /var/www/html

COPY . .

RUN composer install --no-dev --optimize-autoloader \
    && mkdir -p /run/nginx

# Nginx config
RUN mkdir -p /etc/nginx/conf.d && \
    echo 'server {
        listen 80;
        root /var/www/html/public;
        index index.php;
        location / {
            try_files $uri $uri/ /index.php?$query_string;
        }
        location ~ \.php$ {
            fastcgi_pass 127.0.0.1:9000;
            fastcgi_index index.php;
            include fastcgi_params;
            fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        }
    }' > /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD sh -c "php-fpm -D && nginx -g 'daemon off;'"
