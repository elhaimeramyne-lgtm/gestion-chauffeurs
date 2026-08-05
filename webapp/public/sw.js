/**
 * Service Worker IAM — stratégie "Network First" avec fallback cache.
 *
 * - Ressources statiques : cache agressif (Cache First)
 * - API calls : Network Only (toujours fraîches)
 * - Navigation hors ligne : sert la page d'accueil depuis le cache
 */
const CACHE_NAME = 'iam-v2';
const STATIC_ASSETS = ['/', '/manifest.json', '/icon-192.png', '/icon-512.png'];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => cache.addAll(STATIC_ASSETS)).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('fetch', (event) => {
  const { request } = event;
  const url = new URL(request.url);

  // Ignorer les requêtes API et SSE — toujours en réseau
  if (url.pathname.startsWith('/api/') || request.headers.get('accept')?.includes('text/event-stream')) {
    return;
  }

  // Navigations (HTML) : Network First, fallback sur "/"
  if (request.mode === 'navigate') {
    event.respondWith(
      fetch(request).catch(() =>
        caches.match('/').then((r) => r ?? new Response('Hors ligne', { status: 503 }))
      )
    );
    return;
  }

  // Icônes / manifeste uniquement : Cache First (changent rarement).
  if (STATIC_ASSETS.some((asset) => url.pathname === asset) || url.pathname.startsWith('/icon-')) {
    event.respondWith(
      caches.match(request).then((cached) => {
        if (cached) return cached;
        return fetch(request).then((response) => {
          if (response.ok && response.type === 'basic') {
            const toCache = response.clone();
            caches.open(CACHE_NAME).then((cache) => cache.put(request, toCache));
          }
          return response;
        });
      })
    );
    return;
  }

  // Tout le reste (JS, CSS, modules Vite en dev...) : Network First, avec
  // repli sur le cache seulement hors-ligne. Évite qu'un ancien build ne
  // reste bloqué en cache et masque indéfiniment les mises à jour de code.
  event.respondWith(
    fetch(request)
      .then((response) => {
        if (response.ok && response.type === 'basic') {
          const toCache = response.clone();
          caches.open(CACHE_NAME).then((cache) => cache.put(request, toCache));
        }
        return response;
      })
      .catch(() => caches.match(request))
  );
});
