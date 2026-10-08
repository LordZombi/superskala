<template>
    <div class="bg-neutral-50 min-h-screen p-4 lg:p-8">
        <div class="max-w-screen-2xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-8">

            <div class="lg:col-span-1 space-y-4">
                <EditorSidebar
                    @save="handleSave"
                    @newClimb="handleNewClimb"
                    @delete="handleDelete"
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
                    v-model:pathPoints="state.pathPoints"
                />
            </div>

            <div class="lg:col-span-2">
                <EditorCanvas
                    v-if="selectedBoulderId"
                    :image-url="state.imageUrl"
                    :is-uploading="loading"
                    @upload="handleImageUpload"
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

definePageMeta({ middleware: 'editor' });
import { useDebounceFn } from '@vueuse/core';
import type { Database } from '~/types/database.types';

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
    pathPoints: { x: number; y: number }[];
    areaId: string | null;
    sectorId: string | null;
}

// --- STATE ---
const client = useSupabaseClient<Database>();
const toast = useToast();
const state = reactive<EditorState>({
    climbId: '',
    imageUrl: '',
    name: '',
    description: '',
    videoUrl: '',
    gradeId: undefined,
    isSitStart: false,
    isDangerous: false,
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
        toast.add({title: 'Najskôr vyber boulder', color: 'warning'});
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
        topo_path: pathPointsToSvgString(state.pathPoints),
    };

    if (state.climbId) { // --- UPDATE EXISTUJÚCEJ CESTY ---
        const { error } = await client.from('climbs').update(dataToSave).eq('id', state.climbId);
        if (error) toast.add({title: 'Uloženie zlyhalo', description: error.message, color: 'error'});
        else {
            toast.add({title: 'Cesta uložená', description: state.name, color: 'success'});
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
        if (error) toast.add({title: 'Vytvorenie zlyhalo', description: error.message, color: 'error'});
        else {
            toast.add({title: 'Nová cesta vytvorená', description: state.name, color: 'success'});
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
    state.pathPoints = [];
};

const handleDelete = async () => {
    // .select() vráti zmazané riadky, takže vidíme aj prípad, keď databáza zmazanie ticho nepovolí
    const { data, error } = await client.from('climbs').delete().eq('id', state.climbId).select();
    if (error || !data?.length) {
        toast.add({ title: 'Zmazanie zlyhalo', description: error?.message ?? 'Databáza zmazanie nepovolila', color: 'error' });
        return;
    }
    toast.add({ title: 'Cesta zmazaná', description: state.name, color: 'success' });

    // Rovnaký trik ako pri ukladaní: prebliknutie boulderu vynúti nový fetch ciest v sidebare
    const bId = selectedBoulderId.value;
    handleNewClimb();
    selectedBoulderId.value = undefined;
    nextTick(() => {
        selectedBoulderId.value = bId;
    });
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
