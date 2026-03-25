<template>
    <div id="map" class="h-full w-full"/>
</template>

<script setup lang="ts">
import {onMounted} from 'vue'
import 'leaflet/dist/leaflet.css'
import {useSupabase} from "~/composables/useSupabase";

const {getSectorsWithDetails} = useSupabase()
const config = useRuntimeConfig()

onMounted(async () => {
    const L = await import('leaflet')

    const map = L.map('map').setView([48.611123, 17.576012], 16)

    L.tileLayer(`https://api.mapy.cz/v1/maptiles/outdoor/256/{z}/{x}/{y}?apikey=${config.public.mapyApiKey}`, {
        crossOrigin: true,
        minZoom: 0,
        maxZoom: 19,
        attribution: '<a href="https://api.mapy.com/copyright" target="_blank">&copy; Seznam.cz a.s. a další</a>',
    }).addTo(map)

    try {
        const sectors = await getSectorsWithDetails()
        sectors.forEach((sector: any) => {
            if (sector.lat && sector.lon) {
                L.marker([sector.lat, sector.lon])
                    .addTo(map)
                    .bindPopup(`<b>${sector.name}</b>`)
            }
        })
    } catch (e) {
        console.error('Error loading sectors:', e)
    }
})
</script>

<style scoped>
#map {
    height: 100vh;
    width: 100%;
}
</style>
