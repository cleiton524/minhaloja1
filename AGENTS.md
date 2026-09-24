# Agent notes

Laravel 11 + Breeze (Blade, Tailwind, Alpine) with SQLite. Run with `docker compose -f docker-compose.base44.yml up -d --build`.

## Services
- `setup` (one-shot): `composer install`, then `migrate --seed` only when `database/database.sqlite` doesn't exist yet (the `UserSeeder` uses plain inserts and fails if re-run), otherwise just `migrate`. To reseed from scratch: delete `database/database.sqlite` and re-run `up`.
- `app`: `php artisan serve` on host port 3000. PHP edits apply per request; no restart needed.
- `vite`: Vite dev server on host port 5173. The browser loads assets directly from `https://5173-$BASE44_PUBLIC_HOST_SUFFIX` (via `public/hot`), so port 5173 must stay published. The preview-specific server config in `vite.config.js` only turns on when `BASE44_PUBLIC_HOST_SUFFIX` is set.

## Quirks
- PHP runtime is pinned to 8.3 (`.base44/php.Dockerfile`): the `composer:2` image ships PHP 8.5, which `composer.lock` rejects.
- The platform-generated `APP_KEY` placeholder isn't in Laravel's format, so `.base44/with-app-key.sh` (the PHP services' entrypoint) derives a valid `base64:` key from it. A real `base64:...` key passes through unchanged.
- The preview proxy sends no `X-Forwarded-*` headers. `AppServiceProvider` forces the root URL and https from `APP_URL` in the `local` env when APP_URL is https. Without this, forms post to the internal http host.
- The preview is a cross-site iframe, so `.env.base44-defaults` sets `SESSION_SAME_SITE=none` + `SESSION_SECURE_COOKIE=true`. Without them, login fails with a 419 CSRF error.
- `/dashboard` requires a verified email. Seeded users have `email_verified_at = NULL`, so they land on the verify-email page. Mail goes to the log (`storage/logs/laravel.log`).

## Verify
- `curl https://3000-$BASE44_PUBLIC_HOST_SUFFIX/up` should return 200.
- Seeded logins (password `999cldvC`): `cursoquioratocleiton@gmail.com` (admin), `vendedorquioratocleiton@gmail.com` (vendor), `clientequioratocleiton@gmail.com` (user).
- Tests: `docker compose -f docker-compose.base44.yml exec app php artisan test`.
