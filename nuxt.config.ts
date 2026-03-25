// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    compatibilityDate: '2026-03-25',
    devtools: {enabled: true},
    modules: [
        '@nuxtjs/supabase',
        '@vite-pwa/nuxt'
    ],
    supabase: {
        redirect: false
    },
    runtimeConfig: {
        public: {
            mapyApiKey: '', // NUXT_PUBLIC_MAPY_API_KEY
        }
    },
    app: {
        head: {
            link: [
                { rel: 'icon', type: 'image/svg+xml', href: '/favicon.svg' },
                { rel: 'icon', type: 'image/x-icon', href: '/favicon.ico', sizes: '32x32' }
            ]
        }
    },
    pwa: {
        manifest: {
            name: 'Superskala',
            short_name: 'Superskala',
            description: 'Climbing Topos',
            theme_color: '#1f2937',
            icons: [
                {
                    src: 'pwa-192x192.png',
                    sizes: '192x192',
                    type: 'image/png',
                },
                {
                    src: 'pwa-512x512.png',
                    sizes: '512x512',
                    type: 'image/png',
                },
                {
                    src: 'pwa-512x512.png',
                    sizes: '512x512',
                    type: 'image/png',
                    purpose: 'any maskable',
                },
            ],
        },
        workbox: {
            globPatterns: ['**/*.{js,css,html,png,svg,ico}'],
        },
        devOptions: {
            enabled: true,
            suppressWarnings: true,
            navigateFallback: '/',
            navigateFallbackAllowlist: [/^\/$/],
            type: 'module',
        },
    }
})
