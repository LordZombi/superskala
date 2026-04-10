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
        <div class="relative">
            <div class="absolute top-4 right-4 z-10">
                <UButton
                    icon="i-heroicons-x-mark"
                    color="neutral"
                    variant="soft"
                    class="rounded-full"
                    @click="selectedClimbId = null"
                />
            </div>

            <div
                v-if="climb?.boulder?.image_url"
                class="relative"
            >
                <img
                    alt=""
                    :src="climb.boulder.image_url"
                    class="w-full aspect-4/3 max-h-[40vh] object-cover"
                    @load="onImageLoad"
                />
                <svg
                    v-if="dims.width > 1"
                    :viewBox="`0 0 ${dims.width} ${dims.height}`"
                    class="absolute inset-0 w-full h-full pointer-events-none"
                >
                    <path
                        v-if="pathDSexy"
                        :d="pathDSexy"
                        class="stroke-white pointer-events-none"
                        stroke-width="20"
                        fill="none"
                        stroke-linecap="round"
                        stroke-linejoin="round"
                    />

                    <circle
                        v-for="item in startsOfAllClimbs"
                        :key="item.id"
                        :cx="item.point.x"
                        :cy="item.point.y"
                        :r="35"
                        :class="[
                          'pointer-events-auto cursor-pointer transition-all duration-200 shadow-sm',
                          item.isActive
                            ? 'fill-primary-500 stroke-white stroke-8'
                            : 'fill-white/80 stroke-neutral-400 stroke-4 hover:fill-white'
                        ]"
                        @click="selectedClimbId = item.id"
                    />
                </svg>
            </div>
        </div>

        <div class="p-4 overflow-y-auto flex-1 space-y-6">
            <div v-if="climb">
                <div class="space-y-1">
                    <div class="flex justify-between items-start gap-2">
                        <h2
                            class="text-2xl font-bold leading-none"
                            v-text="climb.name"
                        ></h2>
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
                                {{ other.name }}
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
import {computed, ref, watch} from 'vue'
import {useSupabase} from '~/composables/useSupabase'
import SDivider from "~/components/super/SDivider.vue";

const selectedClimbId = useState<string | null>('selectedClimbId')
const {supabase} = useSupabase()
const climb = ref<any>(null)
const otherClimbs = ref<any[]>([])
const dims = ref({width: 1, height: 1})
const {generateSexyPathD, parsePathString, toAbsolute} = useTopoPath();

watch(selectedClimbId, async (id) => {
    if (!id) {
        climb.value = null
        otherClimbs.value = []
        return
    }

    // 1. Načítame detail vybratej cesty
    const {data: currentClimb} = await supabase
        .from('climbs')
        .select('*, grade:grades(font), boulder:boulders(*, sector:sectors(name, lat, lon))')
        .eq('id', id)
        .single()

    climb.value = currentClimb

    // 2. Načítame všetky cesty na rovnakom bouldri pre zoznam pod detailom
    if (currentClimb?.boulder_id) {
        const {data: list} = await supabase
            .from('climbs')
            .select('id, name, topo_path, grade:grades(font)')
            .eq('boulder_id', currentClimb.boulder_id)
            .order('name')

        otherClimbs.value = list || []
    }
}, {immediate: true})

const onImageLoad = (e: any) => {
    dims.value = {width: e.target.naturalWidth, height: e.target.naturalHeight}
}

const startsOfAllClimbs = computed(() => {
    if (!otherClimbs.value.length || dims.value.width <= 1) return []

    return otherClimbs.value.map(c => {
        const relPoints = parsePathString(c.topo_path)
        if (!relPoints[0]) return null

        return {
            id: c.id,
            point: toAbsolute(relPoints[0], dims.value),
            isActive: c.id === selectedClimbId.value
        }
    }).filter(i => i !== null)
})

const pathDSexy = computed(() => {
    if (!climb.value?.topo_path || dims.value.width <= 1) return ''
    const relPoints = parsePathString(climb.value.topo_path)
    const absPoints = relPoints.map(pt => toAbsolute(pt, dims.value))
    return generateSexyPathD(absPoints)
})
</script>
