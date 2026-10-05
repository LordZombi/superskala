<template>
    <div class="relative">
        <img
            :alt="alt"
            :src="imageUrl"
            :class="contain ? 'w-full h-full object-contain' : 'w-full aspect-4/3 max-h-[40vh] object-cover'"
            @load="onImageLoad"
        />
        <!-- slice/meet musí zodpovedať object-cover/object-contain fotky, inak čiary nesedia -->
        <svg
            v-if="dims.width > 1"
            :viewBox="`0 0 ${dims.width} ${dims.height}`"
            :preserveAspectRatio="contain ? 'xMidYMid meet' : 'xMidYMid slice'"
            class="absolute inset-0 w-full h-full pointer-events-none"
        >
            <path
                v-if="pathDSexy"
                :d="pathDSexy"
                class="stroke-white pointer-events-none"
                :stroke-width="unit * 0.9"
                fill="none"
                stroke-linecap="round"
                stroke-linejoin="round"
            />

            <circle
                v-for="item in startsOfAllClimbs"
                :key="item.id"
                :cx="item.point.x"
                :cy="item.point.y"
                :r="unit * 1.6"
                :stroke-width="unit * (item.isActive ? 0.4 : 0.2)"
                :class="[
                  'pointer-events-auto cursor-pointer transition-all duration-200 shadow-sm',
                  item.isActive
                    ? 'fill-primary-500 stroke-white'
                    : 'fill-white/80 stroke-neutral-400 hover:fill-white'
                ]"
                @click="emit('select', item.id)"
            />
        </svg>
    </div>
</template>

<script
    setup
    lang="ts"
>
import {computed, ref} from 'vue'

const {imageUrl, climbs, selectedId, alt = '', contain = false} = defineProps<{
    imageUrl: string
    climbs: { id: string, topo_path: string | null }[]
    selectedId: string | null
    alt?: string
    /** Celá fotka bez orezu (fullscreen) namiesto orezaného náhľadu */
    contain?: boolean
}>()

const emit = defineEmits<{
    select: [id: string]
}>()

const dims = ref({width: 1, height: 1})
const {generateSexyPathD, parsePathString, toAbsolute} = useTopoPath()

// 1 % šírky fotky – veľkosť čiar a bodov tak nezávisí od rozlíšenia obrázka
const unit = computed(() => dims.value.width / 100)

const onImageLoad = (e: Event) => {
    const {naturalWidth, naturalHeight} = e.target as HTMLImageElement
    dims.value = {width: naturalWidth, height: naturalHeight}
}

const startsOfAllClimbs = computed(() => {
    if (dims.value.width <= 1) return []

    return climbs.flatMap((climb) => {
        const [start] = parsePathString(climb.topo_path)

        return start ? [{
            id: climb.id,
            point: toAbsolute(start, dims.value),
            isActive: climb.id === selectedId,
        }] : []
    })
})

const pathDSexy = computed(() => {
    const topoPath = climbs.find(climb => climb.id === selectedId)?.topo_path
    if (!topoPath || dims.value.width <= 1) return ''

    return generateSexyPathD(parsePathString(topoPath).map(point => toAbsolute(point, dims.value)))
})
</script>
