FROM php:7.4-apache


# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo pdo_mysql
RUN a2enmod rewrite


# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

ADD . /var/www
ADD ./public /var/www/html

RUN chown -R www-data:www-data /var/www

WORKDIR /var/www
USER $user

RUN composer install

CMD php artisan serve --host=0.0.0.0 --port=8181
EXPOSE 8181