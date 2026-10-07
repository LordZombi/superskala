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

    ui: {
        colorMode: false,
    },

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

    // Ikony idú do bundlu, inak ich @nuxt/icon ťahá z Iconify API a bez signálu ostanú prázdne
    icon: {
        clientBundle: {
            scan: true,
            // Ikony, ktoré si Nuxt UI pýta samo (akordeón, toasty, načítavanie)
            icons: [
                'lucide:chevron-down',
                'lucide:circle-alert',
                'lucide:circle-check',
                'lucide:circle-x',
                'lucide:info',
                'lucide:loader-circle',
                'lucide:x',
            ],
        },
    },

    runtimeConfig: {
        public: {
            mapyApiKey: '', // NUXT_PUBLIC_MAPY_API_KEY
            // Measurement ID je verejné (vidno ho v zdrojáku každej stránky), preto nemusí byť v .env
            gaId: 'G-EY7G4EY7LR',
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
                        // Uložená oblasť má okolo 500 dlaždíc, staršie sa nesmú vytlačiť hneď ďalšou
                        expiration: {
                            maxEntries: 10000,
                            maxAgeSeconds: 60 * 60 * 24 * 365
                        },
                        cacheableResponse: {
                            statuses: [200]
                        }
                    }
                },
                {
                    urlPattern: /^https:\/\/.*\.supabase\.co\/storage\/v1\/object\/public\/.*/,
                    handler: 'CacheFirst',
                    options: {
                        cacheName: 'boulder-images',
                        // Fotky uložených oblastí musia vydržať aj sezónu bez návštevy
                        expiration: {
                            maxEntries: 2000,
                            maxAgeSeconds: 60 * 60 * 24 * 365
                        },
                        cacheableResponse: {
                            statuses: [0, 200]
                        }
                    }
                },
                {
                    urlPattern: /^https:\/\/.*\.supabase\.co\/rest\/v1\/.*/,
                    // Online vždy čerstvé dáta (nové oblasti a cesty hneď), cache len bez siete alebo pri slabom signáli
                    handler: 'NetworkFirst',
                    options: {
                        cacheName: 'supabase-data',
                        networkTimeoutSeconds: 3,
                        // Online sa dáta aj tak obnovia na pozadí; offline je lepšia stará verzia ako žiadna
                        expiration: {
                            maxEntries: 500,
                            maxAgeSeconds: 60 * 60 * 24 * 365
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
