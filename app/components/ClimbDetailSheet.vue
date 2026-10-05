<template>
    <div
        v-if="selectedClimbId"
        :class="[
          'fixed transition-transform duration-300 ease-in-out z-20 flex flex-col overflow-hidden',
          'bg-white shadow-2xl',
          'right-0 bottom-0 left-0 w-full h-[70vh] rounded-t-3xl',
          'lg:top-12 lg:right-0 lg:bottom-0 lg:left-auto lg:w-[30vw] lg:min-w-120 lg:h-auto lg:rounded-none',
        ]"
    >
        <div :class="['relative', {'min-h-16': !climb?.boulder?.image_url}]">
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
                    class="rounded-full"
                    aria-label="Zobraziť celú fotku"
                    @click="isFullscreen = true"
                />
            </div>

            <TopoImage
                v-if="climb?.boulder?.image_url"
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

        <div class="p-4 overflow-y-auto flex-1 space-y-6">
            <div v-if="climb">
                <div class="space-y-1">
                    <div class="flex justify-between items-start gap-2">
                        <h2 class="text-2xl font-bold leading-none">
                            <template v-if="climb.topo_number">{{ climb.topo_number }}. </template>{{ climb.name }}
                        </h2>
                        <div class="col-auto">
                            <UBadge
                                v-if="climb.grade"
                                color="primary"
                                variant="solid"
                                size="md"
                                class="shrink-0"
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
                        {{ climb.boulder?.sector?.name }} • {{ climb.boulder?.name }}
                    </p>
                    <div class="flex gap-2">
                        <div
                            v-if="climb.is_sit_start"
                            class="col-auto"
                        >
                            <UBadge
                                label="SIT START"
                                color="info"
                                size="sm"
                            />
                        </div>
                        <UButton
                            v-if="climb.video_url"
                            :to="climb.video_url"
                            target="_blank"
                            icon="i-heroicons-play-solid"
                            label="VIDEO"
                            size="xs"
                            class="w-auto bg-red-700 hover:bg-red-800 text-white"
                            :aria-label="`Video cesty ${climb.name} (otvorí sa v novej karte)`"
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
                        class="text-slate-600 text-sm leading-relaxed"
                    >
                        {{ climb.description }}
                    </p>
                </div>

                <SDivider class="my-3"/>

                <div class="space-y-3">
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
import {ref, watch} from 'vue'
import {useSupabase} from '~/composables/useSupabase'
import SDivider from "~/components/super/SDivider.vue";
import TopoImage from "~/components/TopoImage.vue";

const selectedClimbId = useState<string | null>('selectedClimbId')
const {supabase} = useSupabase()
const climb = ref<any>(null)
const otherClimbs = ref<any[]>([])
const isFullscreen = ref(false)

watch(selectedClimbId, async (id) => {
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
        otherClimbs.value = (list || []).sort((a, b) => (a.topo_number ?? Infinity) - (b.topo_number ?? Infinity))
    }
}, {immediate: true})
</script>
