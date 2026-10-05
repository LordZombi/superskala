<template>
    <div class="bg-neutral-50 min-h-screen p-4 lg:p-8">
        <div class="max-w-screen-2xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-8">

            <div class="lg:col-span-1 space-y-4">
                <EditorSidebar
                    @save="handleSave"
                    @newClimb="handleNewClimb"
                    :available-grades="availableGrades"
                    v-model:areaId="state.areaId"
                    v-model:sectorId="state.sectorId"
                    v-model:boulderId="selectedBoulderId"
                    v-model:climbId="state.climbId"
                    v-model:imageUrl="state.imageUrl"
                    v-model:name="state.name"
                    v-model:description="state.description"
                    v-model:videoUrl="state.videoUrl"
                    v-model:gradeId="state.gradeId"
                    v-model:isSitStart="state.isSitStart"
                    v-model:isDangerous="state.isDangerous"
                    v-model:mode="state.mode"
                    v-model:startPos="state.startPos"
                    v-model:topPos="state.topPos"
                    v-model:pathPoints="state.pathPoints"
                />
            </div>

            <div class="lg:col-span-2">
                <EditorCanvas
                    v-if="selectedBoulderId"
                    :image-url="state.imageUrl"
                    :mode="state.mode"
                    :is-uploading="loading"
                    @upload="handleImageUpload"
                    v-model:startPos="state.startPos"
                    v-model:topPos="state.topPos"
                    v-model:pathPoints="state.pathPoints"
                />
            </div>
        </div>
    </div>
</template>

<script
    setup
    lang="ts"
>
import { reactive, ref, onMounted, watch, nextTick } from 'vue';
import { useDebounceFn } from '@vueuse/core';
import type { Database } from '~/types/database.types';
import type { PathDrawingModeType } from "~/components/editor/Canvas.vue";

// --- TYPES ---
type Grade = Database['public']['Tables']['grades']['Row'];

interface EditorState {
    climbId: string;
    imageUrl: string;
    name: string;
    description?: string;
    videoUrl?: string;
    gradeId?: number;
    isSitStart: boolean;
    isDangerous: boolean;
    mode: PathDrawingModeType;
    startPos: { x: number; y: number } | null;
    topPos: { x: number; y: number } | null;
    pathPoints: { x: number; y: number }[];
    areaId: string | null;
    sectorId: string | null;
}

// --- STATE ---
const client = useSupabaseClient<Database>();
const state = reactive<EditorState>({
    climbId: '',
    imageUrl: '',
    name: '',
    description: '',
    videoUrl: '',
    gradeId: undefined,
    isSitStart: false,
    isDangerous: false,
    mode: undefined,
    startPos: null,
    topPos: null,
    pathPoints: [],
    areaId: null,
    sectorId: null,
});

const availableGrades = ref<Grade[]>([]);
const selectedBoulderId = ref<string>();

// --- DATA FETCHING ---
onMounted(async () => {
    const { data: gradesData } = await client.from('grades').select('*').order('value');
    if (gradesData) availableGrades.value = gradesData;
});

// --- IMAGE HANDLING ---
const debouncedUpdateBoulderImageUrl = useDebounceFn(async () => {
    if (!selectedBoulderId.value || !state.imageUrl) return;
    const { error } = await client.from('boulders').update({ image_url: state.imageUrl }).eq('id', selectedBoulderId.value);
    if (error) console.error('Failed to update boulder image URL:', error);
}, 1000);

watch(() => state.imageUrl, (newUrl, oldUrl) => {
    if (newUrl && newUrl !== oldUrl) debouncedUpdateBoulderImageUrl();
});

// --- SAVING LOGIC ---
const pathPointsToSvgString = (points: { x: number, y: number }[]): string | null => {
    if (points.length === 0) return null;
    return `M ${points.map(p => `${p.x.toFixed(2)}% ${p.y.toFixed(2)}%`).join(' L ')}`;
};

const pathStringToPoints = (path: string): { x: number, y: number }[] => {
    if (!path) return [];
    return path.replace('M ', '').split(' L ').map(p => {
        const [x, y] = p.split('% ').map(val => parseFloat(val));
        if (!x || !y) return { x: 0, y: 0 };
        return { x, y };
    });
};

const handleSave = async () => {
    if (!selectedBoulderId.value) {
        alert('Prosím, najskôr vyber boulder.');
        return;
    }

    const dataToSave: Database['public']['Tables']['climbs']['Insert'] = {
        boulder_id: selectedBoulderId.value,
        name: state.name,
        description: state.description,
        video_url: state.videoUrl || null,
        grade_id: state.gradeId,
        is_sit_start: state.isSitStart,
        is_dangerous: state.isDangerous,
        start_x: state.startPos?.x ?? null,
        start_y: state.startPos?.y ?? null,
        top_x: state.topPos?.x ?? null,
        top_y: state.topPos?.y ?? null,
        topo_path: pathPointsToSvgString(state.pathPoints),
    };

    if (state.climbId) { // --- UPDATE EXISTUJÚCEJ CESTY ---
        const { error } = await client.from('climbs').update(dataToSave).eq('id', state.climbId);
        if (error) alert(`Update zlyhal: ${error.message}`);
        else {
            alert('Cesta úspešne upravená!');
            // Trik na vynútenie re-fetchu v sidebare (prebliknutie ID)
            const bId = selectedBoulderId.value;
            const cId = state.climbId;
            selectedBoulderId.value = undefined;
            nextTick(() => {
                selectedBoulderId.value = bId;
                state.climbId = cId;
            });
        }
    } else { // --- ZÁPIS NOVEJ CESTY ---
        const { data, error } = await client.from('climbs').insert(dataToSave).select().single();
        if (error) alert(`Vytvorenie zlyhalo: ${error.message}`);
        else {
            alert('Nová cesta úspešne vytvorená!');
            const bId = selectedBoulderId.value;
            selectedBoulderId.value = undefined;
            nextTick(() => {
                selectedBoulderId.value = bId;
                if (data) state.climbId = data.id;
            });
        }
    }
};

const handleNewClimb = () => {
    state.climbId = '';
    state.name = '';
    state.description = '';
    state.videoUrl = '';
    state.gradeId = undefined;
    state.isSitStart = false;
    state.isDangerous = false;
    state.startPos = null;
    state.topPos = null;
    state.pathPoints = [];
};

const { uploadBoulderImage, loading } = useSupabase();

async function handleImageUpload(file: File) {
    if (!selectedBoulderId.value) return;

    const newUrl = await uploadBoulderImage(selectedBoulderId.value, file);
    if (newUrl) {
        state.imageUrl = newUrl;
    }
}
</script>
