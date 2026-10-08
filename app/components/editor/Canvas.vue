<template>
    <UCard>
        <div
            v-if="imageUrl"
            class="relative select-none"
            ref="imageContainer"
        >
            <img
                :src="imageUrl"
                @load="onImageLoad"
                class="w-full h-auto"
                draggable="false"
                alt="Boulder for topo editing"
            />
            <svg
                v-if="imageDimensions.width > 1"
                :viewBox="`0 0 ${imageDimensions.width} ${imageDimensions.height}`"
                class="absolute top-0 left-0 w-full h-full"
                @click="handleSvgClick"
            >
                <!-- Existing Path -->
                <path
                    v-if="pathDSexy"
                    :d="pathDSexy"
                    class="stroke-white"
                    stroke-width="10"
                    fill="none"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />
                <path
                    v-if="pathDshadow"
                    :d="pathDshadow"
                    class="stroke-white"
                    stroke-width="3"
                    fill="none"
                    stroke-linecap="round"
                    stroke-linejoin="round"
                />
                <!-- Body cesty: ťahaním sa presúvajú, dvojklik ich odstráni, z klávesnice šípky a Delete -->
                <circle
                    v-for="(point, i) in pathPoints"
                    :key="i"
                    :cx="point.x * imageDimensions.width / 100"
                    :cy="point.y * imageDimensions.height / 100"
                    :r="pointRadius"
                    :stroke-width="pointRadius / 5"
                    tabindex="0"
                    role="button"
                    :aria-label="`Bod ${i + 1} z ${pathPoints?.length}`"
                    aria-keyshortcuts="ArrowUp ArrowDown ArrowLeft ArrowRight Delete"
                    class="fill-sky-500 stroke-white cursor-move touch-none outline-none focus-visible:stroke-amber-400"
                    @click.stop
                    @dblclick.stop="removePoint(i)"
                    @pointerdown.stop="grabPoint"
                    @pointermove="dragPoint(i, $event)"
                    @keydown="onPointKeydown(i, $event)"
                />
            </svg>
        </div>
        <div
            v-else
            class="flex items-center justify-center h-28"
        >
            <UIcon
                name="i-heroicons-photo"
                class="w-16 h-16 text-gray-400"
            />
        </div>

        <div @click="fileInput?.click()">
            <input
                type="file"
                ref="fileInput"
                class="hidden"
                accept="image/*"
                @change="onFileChange"
            />

            <UButton
                label="Nahrať fotku"
                variant="subtle"
                color="neutral"
                class="mt-6"
                icon="i-heroicons-photo"
                :loading="isUploading"
            />
        </div>
    </UCard>
</template>

<script
    setup
    lang="ts"
>
import {computed, ref, watch} from 'vue';
import {clamp} from '@vueuse/core';
import {UCard, UIcon} from '#components';

/**
 * @file Renders the boulder image and handles SVG drawing for topo creation.
 * It's a "dumb" component that receives state and emits events.
 */

type Point = { x: number; y: number };

const props = defineProps<{
    imageUrl: string | null;
    isUploading?: boolean;
}>();

const emit = defineEmits(['upload']);

const pathPoints = defineModel<{ x: number; y: number }[]>('pathPoints');

const imageContainer = ref<HTMLElement | null>(null);
const fileInput = ref<HTMLInputElement | null>(null);
const imageDimensions = ref({width: 1, height: 1});

const {generateSexyPathD, toAbsolute} = useTopoPath();

// Veľkosť bodu sa škáluje s fotkou, aby bol na malom aj veľkom obrázku rovnako dobre chytiteľný
const pointRadius = computed(() => imageDimensions.value.width / 60);

const onImageLoad = (event: Event) => {
    const img = event.target as HTMLImageElement;
    if (img.naturalWidth > 0) {
        imageDimensions.value = {width: img.naturalWidth, height: img.naturalHeight};
    }
};

const onFileChange = (event: Event) => {
    const input = event.target as HTMLInputElement;
    if (input.files && input.files[0]) {
        emit('upload', input.files[0]);
    }
};

/**
 * Computed property to generate the SVG path 'd' attribute from points.
 * Pridaná kontrola na platnosť rozmerov a súradníc.
 */
const pathDshadow = computed(() => {
    // Ak nemáme body alebo rozmery obrázka ešte nie sú načítané, vrátime prázdny reťazec
    if (!pathPoints.value || pathPoints.value.length < 2 || imageDimensions.value.width <= 1) {
        return '';
    }

    const {width, height} = imageDimensions.value;

    try {
        const absolutePoints = pathPoints.value.map(p => {
            const x = (p.x * width) / 100;
            const y = (p.y * height) / 100;

            // Ak je výsledok neplatné číslo, vyhodíme chybu pre tento bod
            if (isNaN(x) || isNaN(y)) return null;

            return `${x.toFixed(2)},${y.toFixed(2)}`;
        }).filter(p => p !== null);

        return absolutePoints.length > 0 ? `M ${absolutePoints.join(' L ')}` : '';
    } catch (e) {
        console.error("Chyba pri generovaní SVG cesty:", e);
        return '';
    }
});

/**
 * Vygeneruje plynulú SVG cestu pomocou kvadratických Bézierových kriviek.
 * Táto metóda spája stredové body, čím vytvára efekt "lezeckého lana".
 */
const pathDSexy = computed(() => {
    const relPoints = pathPoints.value || []
    const absPoints = relPoints.map(pt => toAbsolute(pt, imageDimensions.value))
    return generateSexyPathD(absPoints)
});

/** Pozícia udalosti na fotke v percentách; orezaná, aby sa bod nedal vytiahnuť mimo obrázka. */
const toPercent = (event: MouseEvent) => {
    const rect = imageContainer.value!.getBoundingClientRect();
    return {
        x: clamp(((event.clientX - rect.left) / rect.width) * 100, 0, 100),
        y: clamp(((event.clientY - rect.top) / rect.height) * 100, 0, 100),
    };
};

/** Vzdialenosť bodu od úsečky ab (v pixeloch fotky). */
const distanceToSegment = (p: Point, a: Point, b: Point) => {
    const dx = b.x - a.x;
    const dy = b.y - a.y;
    const t = dx || dy ? clamp(((p.x - a.x) * dx + (p.y - a.y) * dy) / (dx * dx + dy * dy), 0, 1) : 0;
    return Math.hypot(p.x - (a.x + t * dx), p.y - (a.y + t * dy));
};

/** Klik na čiaru vloží bod medzi susedné body, klik inde pridá bod na koniec cesty. */
const handleSvgClick = (event: MouseEvent) => {
    if (!imageContainer.value) return;
    const points = pathPoints.value || [];
    const point = toPercent(event);
    const click = toAbsolute(point, imageDimensions.value);
    const abs = points.map(pt => toAbsolute(pt, imageDimensions.value));

    let insertAt = points.length;
    let nearest = pointRadius.value;
    for (let i = 0; i < abs.length - 1; i++) {
        const d = distanceToSegment(click, abs[i]!, abs[i + 1]!);
        if (d < nearest) {
            nearest = d;
            insertAt = i + 1;
        }
    }
    pathPoints.value = [...points.slice(0, insertAt), point, ...points.slice(insertAt)];
};

const movePoint = (index: number, point: { x: number; y: number }) => {
    pathPoints.value = (pathPoints.value || []).map((p, i) => (i === index ? point : p));
};

const removePoint = (index: number) => {
    pathPoints.value = (pathPoints.value || []).filter((_, i) => i !== index);
};

// Pointer capture drží ťahanie na bode aj keď kurzor vyjde mimo neho
const grabPoint = (event: PointerEvent) => {
    (event.currentTarget as Element).setPointerCapture(event.pointerId);
};

const dragPoint = (index: number, event: PointerEvent) => {
    if ((event.currentTarget as Element).hasPointerCapture(event.pointerId)) {
        movePoint(index, toPercent(event));
    }
};

// Alternatíva ku gestám: šípky presúvajú (Shift = väčší krok), Delete odstráni
const onPointKeydown = (index: number, event: KeyboardEvent) => {
    if (event.key === 'Delete' || event.key === 'Backspace') {
        event.preventDefault();
        removePoint(index);
        return;
    }
    const step = event.shiftKey ? 1 : 0.2;
    const delta: Record<string, [number, number]> = {
        ArrowLeft: [-step, 0],
        ArrowRight: [step, 0],
        ArrowUp: [0, -step],
        ArrowDown: [0, step],
    };
    const d = delta[event.key];
    const p = pathPoints.value?.[index];
    if (!d || !p) return;
    event.preventDefault();
    movePoint(index, {x: clamp(p.x + d[0], 0, 100), y: clamp(p.y + d[1], 0, 100)});
};

// Watch for imageUrl changes to reset dimensions and preload the image
watch(() => props.imageUrl, (newUrl) => {
    imageDimensions.value = {width: 1, height: 1}; // Reset on new image
    if (newUrl) {
        const img = new Image();
        img.onload = () => {
            if (img.naturalWidth > 0) {
                imageDimensions.value = {width: img.naturalWidth, height: img.naturalHeight};
            }
        };
        img.src = newUrl;
    }
}, {immediate: true});
</script>
