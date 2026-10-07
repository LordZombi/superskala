declare global {
    interface Window {
        dataLayer: unknown[]
        /** Mimo produkcie neexistuje, preto sa volá cez window.gtag?.() */
        gtag?: (...args: unknown[]) => void
    }
}

// Google Analytics 4; vo vývoji sa nenačíta, aby lokálne klikanie nekazilo štatistiky
export default defineNuxtPlugin(() => {
    const {gaId} = useRuntimeConfig().public
    if (import.meta.dev || !gaId) return

    window.dataLayer = window.dataLayer || []
    // GA číta len objekt arguments, obyčajné pole by ignoroval
    window.gtag = function () {
        window.dataLayer.push(arguments)
    }
    window.gtag('js', new Date())
    window.gtag('config', gaId)

    // Zobrazenia stránok pri zmene URL posiela GA sám (Enhanced measurement)
    useHead({script: [{src: `https://www.googletagmanager.com/gtag/js?id=${gaId}`, async: true}]})
})
