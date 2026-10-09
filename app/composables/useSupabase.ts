import {ref} from 'vue';
import type {Database} from '~/types/database.types';

export interface SearchItem {
    type: 'area' | 'sector' | 'climb'
    id: string
    name: string
    /** Second line of a result: where the item belongs */
    detail: string
    grade?: string
    to: string
}

// Poslednú úspešnú odpoveď si držíme aj v IndexedDB: bez siete (alebo keď prehliadač vymaže cache service workera) appka nezostane prázdna
const openSnapshots = () => new Promise<IDBDatabase>((resolve, reject) => {
    const request = indexedDB.open('superskala', 1);
    request.onupgradeneeded = () => request.result.createObjectStore('snapshots');
    request.onsuccess = () => resolve(request.result);
    request.onerror = () => reject(request.error);
});

export const readSnapshot = async <T>(key: string): Promise<T | null> => {
    try {
        const store = (await openSnapshots()).transaction('snapshots').objectStore('snapshots');

        return await new Promise<T | null>((resolve, reject) => {
            const request = store.get(key);
            request.onsuccess = () => resolve(request.result ?? null);
            request.onerror = () => reject(request.error);
        });
    } catch {
        return null;
    }
};

/** Vráti true, až keď je zápis v úložisku; bez IndexedDB ostane len cache service workera */
export const writeSnapshot = async (key: string, value: unknown) => {
    try {
        const transaction = (await openSnapshots()).transaction('snapshots', 'readwrite');

        transaction.objectStore('snapshots').put(value, key);

        return await new Promise<boolean>((resolve, reject) => {
            transaction.oncomplete = () => resolve(true);
            transaction.onerror = transaction.onabort = () => reject(transaction.error);
        });
    } catch {
        return false;
    }
};

export function useSupabase() {
    const client = useSupabaseClient<Database>();
    const sectors = ref<any>([]); // Keep existing for now, but consider typing
    const error = ref<string | null>(null);
    const loading = ref(false);

    // Existing function, potentially to be refactored or removed later
    async function getSectorsWithDetails() {
        loading.value = true;
        error.value = null;

        const {data, error: err} = await client
            .from('sectors')
            .select('*, areas(name), boulders(*, climbs(*))'); // Adjust select if needed based on new schema

        loading.value = false;

        if (err) {
            error.value = err.message;
            sectors.value = [];
            return [];
        }

        sectors.value = data ?? [];
        return sectors.value;
    }

    /**
     * Areas with their sector coordinates – one map marker per area.
     */
    async function getAreasForMap() {
        loading.value = true;
        error.value = null;

        const {data, error: err} = await client
            .from('areas')
            .select('id, name, lat, lon, outline, sectors(id, name, lat, lon, outline)');

        loading.value = false;

        if (err) {
            error.value = err.message;
            console.error('Error fetching areas for map:', err);
            return await readSnapshot<typeof data>('areas-map') ?? [];
        }

        writeSnapshot('areas-map', data);

        return data || [];
    }

    /**
     * Names of all areas, sectors and climbs for the client-side search.
     */
    async function getSearchIndex(): Promise<SearchItem[]> {
        const PAGE = 1000; // Supabase returns at most 1000 rows per request
        const climbs = [];
        let isFailed = false;

        for (let from = 0; ; from += PAGE) {
            const {data, error: err} = await client
                .from('climbs')
                .select('id, name, grade:grades(font), boulder:boulders(sector:sectors(area:areas(id, name)))')
                .order('name')
                .range(from, from + PAGE - 1);

            isFailed ||= !!err;
            climbs.push(...data ?? []);
            if ((data?.length ?? 0) < PAGE) break;
        }

        const {data: sectors, error: sectorsError} = await client
            .from('sectors')
            .select('id, name, area:areas(id, name)')
            .order('name');

        const {data: areas, error: areasError} = await client
            .from('areas')
            .select('id, name')
            .order('name');

        isFailed ||= !!sectorsError || !!areasError;

        const items: SearchItem[] = [
            ...(areas ?? []).map((area): SearchItem => ({
                type: 'area',
                id: area.id,
                name: area.name,
                detail: 'Oblasť',
                to: `/area/${area.id}`,
            })),
            ...(sectors ?? []).flatMap((sector): SearchItem[] => sector.area ? [{
                type: 'sector',
                id: sector.id,
                name: sector.name,
                detail: `Sektor • ${sector.area.name}`,
                to: `/area/${sector.area.id}?sector=${sector.id}`,
            }] : []),
            // Climbs outside of any area have no page to open
            ...climbs.flatMap((climb): SearchItem[] => {
                const area = climb.boulder?.sector?.area;

                return area ? [{
                    type: 'climb',
                    id: climb.id,
                    name: climb.name,
                    detail: area.name,
                    grade: climb.grade?.font,
                    to: `/area/${area.id}?climb=${climb.id}`,
                }] : [];
            }),
        ];

        if (isFailed) return await readSnapshot<SearchItem[]>('search-index') ?? items;

        writeSnapshot('search-index', items);

        return items;
    }

    /**
     * One area with its whole tree: sectors → boulders → climbs (with grade).
     */
    async function getAreaWithDetails(areaId: string) {
        loading.value = true;
        error.value = null;

        const {data, error: err} = await client
            .from('areas')
            .select('*, sectors(*, boulders(id, name, image_url, lat, lon, climbs(*, grade:grades(font, value))))')
            .eq('id', areaId)
            .maybeSingle();

        loading.value = false;

        if (err) {
            error.value = err.message;
            console.error('Error fetching area:', err);
            return await readSnapshot<typeof data>(`area:${areaId}`);
        }

        if (data) writeSnapshot(`area:${areaId}`, data);

        return data;
    }

    async function uploadBoulderImage(boulderId: string, file: File) {
        loading.value = true;
        error.value = null;

        const fileExt = file.name.split('.').pop();
        const fileName = `${boulderId}-${Math.random()}.${fileExt}`;
        const filePath = fileName;

        const { error: uploadError } = await client
            .storage
            .from('boulder-photos')
            .upload(filePath, file);

        if (uploadError) {
            error.value = uploadError.message;
            loading.value = false;
            return null;
        }

        const { data: { publicUrl } } = client
            .storage
            .from('boulder-photos')
            .getPublicUrl(filePath);

        const { error: updateError } = await client
            .from('boulders')
            .update({ image_url: publicUrl })
            .eq('id', boulderId);

        loading.value = false;

        if (updateError) {
            error.value = updateError.message;
            return null;
        }

        return publicUrl;
    }

    return {
        error,
        getAreasForMap,
        getAreaWithDetails,
        getSearchIndex,
        getSectorsWithDetails, // Keep existing
        loading,
        sectors, // Keep existing
        supabase: client, // Expose client directly
        uploadBoulderImage,
    };
}
