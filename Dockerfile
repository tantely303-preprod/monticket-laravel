FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    zip unzip git curl libpq-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_pgsql

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Install Node 20 (pour Laravel + Vite)
RUN curl -fsSL https://deb.nodesource.com/setup_20.x | bash - \
    && apt-get install -y nodejs

# Set working directory
WORKDIR /app

# Copy project files
COPY . .

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader

# Install JS dependencies & build Vite
RUN npm install
RUN npm run build

# --- Gestion de l'APP_KEY ---

# Option 1 : Copier .env.example si .env n'existe pas
RUN cp .env.example .env || true

# Générer Laravel APP_KEY
RUN php artisan key:generate --force

# Render exige le port 10000
EXPOSE 10000

# Start Laravel server sur le port Render obligatoire
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=10000"]

