<template>
    <div
        id="map"
        ref="mapElement"
    />
</template>

<script
    setup
    lang="ts"
>
import {onBeforeUnmount, onMounted, useTemplateRef, watch} from 'vue'
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

let map: L.Map | undefined
const markers = L.layerGroup()

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
    renderPoints()
})

watch(() => points, renderPoints)

onBeforeUnmount(() => map?.remove())
</script>
