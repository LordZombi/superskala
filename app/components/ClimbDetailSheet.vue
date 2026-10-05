<template>
    <div
        v-if="selectedClimbId"
        ref="sheet"
        :class="[
          'fixed transition-transform duration-300 ease-in-out z-20 flex flex-col overflow-hidden',
          'bg-white shadow-2xl',
          'right-0 bottom-0 left-0 w-full rounded-t-3xl',
          isMinimized ? 'h-auto' : 'h-[70vh]',
          'lg:top-12 lg:right-0 lg:bottom-0 lg:left-auto lg:w-[30vw] lg:min-w-120 lg:h-auto lg:rounded-none',
        ]"
    >
        <!-- Úchyt je zároveň tlačidlo, aby sa panel dal zmenšiť aj bez gesta -->
        <button
            type="button"
            class="flex justify-center py-2.5 lg:hidden"
            aria-label="Detail cesty"
            :aria-expanded="!isMinimized"
            @click="isMinimized = !isMinimized"
        >
            <span class="h-1.5 w-10 rounded-full bg-neutral-500"></span>
        </button>

        <div :class="['relative', {'min-h-16': !climb?.boulder?.image_url, 'max-lg:min-h-16': isMinimized}]">
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

            <!-- Celý okraj fotky listuje medzi kameňmi; z-5 ho drží pod tlačidlami v rohoch (z-10) -->
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
                    v-if="climb?.boulder?.image_url"
                    icon="i-heroicons-arrows-pointing-out"
                    color="neutral"
                    variant="soft"
                    :class="['rounded-full', minimizedHidden]"
                    aria-label="Zobraziť celú fotku"
                    @click="isFullscreen = true"
                />
            </div>

            <TopoImage
                v-if="climb?.boulder?.image_url"
                :class="minimizedHidden"
                :image-url="climb.boulder.image_url"
                :alt="`Fotka kameňa ${climb.boulder.name}`"
                :climbs="otherClimbs"
                :selected-id="selectedClimbId"
                @select="id => selectedClimbId = id"
            />
        </div>

        <UModal
            v-if="climb?.boulder?.image_url"
            v-model:open="isFullscreen"
            fullscreen
            :title="climb.boulder.name"
            :description="climb.name"
            :ui="{ body: 'p-0 sm:p-0 bg-neutral-950', close: 'w-auto' }"
        >
            <template #body>
                <TopoImage
                    contain
                    class="h-full"
                    :image-url="climb.boulder.image_url"
                    :alt="`Fotka kameňa ${climb.boulder.name}`"
                    :climbs="otherClimbs"
                    :selected-id="selectedClimbId"
                    @select="id => selectedClimbId = id"
                />
            </template>
        </UModal>

        <div
            ref="scroller"
            class="p-4 overflow-y-auto overscroll-contain flex-1 space-y-6"
        >
            <div v-if="climb">
                <div class="space-y-1">
                    <div class="flex justify-between items-start gap-2">
                        <h2 class="text-2xl font-bold leading-none">
                            <template v-if="climb.topo_number">{{ climb.topo_number }}. </template>{{ climb.name }}
                        </h2>
                        <div class="flex items-center gap-2">
                            <SShareButton
                                v-if="climb.boulder?.sector?.area"
                                size="xs"
                                :title="climb.name"
                                :path="`/area/${climb.boulder.sector.area.id}?climb=${climb.id}`"
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
                        <template v-if="climb.boulder?.sector?.area">
                            <ULink
                                :to="`/area/${climb.boulder.sector.area.id}`"
                                class="underline"
                                @click="selectedClimbId = null"
                            >
                                {{ climb.boulder.sector.area.name }}
                            </ULink>
                            •
                        </template>
                        <template v-if="climb.boulder?.sector">
                            <ULink
                                class="underline uppercase"
                                @click="emit('selectSector', climb.boulder.sector_id)"
                            >
                                {{ climb.boulder.sector.name }}
                            </ULink>
                            •
                        </template>
                        {{ climb.boulder?.name }}
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
                            :to="{ path: '/admin/editor', query: { area: climb.boulder?.sector?.area?.id, sector: climb.boulder?.sector_id, boulder: climb.boulder_id, climb: climb.id } }"
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

                <SDivider :class="['my-3', minimizedHidden]"/>

                <div :class="['space-y-3', minimizedHidden]">
                    <h3 class="text-xs font-black uppercase text-slate-400">
                        Ostatné cesty na
                        bouldri</h3>
                    <div class="grid gap-2">
                        <UFieldGroup orientation="vertical">
                            <UButton
                                v-for="other in otherClimbs"
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
import {useSupabase} from '~/composables/useSupabase'
import SDivider from "~/components/super/SDivider.vue";
import SShareButton from "~/components/super/SShareButton.vue";
import TopoImage from "~/components/TopoImage.vue";

// Prvá cesta susedného kameňa – poradie pozná len stránka, ktorá detail otvára
const {prevId, nextId} = defineProps<{
    prevId?: string | null
    nextId?: string | null
}>()

const emit = defineEmits<{
    selectSector: [id: string]
}>()

const selectedClimbId = useState<string | null>('selectedClimbId')
const {supabase} = useSupabase()

const go = (id?: string | null) => {
    if (id) selectedClimbId.value = id
}

const scroller = useTemplateRef('scroller')
const {isMinimized} = useSheetSwipe(useTemplateRef('sheet'), scroller, {
    onLeft: () => go(nextId),
    onRight: () => go(prevId),
})

const navs = computed(() => [
    {id: prevId, label: 'Predchádzajúci kameň', icon: 'i-heroicons-chevron-left', class: 'left-0 justify-start'},
    {id: nextId, label: 'Nasledujúci kameň', icon: 'i-heroicons-chevron-right', class: 'right-0 justify-end'},
].filter(nav => nav.id))

// Bez fotky (a v zmenšenom paneli) je lišta nízka, šípky preto uhnú dovnútra spod rohových tlačidiel
const navPadding = computed(() => {
    if (!climb.value?.boulder?.image_url) return 'px-16'

    return isMinimized.value ? 'px-4 max-lg:px-16' : 'px-4'
})

// Zmenšený panel (len mobil) ukazuje iba názov; skrytý obsah tak nie je ani fokusovateľný
const minimizedHidden = computed(() => ({'max-lg:hidden': isMinimized.value}))
const climb = ref<any>(null)
const otherClimbs = ref<any[]>([])
const isFullscreen = ref(false)
// Čísla z topa sú text (3a, 3+3a), numeric zoradí 2 pred 10
const collator = new Intl.Collator('sk', {numeric: true})
// Úpravy sa dajú ukladať len lokálne, rovnako ako v editore
const isDev = import.meta.dev

watch(selectedClimbId, async (id) => {
    isMinimized.value = false
    // Nová cesta začína od názvu, nie tam, kde bola odscrollovaná predošlá
    scroller.value?.scrollTo({top: 0})

    if (!id) {
        climb.value = null
        otherClimbs.value = []
        return
    }

    // 1. Načítame detail vybratej cesty
    const {data: currentClimb} = await supabase
        .from('climbs')
        .select('*, grade:grades(font), boulder:boulders(*, sector:sectors(name, lat, lon, area:areas(id, name)))')
        .eq('id', id)
        .single()

    climb.value = currentClimb

    // 2. Načítame všetky cesty na rovnakom bouldri pre zoznam pod detailom
    if (currentClimb?.boulder_id) {
        const {data: list} = await supabase
            .from('climbs')
            .select('*, grade:grades(font)')
            .eq('boulder_id', currentClimb.boulder_id)
            .order('name')

        // Poradie ako v tope (číslo na fotke), cesty bez čísla na koniec
        otherClimbs.value = (list || []).sort((a, b) =>
            Number(a.topo_number === null) - Number(b.topo_number === null)
            || collator.compare(a.topo_number ?? '', b.topo_number ?? ''))
    }
}, {immediate: true})
</script>
