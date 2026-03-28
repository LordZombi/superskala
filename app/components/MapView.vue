<template>
    <div
        id="map"
        ref="mapElement"
        class="h-full w-full"
    />
</template>

<script
    setup
    lang="ts"
>
import {onMounted, ref} from 'vue'
import 'leaflet/dist/leaflet.css'
import L from 'leaflet'
import {useSupabase} from '~/composables/useSupabase'

const selectedClimbId = useState<string | null>('selectedClimbId')
const mapElement = ref<HTMLElement | null>(null)
const {getClimbsForMap} = useSupabase()
const config = useRuntimeConfig()

onMounted(async () => {
    if (!mapElement.value) return

    const slovakiaBounds = L.latLngBounds(
        [47.7, 16.8],
        [49.6, 22.6]
    )

    const map = L.map(mapElement.value, {
        maxBounds: slovakiaBounds,
        maxBoundsViscosity: 1.0,
        minZoom: 8,
        maxZoom: 18,
        zoomControl: false,
    }).setView([48.611123, 17.576012], 16)

    L.tileLayer(`https://api.mapy.cz/v1/maptiles/outdoor/256/{z}/{x}/{y}?apikey=${config.public.mapyApiKey}`, {
        attribution: '&copy; Seznam.cz a.s.',
        bounds: slovakiaBounds,
    }).addTo(map)

    const climbs = await getClimbsForMap()

    climbs.forEach((climb: any) => {
        const lat = climb.lat
        const lon = climb.lon

        if (lat && lon) {
            const circle = L.circleMarker([lat, lon], {
                radius: 8,
                color: "white",
                weight: 2,
                opacity: 1,
                fillOpacity: 1,
                className: 'fill-emerald-500 focus:outline-none focus:stroke-emerald-500'
            }).addTo(map)

            circle.on('click', () => {
                selectedClimbId.value = climb.id
            })

            circle.bindTooltip(climb.name, {
                direction: 'top',
                offset: [0, -5]
            })
        }
    })
})
</script>
