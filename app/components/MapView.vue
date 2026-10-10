<template>
    <!-- Mapa aj tlačidlo sú v tej istej bunke gridu, takže koreň nepotrebuje vlastný position -->
    <div class="grid">
        <div
            id="map"
            ref="mapElement"
            class="z-0 col-start-1 row-start-1 min-h-0"
        />

        <UButton
            icon="i-heroicons-viewfinder-circle"
            color="neutral"
            variant="outline"
            size="lg"
            class="z-10 col-start-1 row-start-1 self-end justify-self-end m-4 mb-8 w-auto rounded-full shadow-md"
            aria-label="Zobraziť moju polohu"
            :loading="isLocating"
            @click="locate"
        />
    </div>
</template>

<script
    setup
    lang="ts"
>
import {onBeforeUnmount, onMounted, ref, useTemplateRef, watch} from 'vue'
import 'leaflet/dist/leaflet.css'
import L from 'leaflet'
import {usePreferredReducedMotion, useResizeObserver} from '@vueuse/core'
import {mapTileUrl} from '~/composables/useOfflineArea'

export interface MapFocus {
    lat: number
    lon: number
    zoom: number
}

/** Body obrysu [lat, lon] po obvode, aspoň 3 */
export type Outline = [number, number][]

export interface MapPoint {
    id: string
    lat: number
    lon: number
    label: string
    /** Úroveň bodu určuje veľkosť: sektor > kameň > cesta; bez nej je to sektor */
    kind?: 'sector' | 'boulder' | 'climb'
    /** Poloha je len odhad (rozloženie okolo nadradeného bodu), nie GPS: bod sa vykreslí ako prázdny */
    approx?: boolean
    /** Obrys sa vykreslí ako plocha okolo bodu */
    outline?: Outline
    /** Bod je viditeľný len v tomto rozsahu priblíženia (vrátane) */
    minZoom?: number
    maxZoom?: number
}

const {points, permanentLabels = false, fitToPoints = false, keepView = false, deepZoom = false, drawing = false, focus = null, focusInset = 0, selected = null} = defineProps<{
    points: MapPoint[]
    permanentLabels?: boolean
    fitToPoints?: boolean
    /** Mapa sa otvorí tam, kde skončila predchádzajúca (napr. po zavretí oblasti), namiesto celého Slovenska */
    keepView?: boolean
    /** Priblíženie až na zoom 20; od zoomu 19 sa dlaždice schovajú a ostane len zelená plocha (ako v Boolderi) */
    deepZoom?: boolean
    /** Editor: klik do mapy pridá bod obrysu (namiesto posunu špendlíka), body sa dajú ťahať */
    drawing?: boolean
    /** Miesto, na ktoré sa mapa priblíži; bez neho sa vráti na všetky body */
    focus?: MapFocus | null
    /** Koľko px mapy zospodu prekrýva panel – focus sa centruje do zvyšku */
    focusInset?: number
    /** Vybraný kameň: zvýraznený bod s menovkou, len na pohľad (výber robí panel) */
    selected?: MapPoint | null
}>()

const emit = defineEmits<{
    select: [id: string]
    /** Aktuálne priblíženie mapy (po každej zmene) */
    zoom: [level: number]
}>()

// Dlaždice mapy.cz sú len do zoomu 18, ďalej by sa len zväčšovali do rozmazanej plochy
const TILE_MAX_ZOOM = 18
const DEEP_MAX_ZOOM = 20

/** Špendlík na úpravu GPS (editor): klik do mapy ho položí, dá sa ťahať. undefined = vypnutý, null = zatiaľ bez polohy */
const pin = defineModel<Pick<MapFocus, 'lat' | 'lon'> | null>('pin')
/** Obrys upravovaný v editore (zapína ho `drawing`) */
const outline = defineModel<Outline | null>('outline')

// Posledný výrez mapy ostáva medzi stránkami; ukladá ho každá mapa, načíta si ho len tá s keepView
const lastView = useState<{center: L.LatLngTuple, zoom: number} | null>('mapView', () => null)

const mapElement = useTemplateRef('mapElement')
const config = useRuntimeConfig()
const toast = useToast()

let map: L.Map | undefined
const markers = L.layerGroup()

// Poloha používateľa: sleduje sa až po prvom kliknutí na tlačidlo
const positionLayer = L.layerGroup()
const isLocating = ref(false)
let position: L.LatLng | undefined
let centerOnNextFix = false

const centerOn = (latlng: L.LatLng) => map?.flyTo(latlng, Math.max(map.getZoom(), 16))

const locate = () => {
    if (!map) return
    if (position) {
        centerOn(position)
        return
    }

    centerOnNextFix = true
    isLocating.value = true
    map.locate({watch: true, enableHighAccuracy: true})
}

const onLocationFound = ({latlng, accuracy}: L.LocationEvent) => {
    position = latlng
    isLocating.value = false

    positionLayer.clearLayers()
    L.circle(latlng, {radius: accuracy, color: '#3b82f6', weight: 1, fillOpacity: 0.15, interactive: false})
        .addTo(positionLayer)
    L.circleMarker(latlng, {radius: 7, color: '#fff', weight: 2, fillColor: '#3b82f6', fillOpacity: 1, interactive: false})
        .addTo(positionLayer)

    if (centerOnNextFix) {
        centerOnNextFix = false
        centerOn(latlng)
    }
}

const onLocationError = ({code}: L.ErrorEvent) => {
    // Ak už polohu máme, jednorazový výpadok signálu ignorujeme
    if (position) return

    isLocating.value = false
    map?.stopLocate()
    toast.add({
        title: 'Polohu sa nepodarilo zistiť',
        // 1 = PERMISSION_DENIED
        description: code === 1 ? 'Povoľ prístup k polohe v nastaveniach prehliadača.' : 'Skús to znova o chvíľu.',
        color: 'error',
    })
}

// L.marker (na rozdiel od circleMarker) je fokusovateľný z klávesnice.
// Kameň a cesta sú menšie ako sektor, no klikacia plocha ostáva 24 px (WCAG 2.5.8)
const icons = {
    sector: L.divIcon({
        className: '',
        html: '<span class="block size-4 rounded-full bg-emerald-500 ring-2 ring-white"></span>',
        iconSize: [16, 16],
    }),
    boulder: L.divIcon({
        className: '',
        html: '<span class="flex size-6 items-center justify-center"><span class="block size-3 rounded-full bg-emerald-500 ring-2 ring-white"></span></span>',
        iconSize: [24, 24],
    }),
    climb: L.divIcon({
        className: '',
        html: '<span class="flex size-6 items-center justify-center"><span class="block size-2 rounded-full bg-emerald-500 ring-1 ring-white"></span></span>',
        iconSize: [24, 24],
    }),
}
const approxIcons = {
    sector: icons.sector,
    boulder: L.divIcon({
        className: '',
        html: '<span class="flex size-6 items-center justify-center"><span class="block size-3 rounded-full bg-white/70 ring-2 ring-emerald-500"></span></span>',
        iconSize: [24, 24],
    }),
    climb: L.divIcon({
        className: '',
        html: '<span class="flex size-6 items-center justify-center"><span class="block size-2 rounded-full bg-white/70 ring-1 ring-emerald-500"></span></span>',
        iconSize: [24, 24],
    }),
}
// Menšie body ležia nad väčšími, aby sa dali trafiť aj tesne pri sektore
const zIndexOffsets = {sector: 0, boulder: 100, climb: 200}

interface Entry {
    layers: L.Layer[]
    minZoom: number
    maxZoom: number
}
let entries: Entry[] = []

const shapeStyle: L.PolylineOptions = {color: '#059669', weight: 2, fillColor: '#10b981', fillOpacity: 0.2}

// Úroveň detailu: body mimo svojho rozsahu priblíženia sa z mapy dočasne vyberú
const applyVisibility = () => {
    if (!map) return

    const level = map.getZoom()

    entries.forEach(({layers, minZoom, maxZoom}) => {
        const isVisible = level >= minZoom && level <= maxZoom

        layers.forEach(layer => isVisible ? markers.addLayer(layer) : markers.removeLayer(layer))
    })
}

const renderPoints = () => {
    if (!map) return

    markers.clearLayers()

    entries = points.map((point) => {
        const kind = point.kind ?? 'sector'
        const hasShape = (point.outline?.length ?? 0) > 2
        const select = () => emit('select', point.id)
        const marker = L.marker([point.lat, point.lon], {icon: (point.approx ? approxIcons : icons)[kind], zIndexOffset: zIndexOffsets[kind]})
        // Menovky kameňov a ciest sa ukážu len pri prejdení, trvalé by zahltili mapu
        const isPermanent = permanentLabels && kind === 'sector'

        // Element vzniká až po pridaní do mapy, a to riadi viditeľnosť podľa priblíženia
        marker.on('add', () => marker.getElement()?.setAttribute('aria-label', point.label))
        marker.on('click', select)
        // Leaflet sám Enter/medzerník na markeri neobsluhuje
        marker.on('keydown', ({originalEvent}) => {
            if (originalEvent.key !== 'Enter' && originalEvent.key !== ' ') return

            originalEvent.preventDefault()
            select()
        })
        marker.bindTooltip(point.label, {
            // Trvalé menovky idú vedľa bodu, aby sa blízke sektory neprekrývali; plocha má menovku v strede
            direction: isPermanent && !hasShape ? 'right' : 'top',
            offset: isPermanent && !hasShape ? [8, 0] : [0, -8],
            permanent: isPermanent && !hasShape,
        })

        const layers: L.Layer[] = [marker]

        if (hasShape) {
            // Plocha je len pre myš a dotyk, z klávesnice ostáva dostupný bod; v editore (pin) nesmie brániť klikaniu do mapy
            layers.push(L.polygon(point.outline!, {...shapeStyle, interactive: pin.value === undefined})
                .on('click', select)
                .bindTooltip(point.label, {direction: 'center', permanent: isPermanent}))
        }

        return {layers, minZoom: point.minZoom ?? 0, maxZoom: point.maxZoom ?? Infinity}
    })

    applyVisibility()
    fitPoints()
}

const fitPoints = () => {
    if (!map || !fitToPoints || !points.length) return

    map.fitBounds(L.latLngBounds(points.map(point => [point.lat, point.lon])), {
        padding: [48, 48],
        maxZoom: 16,
    })
}

let pinMarker: L.Marker | undefined
const pinIcon = L.divIcon({
    className: '',
    html: '<span class="block size-5 rounded-full bg-red-600 ring-2 ring-white"></span>',
    iconSize: [20, 20],
})

// 6 desatinných miest je asi 10 cm, presnejšie to z mapy aj tak nejde
const setPin = ({lat, lng}: L.LatLng) => pin.value = {lat: +lat.toFixed(6), lon: +lng.toFixed(6)}

const renderPin = () => {
    if (!map) return

    if (!pin.value) {
        pinMarker?.remove()
        pinMarker = undefined
        return
    }

    const latlng: L.LatLngTuple = [pin.value.lat, pin.value.lon]
    if (pinMarker) {
        pinMarker.setLatLng(latlng)
        return
    }

    // Bez fokusu z klávesnice: ťahať sa ním nedá, súradnice sa dajú napísať do poľa v editore
    pinMarker = L.marker(latlng, {icon: pinIcon, draggable: true, keyboard: false, zIndexOffset: 1000}).addTo(map)
    pinMarker.on('dragend', () => pinMarker && setPin(pinMarker.getLatLng()))
}

const outlineLayer = L.layerGroup()
const vertexIcon = L.divIcon({
    className: '',
    html: '<span class="block size-3 rounded-full bg-red-600 ring-2 ring-white"></span>',
    iconSize: [12, 12],
})

const toVertex = ({lat, lng}: L.LatLng): [number, number] => [+lat.toFixed(6), +lng.toFixed(6)]

const renderOutline = () => {
    outlineLayer.clearLayers()

    const shape = outline.value
    if (!map || !shape?.length) return

    L.polygon(shape, {...shapeStyle, color: '#dc2626', fillColor: '#dc2626', interactive: false}).addTo(outlineLayer)
    if (!drawing) return

    shape.forEach((vertex, index) => L.marker(vertex, {icon: vertexIcon, draggable: true, keyboard: false, zIndexOffset: 900})
        .on('dragend', ({target}) => outline.value = shape.map((v, i) => i === index ? toVertex(target.getLatLng()) : v))
        .addTo(outlineLayer))
}

let selectedMarker: L.Marker | undefined
const selectedIcon = L.divIcon({
    className: '',
    html: '<span class="block size-3 rounded-full bg-orange-500 ring-2 ring-white"></span>',
    iconSize: [12, 12],
})

const selectedSectorIcon = L.divIcon({
    className: '',
    html: '<span class="block size-5 rounded-full bg-orange-500 ring-2 ring-white"></span>',
    iconSize: [20, 20],
})

const renderSelected = () => {
    selectedMarker?.remove()
    selectedMarker = undefined
    if (!map || !selected) return

    // Bez fokusu z klávesnice a bez kliku: kameň sa vyberá v paneli, bod ho len ukazuje na mape.
    // Kameň je menší ako bod sektora a jeho menovka je vľavo (menovka sektora je vpravo), aby sa blízke body neprekrývali
    const isSector = (selected.kind ?? 'sector') === 'sector'

    selectedMarker = L.marker([selected.lat, selected.lon], {icon: isSector ? selectedSectorIcon : selectedIcon, keyboard: false, interactive: false, zIndexOffset: 500})
        .addTo(map)
    // Menovku sektora už má jeho vlastný bod
    if (!isSector) selectedMarker.bindTooltip(selected.label, {permanent: true, direction: 'left', offset: [-10, 0]})
}

const reducedMotion = usePreferredReducedMotion()

// 'post': výber cesty zároveň mení veľkosť mapy, rátať treba až s novou
const applyFocus = () => {
    if (!map) return

    map.invalidateSize({pan: false})
    if (!focus) return fitPoints()

    map.flyToBounds(L.latLng(focus.lat, focus.lon).toBounds(1), {
        paddingBottomRight: [0, focusInset],
        // Zblízka sa už neodďaluje: priblíži sa najviac na focus.zoom, ale nikdy nie späť z väčšieho priblíženia
        maxZoom: Math.max(focus.zoom, map.getZoom()),
        animate: reducedMotion.value !== 'reduce',
    })
}

watch(() => focus, applyFocus, {flush: 'post'})

onMounted(() => {
    if (!mapElement.value) return

    const start = keepView && lastView.value ? lastView.value : {center: [48.611123, 17.576012] as L.LatLngTuple, zoom: 6}

    map = L.map(mapElement.value, {
        minZoom: 5,
        maxZoom: deepZoom ? DEEP_MAX_ZOOM : TILE_MAX_ZOOM,
        zoomControl: false,
    }).setView(start.center, start.zoom)
    map.on('zoomend', () => {
        const level = map!.getZoom()

        map!.getContainer().classList.toggle('is-plain', deepZoom && level > TILE_MAX_ZOOM)
        applyVisibility()
        emit('zoom', level)
    })
    map.on('moveend', () => {
        const {lat, lng} = map!.getCenter()
        lastView.value = {center: [lat, lng], zoom: map!.getZoom()}
    })

    L.tileLayer(mapTileUrl(config.public.mapyApiKey), {
        attribution: '&copy; Seznam.cz a.s.',
        maxNativeZoom: TILE_MAX_ZOOM,
        // CORS odpoveď (200) service worker uloží; nepriehľadnú (no-cors) by do cache nedal
        crossOrigin: true,
    }).addTo(map)

    emit('zoom', map.getZoom())
    markers.addTo(map)
    positionLayer.addTo(map)
    outlineLayer.addTo(map)
    map.on('locationfound', onLocationFound)
    map.on('locationerror', onLocationError)
    map.on('click', ({latlng}) => {
        if (drawing) outline.value = [...outline.value ?? [], toVertex(latlng)]
        else if (pin.value !== undefined) setPin(latlng)
    })
    renderPoints()
    renderPin()
    renderOutline()
    renderSelected()
    // Mapa v editore vzniká až s už nastaveným focusom, watch by ho nezachytil
    if (focus) applyFocus()
})

watch(() => points, renderPoints)
watch(pin, renderPin)
watch([outline, () => drawing], renderOutline)
watch(() => selected, renderSelected)

// Mapa mení veľkosť pri zmenšení panela oblasti, Leaflet si to sám nevšimne.
// Bez posunu, aby výrez ostal ukotvený hore a neskryl sa za spodný panel
useResizeObserver(mapElement, () => map?.invalidateSize({pan: false}))

onBeforeUnmount(() => map?.stopLocate().remove())
</script>
