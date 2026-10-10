<template>
    <UDropdownMenu :items="items">
        <UButton
            icon="i-heroicons-map-pin"
            color="neutral"
            variant="soft"
            class="rounded-full shrink-0 w-auto"
            :aria-label="`Navigovať: ${title}`"
        />
    </UDropdownMenu>
</template>

<script
    setup
    lang="ts"
>
import {computed} from 'vue'

const {title, lat, lon} = defineProps<{
    title: string
    lat: number
    lon: number
}>()

// Odkazy sa na mobile otvoria priamo v nainštalovanej apke danej služby
const items = computed(() => [[
    {label: 'Google Maps', icon: 'i-simple-icons-googlemaps', to: `https://www.google.com/maps/dir/?api=1&destination=${lat},${lon}`},
    {label: 'Waze', icon: 'i-simple-icons-waze', to: `https://waze.com/ul?ll=${lat},${lon}&navigate=yes`},
    {label: 'Mapy.cz', icon: 'i-lucide-map', to: `https://mapy.cz/fnc/v1/route?end=${lon},${lat}&routeType=car_fast`},
].map(item => ({...item, target: '_blank'}))])
</script>
