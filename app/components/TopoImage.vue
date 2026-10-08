<template>
    <!-- touch-none: štipnutie na fotke nepriblíži celú stránku (rozbilo by rozloženie), fotku si približujeme sami -->
    <div
        ref="frame"
        class="relative overflow-hidden touch-none"
        @touchstart.passive="onTouchStart"
        @touchmove.passive="onTouchMove"
        @touchend.passive="onTouchEnd"
        @touchcancel.passive="onTouchEnd"
        @dblclick="onDoubleClick"
    >
        <div
            :class="['relative origin-top-left', {'h-full': contain}]"
            :style="{transform: `translate(${zoom.x}px, ${zoom.y}px) scale(${zoom.scale})`}"
        >
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
    </div>
</template>

<script
    setup
    lang="ts"
>
import {computed, ref, useTemplateRef, watch} from 'vue'

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

// Priblíženie fotky: štipnutie dvoma prstami, posun jedným; dvojklik/dvojité ťuknutie ho prepína,
// takže sa dá priblížiť aj jedným prstom či myšou
const MAX_SCALE = 4
const DOUBLE_CLICK_SCALE = 2.5

interface Zoom {
    scale: number
    x: number
    y: number
}

const frame = useTemplateRef('frame')
const zoom = ref<Zoom>({scale: 1, x: 0, y: 0})
// Stav na začiatku gesta: priblíženie a bod (stred prstov voči rámu), ku ktorému sa gesto vzťahuje
let start = {scale: 1, x: 0, y: 0, px: 0, py: 0, distance: 1}
let isPinching = false

const resetZoom = () => zoom.value = {scale: 1, x: 0, y: 0}

watch(() => [imageUrl, contain], resetZoom)

// Bod pod prstami ostáva pod prstami; fotka pritom nikdy neodkryje okraj rámu
const zoomTo = (scale: number, px: number, py: number, from = start) => {
    const {clientWidth, clientHeight} = frame.value!
    const next = Math.min(Math.max(scale, 1), MAX_SCALE)
    const clamp = (offset: number, size: number) => Math.min(0, Math.max(offset, size - size * next))

    zoom.value = {
        scale: next,
        x: clamp(px - (from.px - from.x) * next / from.scale, clientWidth),
        y: clamp(py - (from.py - from.y) * next / from.scale, clientHeight),
    }
}

const readTouches = ({touches}: TouchEvent) => {
    const {left, top} = frame.value!.getBoundingClientRect()
    const [first, second = first] = [touches[0]!, touches[1]]

    return {
        px: (first.clientX + second.clientX) / 2 - left,
        py: (first.clientY + second.clientY) / 2 - top,
        distance: Math.hypot(first.clientX - second.clientX, first.clientY - second.clientY) || 1,
    }
}

// Kým je fotka priblížená alebo prebieha štipnutie, gestá patria jej – rodič (panel) by ich inak bral ako potiahnutie
const ownsGesture = (event: TouchEvent) => {
    if (!isPinching && zoom.value.scale === 1) return false

    event.stopPropagation()
    return true
}

const onTouchStart = (event: TouchEvent) => {
    if (event.touches.length > 1) isPinching = true
    if (ownsGesture(event)) start = {...zoom.value, ...readTouches(event)}
}

const onTouchMove = (event: TouchEvent) => {
    if (!ownsGesture(event)) return

    const {px, py, distance} = readTouches(event)

    zoomTo(start.scale * (event.touches.length > 1 ? distance / start.distance : 1), px, py)
}

const onTouchEnd = (event: TouchEvent) => {
    if (!ownsGesture(event)) return

    // Zvyšný prst pokračuje posunom od miesta, kde práve je
    if (event.touches.length) start = {...zoom.value, ...readTouches(event)}
    else isPinching = false
}

const onDoubleClick = ({clientX, clientY}: MouseEvent) => {
    const {left, top} = frame.value!.getBoundingClientRect()
    const [px, py] = [clientX - left, clientY - top]

    zoomTo(zoom.value.scale > 1 ? 1 : DOUBLE_CLICK_SCALE, px, py, {...zoom.value, px, py, distance: 1})
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
