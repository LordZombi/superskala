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
                                    :to="appLinks.area || undefined"
                                    :disabled="!appLinks.area"
                                    target="_blank"
                                    icon="i-heroicons-arrow-top-right-on-square"
                                    color="neutral"
                                    variant="soft"
                                    aria-label="Otvoriť oblasť v appke (nové okno)"
                                />
                            </div>
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
                                    :to="appLinks.sector || undefined"
                                    :disabled="!appLinks.sector"
                                    target="_blank"
                                    icon="i-heroicons-arrow-top-right-on-square"
                                    color="neutral"
                                    variant="soft"
                                    aria-label="Otvoriť sektor v appke (nové okno)"
                                />
                            </div>
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
                                    :to="appLinks.boulder || undefined"
                                    :disabled="!appLinks.boulder"
                                    target="_blank"
                                    icon="i-heroicons-arrow-top-right-on-square"
                                    color="neutral"
                                    variant="soft"
                                    aria-label="Otvoriť kameň v appke (nové okno)"
                                />
                            </div>
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
                                    :to="appLinks.climb || undefined"
                                    :disabled="!appLinks.climb"
                                    target="_blank"
                                    icon="i-heroicons-arrow-top-right-on-square"
                                    color="neutral"
                                    variant="soft"
                                    aria-label="Otvoriť cestu v appke (nové okno)"
                                />
                            </div>
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

                    <fieldset>
                        <legend class="text-sm font-medium text-default mb-1">
                            GPS a popis
                        </legend>
                        <div class="grid grid-cols-3 gap-2">
                            <UButton
                                v-for="(level, key) in gpsLevels"
                                :key="key"
                                :variant="gpsTarget === key ? 'solid' : 'outline'"
                                color="neutral"
                                icon="i-heroicons-map-pin"
                                :label="level.label"
                                :disabled="!level.id"
                                :aria-pressed="gpsTarget === key"
                                @click="gpsTarget = gpsTarget === key ? undefined : key"
                            />
                        </div>
                    </fieldset>

                    <template v-if="gpsRow">
                        <MapView
                            v-model:pin="gpsPin"
                            v-model:outline="gpsOutline"
                            :drawing="isDrawing"
                            class="h-80 overflow-hidden rounded-md"
                            :points="gpsPoints"
                            :focus="gpsFocus"
                            permanent-labels
                            fit-to-points
                        />

                        <fieldset
                            v-if="gpsTarget !== 'boulder'"
                            class="flex flex-wrap items-center gap-2"
                        >
                            <legend class="sr-only">
                                Obrys – {{ gpsRow.name }}
                            </legend>
                            <UButton
                                :variant="isDrawing ? 'solid' : 'outline'"
                                color="neutral"
                                icon="i-heroicons-pencil"
                                label="Kresliť obrys"
                                :aria-pressed="isDrawing"
                                @click="isDrawing = !isDrawing"
                            />
                            <UButton
                                variant="outline"
                                color="neutral"
                                label="Späť o bod"
                                :disabled="!gpsOutline?.length"
                                @click="gpsOutline = gpsOutline!.slice(0, -1)"
                            />
                            <UButton
                                variant="outline"
                                color="neutral"
                                label="Zmazať obrys"
                                :disabled="!gpsOutline?.length"
                                @click="gpsOutline = null"
                            />
                            <p
                                v-if="isDrawing"
                                class="w-full text-sm text-muted"
                            >
                                Klikaj do mapy po obvode (aspoň 3 body), body sa dajú ťahať.
                            </p>
                        </fieldset>

                        <UFormField
                            :label="`Súradnice – ${gpsRow.name}`"
                            description="Klikni do mapy, potiahni špendlík alebo vlož „lat, lon“. Prázdne pole GPS zmaže."
                        >
                            <UInput
                                v-model.lazy="gpsText"
                                placeholder="48.611123, 17.576012"
                                icon="i-heroicons-map-pin"
                            />
                        </UFormField>

                        <UFormField :label="`Popis – ${gpsRow.name}`">
                            <UTextarea
                                v-model="gpsDescription"
                                placeholder="Prístup, parkovanie, charakter skaly..."
                                :rows="3"
                            />
                        </UFormField>

                        <UButton
                            block
                            label="Uložiť GPS a popis"
                            @click="saveGpsAndDescription"
                        />
                    </template>
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
                    <UFormField label="Názov cesty" required>
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
                    Kreslenie cesty
                </h2>
                <p class="text-sm text-neutral-600 mb-3">
                    Klik do fotky pridá bod, ťahaním ho presunieš, dvojklikom ho odstrániš.
                    Z klávesnice: šípky bod posúvajú, Delete ho odstráni.
                </p>
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

            <UButton
                block
                size="lg"
                color="primary"
                icon="i-heroicons-cloud-arrow-up"
                :disabled="!name.trim()"
                @click="$emit('save')"
            >
                Uložiť zmeny
            </UButton>

            <UModal
                v-model:open="confirmDelete"
                title="Zmazať cestu?"
                :description="`${name.trim() ? `Cesta „${name}“` : 'Táto cesta'} sa natrvalo odstráni z databázy.`"
                :close="{class: 'w-auto'}"
            >
                <UButton
                    v-if="climbId"
                    block
                    class="mt-3"
                    color="error"
                    variant="soft"
                    icon="i-heroicons-trash"
                >
                    Zmazať cestu z databázy
                </UButton>
                <template #footer="{close}">
                    <div class="flex justify-end gap-2 w-full">
                        <UButton
                            class="w-auto"
                            color="neutral"
                            variant="outline"
                            @click="close"
                        >
                            Zrušiť
                        </UButton>
                        <UButton
                            class="w-auto"
                            color="error"
                            @click="onDelete"
                        >
                            Zmazať
                        </UButton>
                    </div>
                </template>
            </UModal>
        </div>
    </UCard>
</template>

<script
    setup
    lang="ts"
>
import {computed, onMounted, ref, watch} from 'vue';
import type {Database} from '~/types/database.types';
import MapView, {type MapFocus, type MapPoint, type Outline} from '~/components/MapView.vue';
import SDivider from "~/components/super/SDivider.vue";
import {UModal} from '#components';

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

const pathPoints = defineModel<{ x: number, y: number }[]>('pathPoints', {default: () => []});

// Kaskádové lokalizačné modely
const areaId = defineModel<string | null>('areaId', {default: null});
const sectorId = defineModel<string | null>('sectorId', {default: null});
const boulderId = defineModel<string | null>('boulderId', {default: null});
const climbId = defineModel<string | null>('climbId', {default: null});

const client = useSupabaseClient<Database>();
const toast = useToast();
const {parsePathString} = useTopoPath();

const emit = defineEmits(['save', 'newClimb', 'delete']);

const confirmDelete = ref(false);
const onDelete = () => {
    confirmDelete.value = false;
    emit('delete');
};

// Lokálne zoznamy pre selekty
const areas = ref<any[]>([]);
const sectors = ref<any[]>([]);
const boulders = ref<any[]>([]);
const climbs = ref<any[]>([]);

// Predvýber z URL (?area=&sector=&boulder=&climb=) – odkazy „Upraviť“ pri kameni a v detaile cesty
const {query} = useRoute();
const preselect = {
    sector: typeof query.sector === 'string' ? query.sector : null,
    boulder: typeof query.boulder === 'string' ? query.boulder : null,
    climb: typeof query.climb === 'string' ? query.climb : null,
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

    if (preselect.climb) {
        climbId.value = preselect.climb;
        preselect.climb = null;
    }
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

        pathPoints.value = parsePathString(currentClimb.topo_path);
    }
});

// Odkazy do verejnej appky, nech sa výsledok dá rovno pozrieť; kameň vedie na svoju prvú cestu
const appLinks = computed(() => ({
    area: areaId.value && `/area/${areaId.value}`,
    sector: areaId.value && sectorId.value && `/area/${areaId.value}?sector=${sectorId.value}`,
    boulder: areaId.value && climbs.value[0] && `/area/${areaId.value}?climb=${climbs.value[0].id}`,
    climb: areaId.value && climbId.value && `/area/${areaId.value}?climb=${climbId.value}`,
}));

// --- GPS a popis: špendlík na mape a text pre vybranú oblasť, sektor alebo kameň ---
type GpsTarget = 'area' | 'sector' | 'boulder';
const hasGps = (row?: any) => row?.lat != null && row?.lon != null;

const gpsTarget = ref<GpsTarget>();
const gpsPin = ref<Pick<MapFocus, 'lat' | 'lon'> | null>(null);
const gpsFocus = ref<MapFocus | null>(null);
const gpsDescription = ref('');
// Obrys má oblasť a sektor (kameň nie); kreslí sa klikaním do mapy
const gpsOutline = ref<Outline | null>(null);
const isDrawing = ref(false);

// Poradie od najširšej úrovne; zoom sedí s tým, ako sa na ne približuje stránka oblasti
const gpsLevels = computed(() => ({
    area: {label: 'Oblasť', table: 'areas' as const, rows: areas.value, id: areaId.value, zoom: 13},
    sector: {label: 'Sektor', table: 'sectors' as const, rows: sectors.value, id: sectorId.value, zoom: 17},
    boulder: {label: 'Kameň', table: 'boulders' as const, rows: boulders.value, id: boulderId.value, zoom: 18},
}));
const selectedRow = (key: GpsTarget) => gpsLevels.value[key].rows.find(row => row.id === gpsLevels.value[key].id);
const gpsRow = computed(() => gpsTarget.value && selectedRow(gpsTarget.value));

// Ostatné body tej istej úrovne, nech je podľa čoho sa na mape orientovať
const gpsPoints = computed<MapPoint[]>(() => !gpsTarget.value ? [] : gpsLevels.value[gpsTarget.value].rows
    .filter(row => row !== gpsRow.value && hasGps(row))
    .map(row => ({id: row.id, lat: row.lat, lon: row.lon, label: row.name, outline: ('outline' in row ? row.outline ?? undefined : undefined) as Outline | undefined})));

// Len pri zmene záznamu, nie pri každom posune špendlíka – inak by mapa stále odlietala
watch(gpsRow, (row) => {
    if (!row || !gpsTarget.value) return;

    gpsPin.value = hasGps(row) ? {lat: row.lat, lon: row.lon} : null;
    gpsOutline.value = ('outline' in row ? row.outline ?? null : null) as Outline | null;
    isDrawing.value = false;
    gpsDescription.value = row.description || '';

    // Bez vlastnej GPS sa mapa priblíži na najbližšiu nadradenú úroveň, ktorá ju má
    const keys = Object.keys(gpsLevels.value) as GpsTarget[];
    const near = keys.slice(0, keys.indexOf(gpsTarget.value) + 1).reverse().find(key => hasGps(selectedRow(key)));
    const nearRow = near && selectedRow(near);
    gpsFocus.value = near ? {lat: nearRow.lat, lon: nearRow.lon, zoom: gpsLevels.value[near].zoom} : null;
});

// Alternatíva ku klikaniu do mapy: „lat, lon“ sa dá napísať alebo vložiť (.lazy, aby sa neprepisovalo počas písania)
const gpsText = computed({
    get: () => gpsPin.value ? `${gpsPin.value.lat}, ${gpsPin.value.lon}` : '',
    set: (text: string) => {
        if (!text.trim()) {
            gpsPin.value = null;
            return;
        }
        const [lat, lon] = text.trim().split(/[\s,;]+/).map(Number);
        if (lat !== undefined && lon !== undefined && Math.abs(lat) <= 90 && Math.abs(lon) <= 180) gpsPin.value = {lat, lon};
    },
});

const saveGpsAndDescription = async () => {
    const row = gpsRow.value;
    if (!row || !gpsTarget.value) return;

    // Obrys má zmysel od 3 bodov; bez špendlíka sa bod položí do jeho stredu, nech má sektor aj menovku a odkaz
    const outline = gpsTarget.value !== 'boulder' && gpsOutline.value && gpsOutline.value.length > 2 ? gpsOutline.value : null;
    const center = outline && !gpsPin.value
        ? {lat: +(outline.reduce((sum, [lat]) => sum + lat, 0) / outline.length).toFixed(6), lon: +(outline.reduce((sum, [, lon]) => sum + lon, 0) / outline.length).toFixed(6)}
        : gpsPin.value;
    const coords = {
        lat: center?.lat ?? null,
        lon: center?.lon ?? null,
        // Prázdny popis ako null, stránka oblasti ho potom vôbec nevykreslí
        description: gpsDescription.value.trim() || null,
        // Kameň stĺpec obrysu nemá
        ...gpsTarget.value !== 'boulder' && {outline},
    };
    // select(): keď zápis zastaví RLS, Supabase nevráti chybu, len žiadny riadok
    const {data, error} = await client.from(gpsLevels.value[gpsTarget.value].table).update(coords).eq('id', row.id).select('id');
    if (error || !data?.length) toast.add({title: 'Uloženie zlyhalo', description: error?.message ?? 'Databáza zápis nepovolila', color: 'error'});
    else {
        // Lokálny zoznam sa znova nenačítava, tak nech sedí s DB
        Object.assign(row, coords);
        gpsPin.value = center;
        toast.add({title: 'GPS a popis uložené', description: row.name, color: 'success'});
    }
};

// Pridávanie nových záznamov cez prompt okná
const addArea = async () => {
    const nameInput = prompt('Zadaj názov novej oblasti:');
    if (!nameInput) return;
    const {data, error} = await client.from('areas').insert({name: nameInput}).select().single();
    if (error) toast.add({title: 'Uloženie zlyhalo', description: error.message, color: 'error'});
    else if (data) {
        areas.value.push(data);
        areaId.value = data.id;
    }
};

const addSector = async () => {
    if (!areaId.value) return toast.add({title: 'Najskôr vyber oblasť', color: 'warning'});
    const nameInput = prompt('Zadaj názov nového sektoru:');
    if (!nameInput) return;
    const {data, error} = await client.from('sectors').insert({
        name: nameInput,
        area_id: areaId.value
    }).select().single();
    if (error) toast.add({title: 'Uloženie zlyhalo', description: error.message, color: 'error'});
    else if (data) {
        sectors.value.push(data);
        sectorId.value = data.id;
    }
};

const addBoulder = async () => {
    if (!sectorId.value) return toast.add({title: 'Najskôr vyber sektor', color: 'warning'});
    const nameInput = prompt('Zadaj názov nového kameňa:');
    if (!nameInput) return;
    const {data, error} = await client.from('boulders').insert({
        name: nameInput,
        sector_id: sectorId.value
    }).select().single();
    if (error) toast.add({title: 'Uloženie zlyhalo', description: error.message, color: 'error'});
    else if (data) {
        boulders.value.push(data);
        boulderId.value = data.id;
    }
};

const clearDrawing = () => {
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
        toast.add({title: 'Nahranie fotky zlyhalo', description: error.message, color: 'error'});
        console.error('Image upload error:', error);
    } finally {
        input.value = '';
    }
}
</script>
