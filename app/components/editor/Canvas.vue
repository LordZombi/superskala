<template>
    <UCard>
        <div
            v-if="imageUrl"
            class="relative"
            ref="imageContainer"
        >
            <img
                :src="imageUrl"
                @load="onImageLoad"
                class="w-full h-auto"
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
                <!-- Start Point -->
                <circle
                    v-if="startPos?.x"
                    :cx="startPos.x * imageDimensions.width / 100"
                    :cy="startPos.y * imageDimensions.height / 100"
                    r="15"
                    class="fill-emerald-500 stroke-emerald-500"
                    stroke-width="2"
                />
                <!-- Top Point -->
                <circle
                    v-if="topPos?.x"
                    :cx="topPos.x * imageDimensions.width / 100"
                    :cy="topPos.y * imageDimensions.height / 100"
                    r="15"
                    class="fill-red-500 stroke-red-500"
                    stroke-width="2"
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
import {UCard, UIcon} from '#components';

/**
 * @file Renders the boulder image and handles SVG drawing for topo creation.
 * It's a "dumb" component that receives state and emits events.
 */

export type PathDrawingModeType = 'start' | 'top' | 'path' | undefined
const props = defineProps<{
    imageUrl: string | null;
    mode: PathDrawingModeType;
    isUploading?: boolean;
}>();

const emit = defineEmits(['upload']);

const startPos = defineModel<{ x: number; y: number } | null>('startPos');
const topPos = defineModel<{ x: number; y: number } | null>('topPos');
const pathPoints = defineModel<{ x: number; y: number }[]>('pathPoints');

const imageContainer = ref<HTMLElement | null>(null);
const fileInput = ref<HTMLInputElement | null>(null);
const imageDimensions = ref({width: 1, height: 1});

const {generateSexyPathD, toAbsolute} = useTopoPath();

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

/**
 * Handles clicks on the SVG canvas.
 * Pridaný console.log pre ladenie súradníc.
 */
const handleSvgClick = (event: MouseEvent) => {
    if (!imageContainer.value) return;

    const rect = imageContainer.value.getBoundingClientRect();
    const xPercent = ((event.clientX - rect.left) / rect.width) * 100;
    const yPercent = ((event.clientY - rect.top) / rect.height) * 100;

    // Kontrola, či sme dostali rozumné čísla
    if (isNaN(xPercent) || isNaN(yPercent)) return;

    switch (props.mode) {
        case 'start':
            startPos.value = {x: xPercent, y: yPercent};
            break;
        case 'top':
            topPos.value = {x: xPercent, y: yPercent};
            break;
        case 'path':
            // V Nuxt 4/Vue 3.5 používame spread operátor na zachovanie reaktivity poľa
            pathPoints.value = [...(pathPoints.value || []), {x: xPercent, y: yPercent}];
            break;
    }
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
