<template>
    <div
        v-if="selectedClimbId"
        ref="sheet"
        :class="[
          'fixed transition-transform duration-300 ease-in-out flex flex-col overflow-hidden',
          'bg-white shadow-2xl',
          // Celá obrazovka je ten istý panel roztiahnutý cez všetko vrátane hlavičky stránky (z-30)
          isFullscreen ? 'inset-0 z-40' : [
            'z-20 right-0 bottom-0 left-0 w-full h-[70vh] rounded-t-3xl',
            isMinimized && 'max-lg:translate-y-[calc(100%-9rem)]',
            'lg:top-12 lg:right-0 lg:bottom-0 lg:left-auto lg:w-[30vw] lg:min-w-120 lg:h-auto lg:rounded-none',
          ],
        ]"
    >
        <div
            :class="['relative', {
                'min-h-16': !boulder?.image_url,
                'max-lg:min-h-16': isMinimized,
                'flex-1 min-h-0 bg-neutral-950': isFullscreen,
            }]"
        >
            <div class="absolute top-4 left-4 z-10">
                <UButton
                    icon="i-heroicons-arrow-left"
                    color="neutral"
                    variant="soft"
                    class="rounded-full"
                    aria-label="Späť na oblasť"
                    @click="selectedClimbId = null"
                />
            </div>

            <!-- Celý okraj fotky listuje medzi cestami; z-5 ho drží pod tlačidlami v rohoch (z-10) -->
            <button
                v-for="nav in navs"
                :key="nav.label"
                type="button"
                :class="['group absolute inset-y-0 z-5 flex w-1/5 min-w-24 items-center', nav.class, navPadding]"
                :aria-label="nav.label"
                @click="go(nav.id)"
            >
                <!-- Pozadie musí byť na obale: ikona sa kreslí maskou cez vlastné pozadie -->
                <span class="flex size-8 items-center justify-center rounded-full bg-white/80 text-neutral-900 group-hover:bg-white">
                    <UIcon
                        :name="nav.icon"
                        class="size-5"
                    />
                </span>
            </button>

            <div class="absolute top-4 right-4 z-10 flex flex-col gap-2">
                <UButton
                    icon="i-heroicons-x-mark"
                    color="neutral"
                    variant="soft"
                    class="rounded-full"
                    aria-label="Zavrieť detail cesty"
                    @click="selectedClimbId = null"
                />
                <UButton
                    v-if="boulder?.image_url"
                    :icon="isFullscreen ? 'i-heroicons-arrows-pointing-in' : 'i-heroicons-arrows-pointing-out'"
                    color="neutral"
                    variant="soft"
                    :class="['rounded-full', minimizedHidden]"
                    :aria-label="isFullscreen ? 'Zmenšiť fotku' : 'Zobraziť celú fotku'"
                    @click="isFullscreen = !isFullscreen"
                />
            </div>

            <!-- Fotka sa pri zmenšení zbalí cez výšku riadku gridu, aby sa dala animovať -->
            <div
                v-if="boulder?.image_url"
                :class="['grid transition-[grid-template-rows] duration-300 ease-in-out', isMinimized ? 'max-lg:grid-rows-[0fr]' : 'grid-rows-[1fr]', {'h-full': isFullscreen}]"
            >
                <TopoImage
                    :contain="isFullscreen"
                    :class="['min-h-0 overflow-hidden', {'h-full': isFullscreen}]"
                    :image-url="boulder.image_url"
                    :alt="`Fotka kameňa ${boulder.name}`"
                    :climbs="climbs"
                    :selected-id="selectedClimbId"
                    @select="id => selectedClimbId = id"
                />
            </div>
        </div>

        <div
            ref="scroller"
            :class="['p-4 overflow-y-auto overscroll-contain space-y-6', isFullscreen ? 'flex-none max-h-[40%]' : 'flex-1']"
        >
            <div v-if="climb">
                <div class="space-y-1">
                    <div class="flex justify-between items-start gap-2">
                        <h2 class="text-2xl font-bold leading-none">
                            <template v-if="climb.topo_number">{{ climb.topo_number }}. </template>{{ climb.name }}
                        </h2>
                        <div class="flex items-center gap-2">
                            <SShareButton
                                v-if="area"
                                size="xs"
                                :title="climb.name"
                                :path="`/area/${area.id}?climb=${climb.id}${isFullscreen ? '&fullscreen=1' : ''}`"
                            />
                            <UBadge
                                v-if="climb.grade"
                                color="primary"
                                variant="solid"
                                size="md"
                                class="shrink-0 w-auto"
                            >
                                {{ climb.grade.font }}
                            </UBadge>
                        </div>
                    </div>
                    <p class="text-slate-500 font-bold uppercase text-[10px]">
                        <template v-if="area">
                            <ULink
                                :to="`/area/${area.id}`"
                                class="underline"
                                @click="selectedClimbId = null"
                            >
                                {{ area.name }}
                            </ULink>
                            •
                        </template>
                        <template v-if="sector">
                            <ULink
                                class="underline uppercase"
                                @click="emit('selectSector', sector.id)"
                            >
                                {{ sector.name }}
                            </ULink>
                            •
                        </template>
                        {{ boulder?.name }}
                    </p>
                    <div :class="['flex items-center gap-2', minimizedHidden]">
                        <div
                            v-if="climb.is_sit_start"
                            class="flex"
                        >
                            <UBadge
                                label="SIT START"
                                color="info"
                                size="sm"
                            />
                        </div>
                        <ULink
                            v-if="climb.video_url"
                            :to="climb.video_url"
                            target="_blank"
                            class="flex"
                            :aria-label="`Video cesty ${climb.name} (otvorí sa v novej karte)`"
                        >
                            <UBadge
                                label="VIDEO"
                                icon="i-heroicons-play-solid"
                                size="sm"
                                class="bg-red-700 hover:bg-red-800 text-white"
                            />
                        </ULink>
                        <UButton
                            v-if="isDev"
                            :to="{ path: '/admin/editor', query: { area: area?.id, sector: sector?.id, boulder: climb.boulder_id, climb: climb.id } }"
                            icon="i-heroicons-pencil"
                            label="Upraviť"
                            color="neutral"
                            variant="ghost"
                            size="xs"
                            class="w-auto"
                            :aria-label="`Upraviť cestu ${climb.name}`"
                        />
                        <div
                            v-if="climb.is_dangerous"
                            class="col-auto"
                        >
                            <UBadge
                                v-if="climb.is_dangerous"
                                label="NEBEZPEČNÉ"
                                color="error"
                                variant="soft"
                                size="xs"
                            />
                        </div>
                    </div>
                    <p
                        v-if="climb.description"
                        :class="['text-slate-600 text-sm leading-relaxed', minimizedHidden]"
                    >
                        {{ climb.description }}
                    </p>
                </div>

                <!-- Na celej obrazovke ostáva pod fotkou len hlavička cesty -->
                <SDivider
                    v-if="!isFullscreen"
                    :class="['my-3', minimizedHidden]"
                />

                <div
                    v-if="!isFullscreen"
                    :class="['space-y-3', minimizedHidden]"
                >
                    <div class="flex items-center justify-between gap-2">
                        <h3 class="text-xs font-black uppercase text-slate-400">
                            Ostatné cesty na
                            bouldri</h3>
                        <SSortChip/>
                    </div>
                    <div class="grid gap-2">
                        <UFieldGroup orientation="vertical">
                            <UButton
                                v-for="other in listedClimbs"
                                :key="other.id"
                                :variant="other.id === selectedClimbId ? 'subtle' : 'outline'"
                                :color="other.id === selectedClimbId ? 'neutral' : 'neutral'"
                                block
                                class="justify-between px-3 py-2.5"
                                @click="selectedClimbId = other.id"
                            >
                            <span :class="[other.id === selectedClimbId ? 'font-bold' : 'font-medium']">
                                <template v-if="other.topo_number">{{ other.topo_number }}. </template>{{ other.name }}
                            </span>
                                <span class="text-[10px] font-mono">{{ other.grade?.font || '?' }}</span>
                            </UButton>
                        </UFieldGroup>
                    </div>
                </div>
            </div>

            <div
                v-else
                class="flex items-center justify-center h-32"
            >
                <UIcon
                    name="i-heroicons-arrow-path"
                    class="animate-spin w-8 h-8 text-slate-300"
                />
            </div>
        </div>
    </div>
</template>

<script
    setup
    lang="ts"
>
import {computed, ref, useTemplateRef, watch} from 'vue'
import {useSheetSwipe} from '~/composables/useSheetSwipe'
import SDivider from "~/components/super/SDivider.vue";
import SShareButton from "~/components/super/SShareButton.vue";
import SSortChip from "~/components/super/SSortChip.vue";
import TopoImage from "~/components/TopoImage.vue";

// Dáta dodá stránka oblasti zo stromu, ktorý už má načítaný – detail tak funguje aj offline bez ďalších dopytov
const {climbs = [], boulder = null, sector = null, area = null, prevId, nextId} = defineProps<{
    /** Cesty na kameni vybranej cesty, v poradí z topa */
    climbs?: any[]
    boulder?: { name: string, image_url: string | null } | null
    sector?: { id: string, name: string } | null
    area?: { id: string, name: string } | null
    // Susedné cesty v poradí zoznamu – poradie pozná len stránka, ktorá detail otvára
    prevId?: string | null
    nextId?: string | null
}>()

const emit = defineEmits<{
    selectSector: [id: string]
}>()

const selectedClimbId = useState<string | null>('selectedClimbId')

const go = (id?: string | null) => {
    if (id) selectedClimbId.value = id
}

const scroller = useTemplateRef('scroller')
const {isMinimized} = useSheetSwipe(useTemplateRef('sheet'), scroller, {
    // Bez fotky nemá celá obrazovka čo ukázať
    onUp: () => isFullscreen.value = Boolean(boulder?.image_url),
    onLeft: () => go(nextId),
    onRight: () => go(prevId),
})

const navs = computed(() => [
    {id: prevId, label: 'Predchádzajúca cesta', icon: 'i-heroicons-chevron-left', class: 'left-0 justify-start'},
    {id: nextId, label: 'Nasledujúca cesta', icon: 'i-heroicons-chevron-right', class: 'right-0 justify-end'},
].filter(nav => nav.id))

// Bez fotky (a v zmenšenom paneli) je lišta nízka, šípky preto uhnú dovnútra spod rohových tlačidiel
const navPadding = computed(() => {
    if (!boulder?.image_url) return 'px-16'

    return isMinimized.value ? 'px-4 max-lg:px-16' : 'px-4'
})

// Zmenšený panel (len mobil) ukazuje iba názov; invisible obsah vyradí z fokusu a výšku nechá panelu na animáciu
const minimizedHidden = computed(() => ({'max-lg:invisible': isMinimized.value}))
// Zoznam ďalších ciest drží poradie z topa, kým si nezvolíš radenie podľa obtiažnosti (rovnaké ako v zozname oblasti)
const sortByGrade = useState<boolean>('sortByGrade', () => false)
const listedClimbs = computed(() => sortByGrade.value
    ? climbs.toSorted((a, b) => (a.grade?.value ?? Infinity) - (b.grade?.value ?? Infinity))
    : climbs)
const climb = computed(() => climbs.find(({id}) => id === selectedClimbId.value) ?? null)
const isFullscreen = ref(false)

// Na celej obrazovke nie je čo zmenšovať, potiahnutie dole ju preto len zavrie
watch(isMinimized, (minimized) => {
    if (!minimized || !isFullscreen.value) return

    isFullscreen.value = false
    isMinimized.value = false
})

// Zdieľaný odkaz s ?fullscreen otvorí fotku rovno na celú obrazovku – len raz, pri prvej načítanej ceste
const route = useRoute()
let openFullscreen = route.query.fullscreen !== undefined
// Úpravy sa dajú ukladať len lokálne, rovnako ako v editore
const isDev = import.meta.dev

watch(selectedClimbId, (id) => {
    isMinimized.value = false
    // Nová cesta začína od názvu, nie tam, kde bola odscrollovaná predošlá
    scroller.value?.scrollTo({top: 0})

    if (!id) isFullscreen.value = false
})

// Cesta môže prísť až po načítaní oblasti (otvorený odkaz), preto sa sleduje ona, nie len výber
watch(climb, (current) => {
    if (!current) return

    // Kameň bez fotky nemá čo ukázať na celej obrazovke
    if (!boulder?.image_url) isFullscreen.value = false
    else if (openFullscreen) isFullscreen.value = true

    if (openFullscreen) {
        openFullscreen = false
        navigateTo({query: {...route.query, fullscreen: undefined}}, {replace: true})
    }
}, {immediate: true})
</script>
