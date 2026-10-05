import {ref} from 'vue';
import type {Database} from '~/types/database.types';

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
            .select('id, name, lat, lon, sectors(lat, lon)');

        loading.value = false;

        if (err) {
            error.value = err.message;
            console.error('Error fetching areas for map:', err);
            return [];
        }

        return data || [];
    }

    /**
     * One area with its whole tree: sectors → boulders → climbs (with grade).
     */
    async function getAreaWithDetails(areaId: string) {
        loading.value = true;
        error.value = null;

        const {data, error: err} = await client
            .from('areas')
            .select('*, sectors(*, boulders(id, name, image_url, climbs(*, grade:grades(font, value))))')
            .eq('id', areaId)
            .maybeSingle();

        loading.value = false;

        if (err) {
            error.value = err.message;
            console.error('Error fetching area:', err);
            return null;
        }

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
        getSectorsWithDetails, // Keep existing
        loading,
        sectors, // Keep existing
        supabase: client, // Expose client directly
        uploadBoulderImage,
    };
}
