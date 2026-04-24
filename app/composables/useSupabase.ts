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
     * Fetches climbs with their related boulder, sector, and grade information for map display.
     * @returns An array of climbs with nested data.
     */
    async function getClimbsForMap() {
        loading.value = true;
        error.value = null;

        // Define the exact shape of the data we want to fetch
        type ClimbForMap = Database['public']['Tables']['climbs']['Row'] & {
            grade: Database['public']['Tables']['grades']['Row'] | null;
            boulder_id: (Database['public']['Tables']['boulders']['Row'] & {
                sectors: Database['public']['Tables']['sectors']['Row'] | null;
            }) | null;
        };

        const {data, error: err} = await client
            .from('climbs')
            .select(`
        id,
        name,
        topo_path,
        description,
        is_sit_start,
        is_dangerous,
        lat,
        lon,
        start_x,
        start_y,
        top_x,
        top_y,
        grade_id (
          font,
          value
        ),
        boulder_id (
          id,
          name,
          image_url,
          lat,
          lon,
          sector_id (
            id,
            name,
            lat,
            lon
          )
        )
      `)
            .returns<ClimbForMap[]>(); // Explicitly cast the return type

        loading.value = false;

        if (err) {
            error.value = err.message;
            console.error('Error fetching climbs for map:', err);
            return [];
        }

        return data || [];
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
        getClimbsForMap,
        getSectorsWithDetails, // Keep existing
        loading,
        sectors, // Keep existing
        supabase: client, // Expose client directly
        uploadBoulderImage,
    };
}
