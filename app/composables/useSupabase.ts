import {ref} from 'vue';

export function useSupabase() {
    const client = useSupabaseClient()
    const sectors = ref<any>([]);
    const error = ref<string | null>(null);
    const loading = ref(false);

    async function getSectorsWithDetails() {
        loading.value = true;
        error.value = null;

        const {data, error: err} = await client
            .from('sectors')
            .select('*, areas(name), boulders(*, climbs(*))');

        loading.value = false;

        if (err) {
            error.value = err.message;
            sectors.value = [];
            return [];
        }

        sectors.value = data ?? [];
        return sectors.value;
    }

    return {
        sectors,
        error,
        loading,
        getSectorsWithDetails,
    };
}
