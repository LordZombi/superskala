// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    future: {
        compatibilityVersion: 4,
    },
    compatibilityDate: '2024-07-24',
    devtools: {enabled: true},
    nitro: {
        prerender: {
            routes: ['/']
        }
    },

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
            title: 'Superskaly',
            meta: [
                {name: 'apple-mobile-web-app-title', content: 'Superskaly'},
            ],
            link: [
                {rel: 'icon', type: 'image/png', href: '/favicon/favicon-96x96.png', sizes: '96x96'},
                {rel: 'icon', type: 'image/svg+xml', href: '/favicon/favicon.svg'},
                {rel: 'shortcut icon', href: '/favicon/favicon.ico'},
                {rel: 'apple-touch-icon', sizes: '180x180', href: '/favicon/apple-touch-icon.png'},
                {rel: 'manifest', href: '/manifest.webmanifest'}
            ],
        },
    },

    pwa: {
        devOptions: {
            enabled: true,
            type: 'module',
            navigateFallback: '/',
        },
        manifest: {
            name: 'Superskaly',
            short_name: 'Superskaly',
            description: 'Interaktívny digitálny sprievodca boulderingom a podrobné nákresy lezeckých ciest.',
            theme_color: '#FFFFFF',
            background_color: '#FFFFFF',
            display: 'standalone',
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
        registerType: 'autoUpdate',
        workbox: {
            clientsClaim: true,
            skipWaiting: true,
            globPatterns: ['**/*.{js,css,html,png,svg,ico,json,woff2}'],
            runtimeCaching: [
                {
                    urlPattern: /^https:\/\/api\.mapy\.cz\/v1\/maptiles\/.*/,
                    handler: 'CacheFirst',
                    options: {
                        cacheName: 'map-tiles',
                        expiration: {
                            maxEntries: 500,
                            maxAgeSeconds: 60 * 60 * 24 * 30
                        }
                    }
                },
                {
                    urlPattern: /^https:\/\/.*\.supabase\.co\/storage\/v1\/object\/public\/.*/,
                    handler: 'CacheFirst',
                    options: {
                        cacheName: 'boulder-images',
                        expiration: {
                            maxEntries: 100,
                            maxAgeSeconds: 60 * 60 * 24 * 30
                        },
                        cacheableResponse: {
                            statuses: [0, 200]
                        }
                    }
                },
                {
                    urlPattern: /^https:\/\/.*\.supabase\.co\/rest\/v1\/.*/,
                    handler: 'StaleWhileRevalidate',
                    options: {
                        cacheName: 'supabase-data',
                        expiration: {
                            maxEntries: 100,
                            maxAgeSeconds: 60 * 60 * 24 * 7
                        },
                        cacheableResponse: {
                            statuses: [0, 200]
                        }
                    }
                }
            ]
        }
    },
});
