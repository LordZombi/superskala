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

export interface MapPoint {
    id: string
    lat: number
    lon: number
    label: string
}

const {points, permanentLabels = false, fitToPoints = false} = defineProps<{
    points: MapPoint[]
    permanentLabels?: boolean
    fitToPoints?: boolean
}>()

const emit = defineEmits<{
    select: [id: string]
}>()

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

    if (fitToPoints && points.length) {
        map.fitBounds(L.latLngBounds(points.map(point => [point.lat, point.lon])), {
            padding: [48, 48],
            maxZoom: 16,
        })
    }
}

onMounted(() => {
    if (!mapElement.value) return

    map = L.map(mapElement.value, {
        minZoom: 5,
        maxZoom: 18,
        zoomControl: false,
    }).setView([48.611123, 17.576012], 6)

    L.tileLayer(`https://api.mapy.cz/v1/maptiles/outdoor/256/{z}/{x}/{y}?apikey=${config.public.mapyApiKey}`, {
        attribution: '&copy; Seznam.cz a.s.',
    }).addTo(map)

    markers.addTo(map)
    positionLayer.addTo(map)
    map.on('locationfound', onLocationFound)
    map.on('locationerror', onLocationError)
    renderPoints()
})

watch(() => points, renderPoints)

onBeforeUnmount(() => map?.stopLocate().remove())
</script>
