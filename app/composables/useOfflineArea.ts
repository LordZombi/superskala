import {computed, ref, toValue, type MaybeRefOrGetter} from 'vue'
import {writeSnapshot} from '~/composables/useSupabase'

/** Šablóna dlaždíc pre Leaflet; offline uloženie musí sťahovať presne tie isté URL, inak ich service worker nenájde */
export const mapTileUrl = (apiKey: string) =>
    `https://api.mapy.cz/v1/maptiles/outdoor/256/{z}/{x}/{y}?apikey=${apiKey}`

interface OfflineArea {
    id: string
    sectors: {
        lat: number | null
        lon: number | null
        boulders: { image_url: string | null, lat: number | null, lon: number | null }[]
    }[]
}

const STORAGE_KEY = 'offline-areas'
// Okolie oblasti okolo krajných bodov, aby bolo vidno aj prístup ku skalám
const PADDING_DEG = 0.004
const MIN_ZOOM = 12
const MAX_ZOOM = 18
// Väčšiu oblasť sťahujeme bez najväčšieho priblíženia, nech to netrvá večnosť
const MAX_TILES = 1500
const CONCURRENCY = 6

// Kedy bola ktorá oblasť naposledy uložená (ISO dátum); localStorage nemusí byť dostupný
const readSaved = (): Record<string, string> => {
    try {
        return JSON.parse(localStorage.getItem(STORAGE_KEY) ?? '{}')
    } catch {
        return {}
    }
}

const writeSaved = (saved: Record<string, string>) => {
    try {
        localStorage.setItem(STORAGE_KEY, JSON.stringify(saved))
    } catch {
        // Bez localStorage len nebudeme vedieť ukázať, že je oblasť uložená
    }
}

// Na mobile (slabý signál, zdieľaná IP operátora → limit mapy.cz, HTTP 429) občas zlyhá aj stiahnutie, ktoré by o chvíľu prešlo
const ATTEMPTS = 3
const RETRY_DELAY_MS = 600

// Fotka sa ukladá priamo do IndexedDB (cache service workera ju mohla minúť, nikto to nekontroloval); dlaždice ostávajú v cache
const download = async (url: string, isPhoto = false) => {
    for (let attempt = 1; ; attempt++) {
        // reload: obnovenie uloženej oblasti musí vziať aj fotku, ktorá sa pod rovnakým názvom v úložisku vymenila
        const response = await fetch(url, isPhoto ? {cache: 'reload'} : undefined).catch(() => null)
        if (response?.ok && (!isPhoto || await writeSnapshot(`photo:${url}`, await response.blob()))) return true

        if (attempt === ATTEMPTS) {
            console.warn(`Offline uloženie: ${url} zlyhalo (${response?.ok ? 'úložisko' : response?.status ?? 'sieť'})`)
            return false
        }

        await new Promise(resolve => setTimeout(resolve, RETRY_DELAY_MS * attempt))
    }
}

const tileX = (lon: number, z: number) => Math.floor((lon + 180) / 360 * 2 ** z)
const tileY = (lat: number, z: number) => {
    const rad = lat * Math.PI / 180

    return Math.floor((1 - Math.log(Math.tan(rad) + 1 / Math.cos(rad)) / Math.PI) / 2 * 2 ** z)
}

const tileUrls = (template: string, points: { lat: number, lon: number }[]) => {
    if (!points.length) return []

    const lats = points.map(({lat}) => lat)
    const lons = points.map(({lon}) => lon)
    const [south, north] = [Math.min(...lats) - PADDING_DEG, Math.max(...lats) + PADDING_DEG]
    const [west, east] = [Math.min(...lons) - PADDING_DEG, Math.max(...lons) + PADDING_DEG]

    const urls: string[] = []

    for (let z = MIN_ZOOM; z <= MAX_ZOOM; z++) {
        const zoomUrls: string[] = []

        for (let x = tileX(west, z); x <= tileX(east, z); x++) {
            for (let y = tileY(north, z); y <= tileY(south, z); y++) {
                zoomUrls.push(template.replace('{z}', String(z)).replace('{x}', String(x)).replace('{y}', String(y)))
            }
        }

        if (urls.length + zoomUrls.length > MAX_TILES) break
        urls.push(...zoomUrls)
    }

    return urls
}

/**
 * Stiahne fotky kameňov (do IndexedDB) a mapové dlaždice oblasti (cache service workera), aby boli aj bez signálu.
 * Samotné dáta oblasti sú v cache už po jej otvorení (supabase-data v nuxt.config).
 */
export function useOfflineArea(area: MaybeRefOrGetter<OfflineArea | null>) {
    const config = useRuntimeConfig()
    const savedAt = ref<string | null>(null)
    const progress = ref<number | null>(null)
    const failed = ref(0)

    const isSaving = computed(() => progress.value !== null)

    const refresh = () => {
        const id = toValue(area)?.id
        savedAt.value = id ? readSaved()[id] ?? null : null
    }

    const save = async () => {
        const current = toValue(area)
        if (!current || isSaving.value) return

        // Bez toho môže prehliadač pri nedostatku miesta cache potichu zmazať
        await navigator.storage?.persist?.().catch(() => false)

        const boulders = current.sectors.flatMap(sector => sector.boulders)
        const points = [...current.sectors, ...boulders].flatMap(({lat, lon}) =>
            lat && lon ? [{lat, lon}] : [])
        const images = boulders.flatMap(boulder => boulder.image_url ?? [])
        const photos = new Set(images)
        const queue = [...new Set([...images, ...tileUrls(mapTileUrl(config.public.mapyApiKey), points)])]
        const total = queue.length

        progress.value = 0
        failed.value = 0

        let done = 0
        const worker = async () => {
            for (let url = queue.shift(); url; url = queue.shift()) {
                if (!await download(url, photos.has(url))) failed.value++
                progress.value = ++done / total
            }
        }

        await Promise.all(Array.from({length: CONCURRENCY}, worker))
        progress.value = null

        if (!failed.value) {
            writeSaved({...readSaved(), [current.id]: new Date().toISOString()})
            refresh()
        }
    }

    return {failed, isSaving, progress, refresh, save, savedAt}
}
