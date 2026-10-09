<template>
    <div class="relative h-full">
        <MapView
            class="absolute inset-0 z-0"
            :points="points"
            permanent-labels
            keep-view
            @select="id => navigateTo(routes.get(id))"
        />
    </div>
</template>

<script
    setup
    lang="ts"
>
import {onMounted, ref} from 'vue'
import MapView, {type MapPoint, type Outline} from '~/components/MapView.vue'
import {useSupabase} from '~/composables/useSupabase'

definePageMeta({
    layout: 'map'
})

const {getAreasForMap} = useSupabase()
const points = ref<MapPoint[]>([])
// Od tohto priblíženia sa oblasť nahradí svojimi sektormi (ak ich má na mape)
const AREA_MAX_ZOOM = 15
// Kam vedie bod: oblasť na svoju stránku, sektor do svojej oblasti
const routes = new Map<string, string>()

onMounted(async () => {
    const areas = await getAreasForMap()

    // Oblasť bez vlastných súradníc sa zobrazí na mieste prvého sektoru so súradnicami
    points.value = areas.flatMap((area) => {
        const sectors = area.sectors.filter(sector => sector.lat && sector.lon)
        const {lat, lon} = area.lat && area.lon ? area : sectors[0] ?? {}

        routes.set(area.id, `/area/${area.id}`)
        sectors.forEach(sector => routes.set(sector.id, `/area/${area.id}?sector=${sector.id}`))

        return [
            ...lat && lon ? [{
                id: area.id, lat, lon, label: area.name,
                outline: (area.outline ?? undefined) as Outline | undefined,
                maxZoom: sectors.length ? AREA_MAX_ZOOM : undefined,
            }] : [],
            ...sectors.map(sector => ({
                id: sector.id, lat: sector.lat!, lon: sector.lon!, label: sector.name,
                outline: (sector.outline ?? undefined) as Outline | undefined,
                minZoom: AREA_MAX_ZOOM + 1,
            })),
        ]
    })
})
</script>
