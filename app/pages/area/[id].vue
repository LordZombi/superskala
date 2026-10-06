<template>
    <div class="relative h-full">
        <div class="absolute inset-0 flex flex-col lg:flex-row">
            <MapView
                class="z-0 min-h-0 flex-1"
                :points="sectorPoints"
                :focus="mapFocus"
                :focus-inset="isMobile && selectedClimbId ? windowHeight * 0.7 : 0"
                permanent-labels
                fit-to-points
                @select="selectSector"
            />

            <section
                ref="panel"
                class="min-h-0 overflow-y-auto overscroll-contain bg-white p-4 space-y-4 transition-[height] duration-300 ease-out lg:flex-none lg:w-[30vw] lg:min-w-120"
                :class="[isMinimized ? 'max-lg:h-20 max-lg:overflow-hidden' : 'max-lg:h-[65%]', {'max-lg:hidden': selectedClimbId}]"
                aria-labelledby="area-title"
            >
                <template v-if="area">
                    <div class="space-y-1">
                        <div class="flex justify-between items-start gap-2">
                            <h1
                                id="area-title"
                                class="text-2xl font-bold leading-none"
                                v-text="area.name"
                            ></h1>
                            <div class="flex shrink-0 gap-2">
                                <UButton
                                    :icon="offlineIcon"
                                    :label="isSaving ? `${Math.round(progress! * 100)} %` : undefined"
                                    :loading="isSaving"
                                    color="neutral"
                                    variant="soft"
                                    class="rounded-full shrink-0 w-auto"
                                    :aria-label="offlineLabel"
                                    :title="offlineLabel"
                                    @click="saveOffline"
                                />
                                <SShareButton
                                    :title="area.name"
                                    :path="route.path"
                                />
                                <UButton
                                    to="/"
                                    icon="i-heroicons-x-mark"
                                    color="neutral"
                                    variant="soft"
                                    class="rounded-full shrink-0 w-auto"
                                    aria-label="Zavrieť oblasť a späť na mapu"
                                />
                            </div>
                        </div>
                        <p class="text-slate-600 font-bold uppercase text-[10px]">
                            {{ plural(sectors.length, ['sektor', 'sektory', 'sektorov']) }} •
                            {{ plural(climbCount, ['cesta', 'cesty', 'ciest']) }}
                        </p>
                        <p
                            v-if="area.description"
                            :class="['text-slate-600 text-sm leading-relaxed', minimizedHidden]"
                        >
                            {{ area.description }}
                        </p>
                    </div>

                    <SDivider :class="minimizedHidden"/>

                    <UAccordion
                        v-model="openSectors"
                        :class="minimizedHidden"
                        type="multiple"
                        :items="sectors"
                    >
                        <template #default="{ item }">
                            <span
                                :id="`sector-${item.id}`"
                                class="block font-bold"
                            >{{ item.label }}</span>
                            <span class="block text-xs font-normal text-slate-600">
                                {{ plural(item.climbCount, ['cesta', 'cesty', 'ciest']) }}
                                <template v-if="item.gradeRange"> • {{ item.gradeRange }}</template>
                            </span>
                        </template>

                        <template #body="{ item }">
                            <div class="space-y-4">
                                <p
                                    v-if="item.description"
                                    class="text-slate-600 text-sm leading-relaxed"
                                >
                                    {{ item.description }}
                                </p>

                                <div
                                    v-for="boulder in item.boulders"
                                    :key="boulder.id"
                                    class="space-y-2"
                                >
                                    <div class="flex items-center gap-3">
                                        <img
                                            v-if="boulder.image_url"
                                            alt=""
                                            :src="boulder.image_url"
                                            loading="lazy"
                                            class="size-12 shrink-0 rounded-lg object-cover"
                                        />
                                        <h2
                                            class="text-xs font-black uppercase text-slate-600"
                                            v-text="boulder.name"
                                        ></h2>
                                        <UButton
                                            v-if="isDev"
                                            :to="{ path: '/admin/editor', query: { area: area.id, sector: item.id, boulder: boulder.id } }"
                                            icon="i-heroicons-pencil"
                                            label="Upraviť"
                                            color="neutral"
                                            variant="ghost"
                                            size="xs"
                                            class="w-auto"
                                            :aria-label="`Upraviť kameň ${boulder.name}`"
                                        />
                                    </div>

                                    <UFieldGroup orientation="vertical">
                                        <UButton
                                            v-for="climb in boulder.climbs"
                                            :key="climb.id"
                                            :variant="climb.id === selectedClimbId ? 'subtle' : 'outline'"
                                            color="neutral"
                                            block
                                            class="justify-between px-3 py-2.5"
                                            @click="selectedClimbId = climb.id"
                                        >
                                            <span :class="[climb.id === selectedClimbId ? 'font-bold' : 'font-medium']">
                                                <template v-if="climb.topo_number">{{ climb.topo_number }}. </template>{{ climb.name }}
                                            </span>
                                            <span class="text-[10px] font-mono">
                                                {{ climb.grade?.font || (climb.is_project ? 'projekt' : '?') }}
                                            </span>
                                        </UButton>
                                    </UFieldGroup>
                                </div>
                            </div>
                        </template>
                    </UAccordion>
                </template>

                <p
                    v-else-if="notFound"
                    class="text-slate-600"
                >
                    {{ isOffline ? 'Si offline a táto oblasť nie je uložená v telefóne.' : 'Oblasť sa nenašla.' }}
                    <ULink to="/">Späť na mapu</ULink>
                </p>

                <div
                    v-else
                    role="status"
                    class="flex items-center justify-center h-32"
                >
                    <UIcon
                        name="i-heroicons-arrow-path"
                        class="animate-spin w-8 h-8 text-slate-300"
                    />
                    <span class="sr-only">Načítavam…</span>
                </div>
            </section>
        </div>

        <ClimbDetailSheet
            :climbs="selectedBoulder?.climbs"
            :boulder="selectedBoulder"
            :sector="selectedSector"
            :area="area"
            :prev-id="siblingClimbId(-1)"
            :next-id="siblingClimbId(1)"
            @select-sector="selectSector"
        />
    </div>
</template>

<script
    setup
    lang="ts"
>
import {computed, onBeforeUnmount, onMounted, ref, useTemplateRef, watch} from 'vue'
import {useMediaQuery, useOnline, useWindowSize} from '@vueuse/core'
import ClimbDetailSheet from '~/components/ClimbDetailSheet.vue'
import MapView, {type MapFocus, type MapPoint} from '~/components/MapView.vue'
import SDivider from '~/components/super/SDivider.vue'
import SShareButton from '~/components/super/SShareButton.vue'
import {useOfflineArea} from '~/composables/useOfflineArea'
import {useSheetSwipe} from '~/composables/useSheetSwipe'
import {useSupabase} from '~/composables/useSupabase'

definePageMeta({
    layout: 'map'
})

// Úpravy sa dajú ukladať len lokálne, rovnako ako v editore
const isDev = import.meta.dev
const route = useRoute()
const {getAreaWithDetails} = useSupabase()
const selectedClimbId = useState<string | null>('selectedClimbId')

// Vybraná cesta žije aj v URL (?climb=), aby sa dal zdieľať odkaz priamo na ňu
selectedClimbId.value = typeof route.query.climb === 'string' ? route.query.climb : null

const stopQuerySync = watch(selectedClimbId, climb =>
    navigateTo({query: {...route.query, climb: climb ?? undefined}}, {replace: true}))

// Opačný smer: odkaz z hľadania na inú cestu v tej istej oblasti stránku neprekreslí
watch(() => route.query.climb, climb => selectedClimbId.value = typeof climb === 'string' ? climb : null)

const area = ref<Awaited<ReturnType<typeof getAreaWithDetails>>>(null)
const notFound = ref(false)
const openSectors = ref<string[]>([])

// Panel je zároveň scroller, preto ten istý element dvakrát
const panel = useTemplateRef('panel')
const {isMinimized} = useSheetSwipe(panel, panel)
// Zmenšený panel (len mobil) ukazuje iba názov oblasti; invisible obsah vyradí z fokusu a výšku nechá panelu na animáciu
const minimizedHidden = computed(() => ({'max-lg:invisible': isMinimized.value}))

const collator = new Intl.Collator('sk', {numeric: true})
const pluralRules = new Intl.PluralRules('sk')

// Slovenské skloňovanie: 1 cesta, 2 cesty, 5 ciest
const plural = (count: number, [one, few, many]: [string, string, string]) =>
    `${count} ${{one, few}[pluralRules.select(count) as 'one' | 'few'] ?? many}`

const sectors = computed(() => (area.value?.sectors ?? [])
    .map((sector) => {
        const boulders = sector.boulders
            .map(boulder => ({
                ...boulder,
                // Poradie ako v tope (číslo na fotke); varianty bez čísla idú na koniec podľa obtiažnosti
                climbs: boulder.climbs.toSorted((a, b) =>
                    Number(a.topo_number === null) - Number(b.topo_number === null)
                    || collator.compare(a.topo_number ?? '', b.topo_number ?? '')
                    || (a.grade?.value ?? Infinity) - (b.grade?.value ?? Infinity)
                    || collator.compare(a.name, b.name)),
            }))
            .sort((a, b) => collator.compare(a.name, b.name))

        const grades = boulders
            .flatMap(boulder => boulder.climbs.flatMap(climb => climb.grade ?? []))
            .sort((a, b) => a.value - b.value)
        const [easiest, hardest] = [grades.at(0), grades.at(-1)]

        return {
            ...sector,
            label: sector.name,
            value: sector.id,
            boulders,
            climbCount: boulders.reduce((sum, boulder) => sum + boulder.climbs.length, 0),
            gradeRange: easiest && hardest && [...new Set([easiest.font, hardest.font])].join(' – '),
        }
    })
    .sort((a, b) => collator.compare(a.name, b.name)))

const climbCount = computed(() => sectors.value.reduce((sum, sector) => sum + sector.climbCount, 0))

// Kamene v poradí zoznamu naprieč sektormi
const boulders = computed(() => sectors.value.flatMap(sector =>
    sector.boulders.filter(boulder => boulder.climbs.length)))

const boulderIndex = computed(() => boulders.value.findIndex(boulder =>
    boulder.climbs.some(climb => climb.id === selectedClimbId.value)))

// Detail cesty berie dáta z tohto stromu, nie zo siete – vďaka tomu funguje aj bez signálu
const selectedBoulder = computed(() => boulders.value[boulderIndex.value] ?? null)
const selectedSector = computed(() => sectors.value.find(({boulders}) =>
    selectedBoulder.value && boulders.includes(selectedBoulder.value)) ?? null)

const online = useOnline()
const isOffline = computed(() => !online.value)
const toast = useToast()
const {failed, isSaving, progress, refresh: refreshOffline, save, savedAt} = useOfflineArea(area)

const offlineIcon = computed(() => savedAt.value ? 'i-heroicons-check-circle' : 'i-heroicons-arrow-down-tray')
const offlineLabel = computed(() => savedAt.value
    ? `Uložené offline ${new Date(savedAt.value).toLocaleDateString('sk')} – kliknutím aktualizuješ`
    : 'Uložiť oblasť offline (fotky aj mapu)')

const saveOffline = async () => {
    if (isOffline.value) {
        toast.add({title: 'Si offline', description: 'Oblasť sa dá uložiť, len keď máš signál.', color: 'warning'})
        return
    }

    await save()

    toast.add(failed.value
        ? {title: 'Oblasť sa neuložila celá', description: `${failed.value} súborov sa nepodarilo stiahnuť, skús to znova.`, color: 'error'}
        : {title: 'Oblasť je uložená offline', description: 'Cesty, fotky aj mapa budú dostupné bez signálu.', color: 'success'})
}

// Listovanie v detaile ide cestu po ceste; po poslednej na kameni pokračuje ďalším kameňom
const climbIds = computed(() => boulders.value.flatMap(boulder => boulder.climbs.map(({id}) => id)))

const siblingClimbId = (offset: number) => {
    const index = climbIds.value.indexOf(selectedClimbId.value ?? '')

    return index < 0 ? null : climbIds.value[index + offset] ?? null
}

// Sektor vybraný z mapy, detailu alebo hľadania; výber cesty ho zruší, aby sa po jej zavretí mapa vrátila na oblasť
const focusedSectorId = ref<string | null>(null)

watch(selectedClimbId, (climb) => {
    if (climb) focusedSectorId.value = null
})

// Vybraný kameň sa na mape priblíži; kým nemá vlastné súradnice, poslúži jeho sektor
const mapFocus = computed<MapFocus | null>(() => {
    const boulder = boulders.value[boulderIndex.value]
    if (boulder?.lat && boulder.lon) return {lat: boulder.lat, lon: boulder.lon, zoom: 18}

    const sector = sectors.value.find(({id, boulders}) =>
        boulder ? boulders.includes(boulder) : id === focusedSectorId.value)

    return sector?.lat && sector.lon ? {lat: sector.lat, lon: sector.lon, zoom: 17} : null
})

// Na mobile (pod lg) detail cesty prekrýva spodných 70vh mapy, viď h-[70vh] v ClimbDetailSheet
const isMobile = useMediaQuery('(max-width: 1023px)')
const {height: windowHeight} = useWindowSize()

const selectSector = async (id: string) => {
    openSectors.value = [id]
    isMinimized.value = false
    // Detail cesty prekrýva zoznam sektorov, bez zavretia by výber nebolo vidno
    selectedClimbId.value = null
    focusedSectorId.value = id

    // Až po zbalení ostatných sektorov (animácia akordeónu trvá 200 ms), inak hlavička po posune ujde z obrazovky
    await new Promise(resolve => setTimeout(resolve, 250))
    document.getElementById(`sector-${id}`)?.closest('button')?.scrollIntoView()
}

// ?sector= z hľadania sektor otvorí a z URL zmizne, aby ten istý odkaz fungoval aj nabudúce
const openSectorFromQuery = async () => {
    const {sector, ...query} = route.query
    if (typeof sector !== 'string') return

    await navigateTo({query}, {replace: true})
    selectSector(sector)
}

watch(() => route.query.sector, openSectorFromQuery)

const sectorPoints = computed<MapPoint[]>(() => sectors.value.flatMap(({id, lat, lon, name}) =>
    lat && lon ? [{id, lat, lon, label: name}] : []))

// Rovnaký formát posiela aj server pre náhľady odkazov (server/plugins/share-meta.ts)
useHead({
    title: () => {
        const climb = boulders.value[boulderIndex.value]?.climbs.find(({id}) => id === selectedClimbId.value)

        return ['Superskaly', area.value?.name, climb && [climb.topo_number && `${climb.topo_number}.`, climb.name]
            .filter(Boolean).join(' ')].filter(Boolean).join(' | ')
    },
})

onMounted(async () => {
    area.value = await getAreaWithDetails(String(route.params.id))
    notFound.value = !area.value
    refreshOffline()

    // Oblasť s jediným sektorom rovno rozbalíme
    if (sectors.value.length === 1) openSectors.value = [sectors.value[0]!.id]

    openSectorFromQuery()
})

onBeforeUnmount(() => {
    // Pri odchode zo stránky už URL neprepisujeme
    stopQuerySync()
    selectedClimbId.value = null
})
</script>
