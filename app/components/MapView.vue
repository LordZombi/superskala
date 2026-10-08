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

export interface MapPoint {
    id: string
    lat: number
    lon: number
    label: string
}

const {points, permanentLabels = false, fitToPoints = false, focus = null, focusInset = 0, selected = null} = defineProps<{
    points: MapPoint[]
    permanentLabels?: boolean
    fitToPoints?: boolean
    /** Miesto, na ktoré sa mapa priblíži; bez neho sa vráti na všetky body */
    focus?: MapFocus | null
    /** Koľko px mapy zospodu prekrýva panel – focus sa centruje do zvyšku */
    focusInset?: number
    /** Vybraný kameň: zvýraznený bod s menovkou, len na pohľad (výber robí panel) */
    selected?: MapPoint | null
}>()

const emit = defineEmits<{
    select: [id: string]
}>()

/** Špendlík na úpravu GPS (editor): klik do mapy ho položí, dá sa ťahať. undefined = vypnutý, null = zatiaľ bez polohy */
const pin = defineModel<Pick<MapFocus, 'lat' | 'lon'> | null>('pin')

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

// L.marker (na rozdiel od circleMarker) je fokusovateľný z klávesnice
const icon = L.divIcon({
    className: '',
    html: '<span class="block size-4 rounded-full bg-emerald-500 ring-2 ring-white"></span>',
    iconSize: [16, 16],
})

const renderPoints = () => {
    if (!map) return

    markers.clearLayers()

    points.forEach((point) => {
        const marker = L.marker([point.lat, point.lon], {icon}).addTo(markers)

        marker.getElement()?.setAttribute('aria-label', point.label)
        marker.on('click', () => emit('select', point.id))
        // Leaflet sám Enter/medzerník na markeri neobsluhuje
        marker.on('keydown', ({originalEvent}) => {
            if (originalEvent.key !== 'Enter' && originalEvent.key !== ' ') return

            originalEvent.preventDefault()
            emit('select', point.id)
        })
        marker.bindTooltip(point.label, {
            // Trvalé menovky idú vedľa bodu, aby sa blízke sektory neprekrývali
            direction: permanentLabels ? 'right' : 'top',
            offset: permanentLabels ? [8, 0] : [0, -8],
            permanent: permanentLabels,
        })
    })

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

let selectedMarker: L.Marker | undefined
const selectedIcon = L.divIcon({
    className: '',
    html: '<span class="block size-3 rounded-full bg-orange-500 ring-2 ring-white"></span>',
    iconSize: [12, 12],
})

const renderSelected = () => {
    selectedMarker?.remove()
    selectedMarker = undefined
    if (!map || !selected) return

    // Bez fokusu z klávesnice a bez kliku: kameň sa vyberá v paneli, bod ho len ukazuje na mape.
    // Kameň je menší ako bod sektora a jeho menovka je vľavo (menovka sektora je vpravo), aby sa blízke body neprekrývali
    selectedMarker = L.marker([selected.lat, selected.lon], {icon: selectedIcon, keyboard: false, interactive: false, zIndexOffset: 500})
        .bindTooltip(selected.label, {permanent: true, direction: 'left', offset: [-10, 0]})
        .addTo(map)
}

const reducedMotion = usePreferredReducedMotion()

// 'post': výber cesty zároveň mení veľkosť mapy, rátať treba až s novou
const applyFocus = () => {
    if (!map) return

    map.invalidateSize({pan: false})
    if (!focus) return fitPoints()

    map.flyToBounds(L.latLng(focus.lat, focus.lon).toBounds(1), {
        paddingBottomRight: [0, focusInset],
        maxZoom: focus.zoom,
        animate: reducedMotion.value !== 'reduce',
    })
}

watch(() => focus, applyFocus, {flush: 'post'})

onMounted(() => {
    if (!mapElement.value) return

    map = L.map(mapElement.value, {
        minZoom: 5,
        maxZoom: 18,
        zoomControl: false,
    }).setView([48.611123, 17.576012], 6)

    L.tileLayer(mapTileUrl(config.public.mapyApiKey), {
        attribution: '&copy; Seznam.cz a.s.',
        // CORS odpoveď (200) service worker uloží; nepriehľadnú (no-cors) by do cache nedal
        crossOrigin: true,
    }).addTo(map)

    markers.addTo(map)
    positionLayer.addTo(map)
    map.on('locationfound', onLocationFound)
    map.on('locationerror', onLocationError)
    map.on('click', ({latlng}) => {
        if (pin.value !== undefined) setPin(latlng)
    })
    renderPoints()
    renderPin()
    renderSelected()
    // Mapa v editore vzniká až s už nastaveným focusom, watch by ho nezachytil
    if (focus) applyFocus()
})

watch(() => points, renderPoints)
watch(pin, renderPin)
watch(() => selected, renderSelected)

// Mapa mení veľkosť pri zmenšení panela oblasti, Leaflet si to sám nevšimne.
// Bez posunu, aby výrez ostal ukotvený hore a neskryl sa za spodný panel
useResizeObserver(mapElement, () => map?.invalidateSize({pan: false}))

onBeforeUnmount(() => map?.stopLocate().remove())
</script>
