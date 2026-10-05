<template>
    <UCard>
        <template #header>
            <div class="flex justify-between items-center">
                <h1 class="text-2xl font-bold text-primary-500">Topo Editor</h1>
            </div>
        </template>

        <div class="space-y-6">
            <div>
                <h2 class="text-lg font-semibold text-primary-500 mb-3">
                    1. Lokalita a výber kameňa
                </h2>
                <div class="space-y-4">
                    <UFormField label="Oblasť">
                        <div class="flex gap-2 w-full">
                            <USelectMenu
                                v-model="areaId"
                                :items="areas"
                                value-key="id"
                                label-key="name"
                                placeholder="Vyber oblasť"
                                class="flex-1"
                            />
                            <div class="flex-none">
                                <UButton
                                    icon="i-heroicons-plus"
                                    color="neutral"
                                    variant="soft"
                                    @click="addArea"
                                />
                            </div>
                        </div>
                    </UFormField>

                    <UFormField label="Sektor">
                        <div class="flex gap-2 w-full">
                            <USelectMenu
                                v-model="sectorId"
                                :items="sectors"
                                value-key="id"
                                label-key="name"
                                placeholder="Vyber sektor"
                                :disabled="!areaId"
                                class="flex-1"
                            />
                            <div class="flex-none">
                                <UButton
                                    icon="i-heroicons-plus"
                                    color="neutral"
                                    variant="soft"
                                    :disabled="!areaId"
                                    @click="addSector"
                                />
                            </div>
                        </div>
                    </UFormField>

                    <UFormField label="Kameň (Boulder)">
                        <div class="flex gap-2 w-full">
                            <USelectMenu
                                v-model="boulderId"
                                :items="boulders"
                                value-key="id"
                                label-key="name"
                                placeholder="Vyber kameň"
                                :disabled="!sectorId"
                                class="flex-1"
                            />
                            <div class="flex-none">
                                <UButton
                                    icon="i-heroicons-plus"
                                    color="neutral"
                                    variant="soft"
                                    :disabled="!sectorId"
                                    @click="addBoulder"
                                />
                            </div>
                        </div>
                    </UFormField>

                    <UFormField label="Cesta na úpravu">
                        <div class="flex gap-2 w-full">
                            <USelectMenu
                                v-model="climbId"
                                :items="climbs"
                                value-key="id"
                                label-key="name"
                                placeholder="Vytvoriť novú alebo vybrať na úpravu"
                                :disabled="!boulderId"
                                class="flex-1"
                            />
                            <div class="flex-none">
                                <UButton
                                    icon="i-heroicons-plus"
                                    color="neutral"
                                    variant="soft"
                                    :disabled="!boulderId"
                                    @click="resetForNewClimb"
                                />
                            </div>
                        </div>
                    </UFormField>
                </div>
            </div>

            <SDivider class="my-6"/>

            <template v-if="boulderId && !imageUrl">
                <UFormField
                    label="Obrázok kameňa"
                    description="Nahraj nový obrázok pre kameň"
                >
                    <UInput
                        type="file"
                        @change="handleImageUpload"
                        icon="i-heroicons-arrow-up-tray"
                        accept="image/*"
                    />
                </UFormField>

                <SDivider class="my-6"/>
            </template>

            <div>
                <h2 class="text-lg font-semibold text-primary-500 mb-3">
                    Detaily cesty
                </h2>
                <div class="space-y-4">
                    <UFormField label="Názov cesty">
                        <UInput
                            v-model="name"
                            placeholder="napr., Burden of Dreams"
                            icon="i-heroicons-tag"
                        />
                    </UFormField>

                    <UFormField label="Popis cesty">
                        <UTextarea
                            v-model="description"
                            placeholder="Podrobný popis cesty, štýl, tipy..."
                            :rows="3"
                        />
                    </UFormField>

                    <UFormField label="Video (URL)">
                        <UInput
                            v-model="videoUrl"
                            type="url"
                            placeholder="https://www.youtube.com/watch?v=…"
                            icon="i-heroicons-play"
                        />
                    </UFormField>

                    <UFormField label="Obtiažnosť">
                        <USelectMenu
                            v-model="gradeId"
                            :items="availableGrades"
                            value-key="id"
                            label-key="font"
                            placeholder="Vyber obtiažnosť"
                        />
                    </UFormField>

                    <UCheckbox
                        v-model="isSitStart"
                        name="isSitStart"
                        label="Sit štart"
                    />
                    <UCheckbox
                        v-model="isDangerous"
                        name="isDangerous"
                        label="Nebezpečné (zlý dopad, medvede...)"
                    />
                </div>
            </div>

            <SDivider class="my-6"/>

            <div>
                <h2 class="text-lg font-semibold text-primary-500 mb-3">
                    Režim kreslenia
                </h2>
                <div class="grid grid-cols-3 gap-2 mb-2">
                    <UButton
                        :variant="mode === 'start' ? 'solid' : 'outline'"
                        color="primary"
                        @click="mode = 'start'"
                        icon="i-heroicons-map-pin"
                        label="Štart"
                    />
                    <UButton
                        :variant="mode === 'top' ? 'solid' : 'outline'"
                        color="error"
                        @click="mode = 'top'"
                        icon="i-heroicons-flag"
                        label="Top"
                    />
                    <UButton
                        :variant="mode === 'path' ? 'solid' : 'outline'"
                        color="info"
                        @click="mode = 'path'"
                        icon="i-heroicons-pencil-square"
                        label="Cesta"
                    />
                </div>
                <UButton
                    block
                    color="neutral"
                    variant="soft"
                    @click="clearDrawing"
                    icon="i-heroicons-trash"
                >
                    Vymazať cestu
                </UButton>
            </div>

            <SDivider class="my-6"/>

            <UTooltip
                :delay-duration="0"
                text="Zatiaľ iba na skúšku"
                :disabled="isDev"
            >
                <UButton
                    block
                    size="lg"
                    color="primary"
                    icon="i-heroicons-cloud-arrow-up"
                    :disabled="!isDev"
                    @click="$emit('save')"
                >
                    Uložiť zmeny
                </UButton>
            </UTooltip>
        </div>
    </UCard>
</template>

<script
    setup
    lang="ts"
>
import {onMounted, ref, watch} from 'vue';
import type {Database} from '~/types/database.types';
import SDivider from "~/components/super/SDivider.vue";
import type {PathDrawingModeType} from "~/components/editor/Canvas.vue";

const isDev = import.meta.dev
type Grade = Database['public']['Tables']['grades']['Row'];

defineProps<{
    availableGrades: Grade[];
}>();

// Form a kresliace modely
const imageUrl = defineModel<string>('imageUrl', {default: ''});
const name = defineModel<string>('name', {default: ''});
const description = defineModel<string>('description');
const videoUrl = defineModel<string>('videoUrl');
const gradeId = defineModel<number>('gradeId');
const isSitStart = defineModel<boolean>('isSitStart', {default: false});
const isDangerous = defineModel<boolean>('isDangerous', {default: false});
const mode = defineModel<PathDrawingModeType>('mode');

const startPos = defineModel<{ x: number, y: number } | null>('startPos', {default: null});
const topPos = defineModel<{ x: number, y: number } | null>('topPos', {default: null});
const pathPoints = defineModel<{ x: number, y: number }[]>('pathPoints', {default: () => []});

// Kaskádové lokalizačné modely
const areaId = defineModel<string | null>('areaId', {default: null});
const sectorId = defineModel<string | null>('sectorId', {default: null});
const boulderId = defineModel<string | null>('boulderId', {default: null});
const climbId = defineModel<string | null>('climbId', {default: null});

const client = useSupabaseClient<Database>();
const {parsePathString} = useTopoPath();

defineEmits(['save', 'newClimb']);

// Lokálne zoznamy pre selekty
const areas = ref<any[]>([]);
const sectors = ref<any[]>([]);
const boulders = ref<any[]>([]);
const climbs = ref<any[]>([]);

// Predvýber z URL (?area=&sector=&boulder=) – odkaz „Upraviť“ na stránke oblasti
const {query} = useRoute();
const preselect = {
    sector: typeof query.sector === 'string' ? query.sector : null,
    boulder: typeof query.boulder === 'string' ? query.boulder : null,
};

// Načítanie základných oblastí pri štarte
onMounted(async () => {
    const {data} = await client.from('areas').select('*').order('name');
    areas.value = data || [];

    if (typeof query.area === 'string') areaId.value = query.area;
});

// Kaskádové sledovanie zmien (Kaskáda)
watch(areaId, async (newAreaId) => {
    sectorId.value = null;
    boulders.value = [];
    climbs.value = [];
    if (!newAreaId) {
        sectors.value = [];
        return;
    }
    const {data} = await client.from('sectors').select('*').eq('area_id', newAreaId).order('name');
    sectors.value = data || [];

    if (preselect.sector) {
        sectorId.value = preselect.sector;
        preselect.sector = null;
    }
});

watch(sectorId, async (newSectorId) => {
    boulderId.value = null;
    climbs.value = [];
    if (!newSectorId) {
        boulders.value = [];
        return;
    }
    const {data} = await client.from('boulders').select('*').eq('sector_id', newSectorId).order('name');
    boulders.value = data || [];

    if (preselect.boulder) {
        boulderId.value = preselect.boulder;
        preselect.boulder = null;
    }
});

watch(boulderId, async (newBoulderId) => {
    climbId.value = null;
    if (!newBoulderId) {
        climbs.value = [];
        imageUrl.value = '';
        return;
    }
    const current = boulders.value.find(b => b.id === newBoulderId);
    imageUrl.value = current?.image_url || '';

    const {data} = await client.from('climbs').select('*').eq('boulder_id', newBoulderId).order('name');
    climbs.value = data || [];
});

// Automatické predvyplnenie formulára pri výbere existujúcej cesty
watch(climbId, (id) => {
    if (!id) {
        resetFormFields();
        return;
    }
    const currentClimb = climbs.value.find(c => c.id === id);
    if (currentClimb) {
        name.value = currentClimb.name || '';
        description.value = currentClimb.description || '';
        videoUrl.value = currentClimb.video_url || '';
        gradeId.value = currentClimb.grade_id;
        isSitStart.value = currentClimb.is_sit_start || false;
        isDangerous.value = currentClimb.is_dangerous || false;

        if (currentClimb.start_x !== null && currentClimb.start_y !== null) {
            startPos.value = {x: currentClimb.start_x, y: currentClimb.start_y};
        }
        if (currentClimb.top_x !== null && currentClimb.top_y !== null) {
            topPos.value = {x: currentClimb.top_x, y: currentClimb.top_y};
        }
        pathPoints.value = parsePathString(currentClimb.topo_path);
    }
});

// Pridávanie nových záznamov cez prompt okná
const addArea = async () => {
    const nameInput = prompt('Zadaj názov novej oblasti:');
    if (!nameInput) return;
    const {data, error} = await client.from('areas').insert({name: nameInput}).select().single();
    if (error) alert(error.message);
    else if (data) {
        areas.value.push(data);
        areaId.value = data.id;
    }
};

const addSector = async () => {
    if (!areaId.value) return alert('Najskôr musíš vybrať oblasť!');
    const nameInput = prompt('Zadaj názov nového sektoru:');
    if (!nameInput) return;
    const {data, error} = await client.from('sectors').insert({
        name: nameInput,
        area_id: areaId.value
    }).select().single();
    if (error) alert(error.message);
    else if (data) {
        sectors.value.push(data);
        sectorId.value = data.id;
    }
};

const addBoulder = async () => {
    if (!sectorId.value) return alert('Najskôr musíš vybrať sektor!');
    const nameInput = prompt('Zadaj názov nového kameňa:');
    if (!nameInput) return;
    const {data, error} = await client.from('boulders').insert({
        name: nameInput,
        sector_id: sectorId.value
    }).select().single();
    if (error) alert(error.message);
    else if (data) {
        boulders.value.push(data);
        boulderId.value = data.id;
    }
};

const clearDrawing = () => {
    startPos.value = null;
    topPos.value = null;
    pathPoints.value = [];
};

const resetFormFields = () => {
    name.value = '';
    description.value = '';
    videoUrl.value = '';
    gradeId.value = undefined;
    isSitStart.value = false;
    isDangerous.value = false;
    clearDrawing();
};

const resetForNewClimb = () => {
    climbId.value = null;
    resetFormFields();
};

const handleImageUpload = async (event: Event) => {
    const input = event.target as HTMLInputElement;
    if (!input.files || input.files.length === 0) return;

    const [file] = input.files;
    if (!file) return;

    const fileExt = file.name.split('.').pop();
    const fileName = `${Date.now()}-${Math.random().toString(36).substring(2, 9)}.${fileExt}`;

    try {
        const {data, error} = await client.storage
            .from('boulder-photos')
            .upload(fileName, file);

        if (error) throw error;

        const {data: publicUrlData} = client.storage.from('boulder-photos').getPublicUrl(data.path);
        imageUrl.value = publicUrlData.publicUrl;

        // Okamžitá aktualizácia pre vybraný boulder v DB
        if (boulderId.value) {
            await client.from('boulders').update({image_url: publicUrlData.publicUrl}).eq('id', boulderId.value);
            const current = boulders.value.find(b => b.id === boulderId.value);
            if (current) current.image_url = publicUrlData.publicUrl;
        }
    } catch (error: any) {
        alert(`Image upload failed: ${error.message}`);
        console.error('Image upload error:', error);
    } finally {
        input.value = '';
    }
}
</script>
