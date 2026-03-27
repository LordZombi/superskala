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

    // Mapa centrovaná na Chtelnicu
    const map = L.map(mapElement.value).setView([48.611123, 17.576012], 19)

    L.tileLayer(`https://api.mapy.cz/v1/maptiles/outdoor/256/{z}/{x}/{y}?apikey=${config.public.mapyApiKey}`, {
        attribution: '&copy; Seznam.cz a.s.',
    }).addTo(map)

    const climbs = await getClimbsForMap()

    climbs.forEach((climb: any) => {
        console.log(climbs)
        // Použijeme lat/lon priamo z cesty (climb)
        const lat = climb.lat
        const lon = climb.lon

        if (lat && lon) {
            // Vytvoríme kruhový marker
            const circle = L.circleMarker([lat, lon], {
                radius: 8,           // Veľkosť kruhu
                fillColor: "#10b981", // Emerald-500
                color: "white",       // Okraj
                weight: 2,           // Hrúbka okraja
                opacity: 1,
                fillOpacity: 0.8
            }).addTo(map)

            // Klik na kruh otvorí sheet
            circle.on('click', () => {
                selectedClimbId.value = climb.id
            })

            // Tooltip na hover
            circle.bindTooltip(climb.name, {
                direction: 'top',
                offset: [0, -5]
            })
        }
    })
})
</script>

<style>
@reference "tailwindcss";

#map {

    path {

        &:focus,
        &:focus-visible {
            @apply stroke-emerald-500
        }
    }
}
</style>
