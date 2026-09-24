import { defineConfig } from 'vite';
import laravel from 'laravel-vite-plugin';

// Inside the Base44 sandbox the Vite dev server is reached through a public
// HTTPS proxy on port 5173; outside it this stays undefined (Vite defaults).
const previewHost = process.env.BASE44_PUBLIC_HOST_SUFFIX
    ? `5173-${process.env.BASE44_PUBLIC_HOST_SUFFIX}`
    : null;

export default defineConfig({
    plugins: [
        laravel({
            input: ['resources/css/app.css', 'resources/js/app.js'],
            refresh: true,
        }),
    ],
    server: previewHost
        ? {
              host: '0.0.0.0',
              port: 5173,
              strictPort: true,
              allowedHosts: true,
              cors: true,
              origin: `https://${previewHost}`,
              hmr: { host: previewHost, protocol: 'wss', clientPort: 443 },
              watch: { usePolling: true },
          }
        : undefined,
});
