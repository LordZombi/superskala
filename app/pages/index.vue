<template>
    <div class="relative h-full">
        <MapView
            class="absolute inset-0 z-0"
            :points="points"
            permanent-labels
            @select="id => navigateTo(`/area/${id}`)"
        />
    </div>
</template>

<script
    setup
    lang="ts"
>
import {onMounted, ref} from 'vue'
import MapView, {type MapPoint} from '~/components/MapView.vue'
import {useSupabase} from '~/composables/useSupabase'

definePageMeta({
    layout: 'map'
})

const {getAreasForMap} = useSupabase()
const points = ref<MapPoint[]>([])

onMounted(async () => {
    const areas = await getAreasForMap()

    // Oblasť bez vlastných súradníc sa zobrazí na mieste prvého sektoru so súradnicami
    points.value = areas.flatMap((area) => {
        const {lat, lon} = area.lat && area.lon ? area : area.sectors.find(sector => sector.lat && sector.lon) ?? {}

        return lat && lon ? [{id: area.id, lat, lon, label: area.name}] : []
    })
})
</script>
