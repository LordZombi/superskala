<template>
    <div class="bg-gray-50 dark:bg-gray-900 min-h-screen p-4 lg:p-8">
        <div class="max-w-8xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-8">

            <!-- Control Column -->
            <div class="lg:col-span-1 space-y-4">
                <UCard>
                    <template #header>
                        <h2 class="text-lg font-semibold">1. Vyber Kameň a Cestu</h2>
                    </template>
                    <div class="space-y-4">
                        <UFormField
                            label="Kameň"
                        >
                            <USelectMenu
                                v-model="selectedBoulderId"
                                :items="boulders"
                                value-key="id"
                                label-key="name"
                                placeholder="Vyber kameň"
                            />
                        </UFormField>

                        <UFormField
                            label="Cesta"
                        >
                            <USelectMenu
                                v-model="state.climbId"
                                :items="climbs"
                                value-key="id"
                                label-key="name"
                                placeholder="Vyber cestu"
                                :disabled="!selectedBoulderId"
                            />
                        </UFormField>
                    </div>
                </UCard>

                <EditorSidebar
                    @save="handleSave"
                    @newClimb="handleNewClimb"
                    :available-grades="availableGrades"
                    v-model:climbId="state.climbId"
                    v-model:imageUrl="state.imageUrl"
                    v-model:climbName="state.climbName"
                    v-model:gradeId="state.gradeId"
                    v-model:isSitStart="state.isSitStart"
                    v-model:mode="state.mode"
                    v-model:startPos="state.startPos"
                    v-model:topPos="state.topPos"
                    v-model:pathPoints="state.pathPoints"
                />
            </div>

            <!-- Canvas Column -->
            <div class="lg:col-span-2">
                <EditorCanvas
                    :image-url="state.imageUrl"
                    :mode="state.mode"
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
import {reactive, ref, watch} from 'vue';
import {useDebounceFn} from '@vueuse/core';
import type {Database} from '~/types/database.types';

// --- TYPES ---
type Grade = Database['public']['Tables']['grades']['Row'];
type Climb = Database['public']['Tables']['climbs']['Row'];
type Boulder = Database['public']['Tables']['boulders']['Row'];

interface EditorState {
    climbId: string;
    imageUrl: string;
    climbName: string;
    gradeId: number | null;
    isSitStart: boolean;
    mode: 'start' | 'top' | 'path';
    startPos: { x: number; y: number } | null;
    topPos: { x: number; y: number } | null;
    pathPoints: { x: number; y: number }[];
}

// --- STATE ---
const client = useSupabaseClient<Database>();
const state = reactive<EditorState>({
    climbId: '',
    imageUrl: '',
    climbName: '',
    gradeId: null,
    isSitStart: false,
    mode: 'path',
    startPos: null,
    topPos: null,
    pathPoints: [],
});

const boulders = ref<Boulder[]>([]);
const climbs = ref<Climb[]>([]);
const availableGrades = ref<Grade[]>([]);
const selectedBoulderId = ref<string | null>(null);

// --- DATA FETCHING ---
onMounted(async () => {
    const {data: bouldersData} = await client.from('boulders').select('id, name, image_url').order('name');
    if (bouldersData) boulders.value = bouldersData;

    const {data: gradesData} = await client.from('grades').select('*').order('value');
    if (gradesData) availableGrades.value = gradesData;
});

watch(selectedBoulderId, async (newBoulderId) => {
    if (!newBoulderId) {
        climbs.value = [];
        state.climbId = '';
        state.imageUrl = '';
        return;
    }
    const selectedBoulder = boulders.value.find(b => b.id === newBoulderId);
    state.imageUrl = selectedBoulder?.image_url ?? '';
    await fetchClimbsForBoulder(newBoulderId);
});

watch(() => state.climbId, (newClimbId) => {
    if (!newClimbId) return;
    const climbData = climbs.value.find(c => c.id === newClimbId);
    if (climbData) {
        state.climbName = climbData.name;
        state.gradeId = climbData.grade_id;
        state.isSitStart = climbData.is_sit_start ?? false;
        state.startPos = climbData.start_x && climbData.start_y ? {x: climbData.start_x, y: climbData.start_y} : null;
        state.topPos = climbData.top_x && climbData.top_y ? {x: climbData.top_x, y: climbData.top_y} : null;
        state.pathPoints = climbData.topo_path ? pathStringToPoints(climbData.topo_path) : [];
    }
});

const fetchClimbsForBoulder = async (boulderId: string) => {
    const {data} = await client.from('climbs').select('*').eq('boulder_id', boulderId).order('name');
    if (data) climbs.value = data;
};

// --- IMAGE HANDLING ---
const debouncedUpdateBoulderImageUrl = useDebounceFn(async () => {
    if (!selectedBoulderId.value || !state.imageUrl) return;
    const {error} = await client.from('boulders').update({image_url: state.imageUrl}).eq('id', selectedBoulderId.value);
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
        return {x, y};
    });
};

const handleSave = async () => {
    if (!selectedBoulderId.value) {
        alert('Please select a boulder first.');
        return;
    }

    const dataToSave: Database['public']['Tables']['climbs']['Insert'] = {
        boulder_id: selectedBoulderId.value,
        name: state.climbName,
        grade_id: state.gradeId,
        is_sit_start: state.isSitStart,
        start_x: state.startPos?.x ?? null,
        start_y: state.startPos?.y ?? null,
        top_x: state.topPos?.x ?? null,
        top_y: state.topPos?.y ?? null,
        topo_path: pathPointsToSvgString(state.pathPoints),
    };

    if (state.climbId) { // --- UPDATE EXISTING CLIMB ---
        const {error} = await client.from('climbs').update(dataToSave).eq('id', state.climbId);
        if (error) alert(`Update failed: ${error.message}`);
        else alert('Climb updated successfully!');
    } else { // --- INSERT NEW CLIMB ---
        const {data, error} = await client.from('climbs').insert(dataToSave).select().single();
        if (error) alert(`Insert failed: ${error.message}`);
        else {
            alert('New climb created successfully!');
            await fetchClimbsForBoulder(selectedBoulderId.value); // Refresh climb list
            if (data) state.climbId = data.id; // Select the newly created climb
        }
    }
};

const handleNewClimb = () => {
    state.climbId = '';
    state.climbName = 'New Climb';
    state.gradeId = null;
    state.isSitStart = false;
    state.startPos = null;
    state.topPos = null;
    state.pathPoints = [];
};
</script>
