// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    future: {
        compatibilityVersion: 4,
    },
    compatibilityDate: '2024-07-24',
    devtools: {enabled: true},

    css: ['~/assets/css/main.css'],

    postcss: {
        plugins: {
            '@tailwindcss/postcss': {},
            'autoprefixer': {},
        },
    },

    modules: [
        '@nuxt/ui',
        '@nuxt/icon',
        '@nuxtjs/supabase',
        '@vite-pwa/nuxt',
    ],

    supabase: {
        redirect: false,
    },

    runtimeConfig: {
        public: {
            mapyApiKey: '', // NUXT_PUBLIC_MAPY_API_KEY
        },
    },

    app: {
        head: {
            title: 'Superskala',
            meta: [
                {name: 'apple-mobile-web-app-title', content: 'Superskala'},
            ],
            link: [
                {rel: 'icon', type: 'image/png', href: '/favicon/favicon-96x96.png', sizes: '96x96'},
                {rel: 'icon', type: 'image/svg+xml', href: '/favicon/favicon.svg'},
                {rel: 'shortcut icon', href: '/favicon/favicon.ico'},
                {rel: 'apple-touch-icon', sizes: '180x180', href: '/favicon/apple-touch-icon.png'},
                {rel: 'manifest', href: '/favicon/site.webmanifest'},
            ],
        },
    },

    pwa: {
        manifest: {
            name: 'Superskala',
            short_name: 'Superskala',
            description: 'Climbing Topos',
            theme_color: '#1f2937',
            icons: [
                {
                    src: '/favicon/web-app-manifest-192x192.png',
                    sizes: '192x192',
                    type: 'image/png',
                },
                {
                    src: '/favicon/web-app-manifest-512x512.png',
                    sizes: '512x512',
                    type: 'image/png',
                },
                {
                    src: '/favicon/web-app-manifest-512x512.png',
                    sizes: '512x512',
                    type: 'image/png',
                    purpose: 'any maskable',
                },
            ],
        },
        workbox: {
            globPatterns: ['**/*.{js,css,html,png,svg,ico}'],
            runtimeCaching: [
                {
                    urlPattern: /^https:\/\/api\.mapy\.cz\/v1\/maptiles\/.*/,
                    handler: 'CacheFirst',
                    options: {
                        cacheName: 'map-tiles',
                        expiration: {
                            maxEntries: 500,
                            maxAgeSeconds: 60 * 60 * 24 * 30, // 30 Days
                        },
                        cacheableResponse: {
                            statuses: [0, 200],
                        },
                    },
                },
                {
                    urlPattern: /^https:\/\/.*\.supabase\.co\/rest\/v1\/.*/,
                    handler: 'NetworkFirst',
                    options: {
                        cacheName: 'supabase-data',
                        expiration: {
                            maxEntries: 50,
                            maxAgeSeconds: 60 * 60 * 24 * 7, // 1 Week
                        },
                        cacheableResponse: {
                            statuses: [0, 200],
                        },
                    },
                },
            ],
        },
        devOptions: {
            enabled: true,
            suppressWarnings: true,
            navigateFallback: '/',
            navigateFallbackAllowlist: [/^\/$/],
            type: 'module',
        },
    },
});
