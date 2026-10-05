<template>
    <div class="relative h-full">
        <div class="absolute inset-0 flex flex-col lg:flex-row">
            <MapView
                class="z-0 h-[35vh] shrink-0 lg:h-auto lg:flex-1"
                :class="{'max-lg:flex-1': isMinimized || selectedClimbId}"
                :points="sectorPoints"
                permanent-labels
                fit-to-points
                @select="selectSector"
            />

            <section
                ref="panel"
                class="flex-1 min-h-0 overflow-y-auto overscroll-contain bg-white p-4 space-y-4 lg:flex-none lg:w-[30vw] lg:min-w-120"
                :class="{'max-lg:flex-none': isMinimized, 'max-lg:hidden': selectedClimbId}"
                aria-labelledby="area-title"
            >
                <!-- Úchyt je zároveň tlačidlo, aby sa panel dal zmenšiť aj bez gesta -->
                <button
                    type="button"
                    class="-mt-3 mb-1 flex w-full justify-center py-2.5 lg:hidden"
                    aria-label="Panel oblasti"
                    :aria-expanded="!isMinimized"
                    @click="isMinimized = !isMinimized"
                >
                    <span class="h-1.5 w-10 rounded-full bg-neutral-500"></span>
                </button>

                <template v-if="area">
                    <div class="space-y-1">
                        <div class="flex justify-between items-start gap-2">
                            <h1
                                id="area-title"
                                class="text-2xl font-bold leading-none"
                                v-text="area.name"
                            ></h1>
                            <UButton
                                to="/"
                                icon="i-heroicons-x-mark"
                                color="neutral"
                                variant="soft"
                                class="rounded-full shrink-0 w-auto"
                                aria-label="Zavrieť oblasť a späť na mapu"
                            />
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
                    Oblasť sa nenašla.
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
import {computed, onBeforeUnmount, onMounted, ref, useTemplateRef} from 'vue'
import ClimbDetailSheet from '~/components/ClimbDetailSheet.vue'
import MapView, {type MapPoint} from '~/components/MapView.vue'
import SDivider from '~/components/super/SDivider.vue'
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

const area = ref<Awaited<ReturnType<typeof getAreaWithDetails>>>(null)
const notFound = ref(false)
const openSectors = ref<string[]>([])

// Panel je zároveň scroller, preto ten istý element dvakrát
const panel = useTemplateRef('panel')
const {isMinimized} = useSheetSwipe(panel, panel)
// Zmenšený panel (len mobil) ukazuje iba názov oblasti; skrytý obsah tak nie je ani fokusovateľný
const minimizedHidden = computed(() => ({'max-lg:hidden': isMinimized.value}))

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
                    (a.topo_number ?? Infinity) - (b.topo_number ?? Infinity)
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

// Kamene v poradí zoznamu naprieč sektormi – na listovanie v detaile cesty
const boulders = computed(() => sectors.value.flatMap(sector =>
    sector.boulders.filter(boulder => boulder.climbs.length)))

const boulderIndex = computed(() => boulders.value.findIndex(boulder =>
    boulder.climbs.some(climb => climb.id === selectedClimbId.value)))

const siblingClimbId = (offset: number) =>
    boulderIndex.value < 0 ? null : boulders.value[boulderIndex.value + offset]?.climbs[0]?.id ?? null

const selectSector = async (id: string) => {
    openSectors.value = [id]
    isMinimized.value = false
    // Detail cesty prekrýva zoznam sektorov, bez zavretia by výber nebolo vidno
    selectedClimbId.value = null

    // Až po zbalení ostatných sektorov (animácia akordeónu trvá 200 ms), inak hlavička po posune ujde z obrazovky
    await new Promise(resolve => setTimeout(resolve, 250))
    document.getElementById(`sector-${id}`)?.closest('button')?.scrollIntoView()
}

const sectorPoints = computed<MapPoint[]>(() => sectors.value.flatMap(({id, lat, lon, name}) =>
    lat && lon ? [{id, lat, lon, label: name}] : []))

useHead({
    title: () => area.value ? `${area.value.name} – Superskaly` : 'Superskaly',
})

onMounted(async () => {
    area.value = await getAreaWithDetails(String(route.params.id))
    notFound.value = !area.value

    // Oblasť s jediným sektorom rovno rozbalíme
    if (sectors.value.length === 1) openSectors.value = [sectors.value[0]!.id]
})

onBeforeUnmount(() => {
    selectedClimbId.value = null
})
</script>
