# Runtime-only image for the Base44 dev environment (source is bind-mounted, never copied).
# PHP 8.3: composer.lock pins packages that don't allow PHP 8.5 yet.
FROM php:8.3-cli
RUN apt-get update && apt-get install -y --no-install-recommends git unzip && rm -rf /var/lib/apt/lists/*
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer
