<template>
    <div
        role="search"
        class="absolute inset-x-0 top-full z-30 max-h-[70dvh] overflow-y-auto overscroll-contain bg-white px-4 pb-4 shadow-lg"
        @keydown.esc="emit('close')"
    >
        <UInput
            v-model="query"
            type="search"
            icon="i-heroicons-magnifying-glass"
            size="lg"
            autofocus
            placeholder="Hľadaj cestu, sektor alebo oblasť"
            aria-label="Hľadať cestu, sektor alebo oblasť"
            @keydown.enter="remember"
        />

        <p
            role="status"
            class="sr-only"
        >
            <template v-if="term && index">Počet výsledkov: {{ results.length }}</template>
        </p>

        <template v-if="!term">
            <div
                v-if="history.queries.length"
                class="mt-4 space-y-2"
            >
                <h2 class="text-xs font-black uppercase text-slate-600">Posledné hľadania</h2>
                <div class="flex flex-wrap gap-2">
                    <UButton
                        v-for="past in history.queries"
                        :key="past"
                        :label="past"
                        icon="i-heroicons-clock"
                        color="neutral"
                        variant="soft"
                        size="sm"
                        class="w-auto"
                        @click="query = past"
                    />
                </div>
            </div>

            <h2
                v-if="history.visited.length"
                class="mt-4 text-xs font-black uppercase text-slate-600"
            >
                Naposledy navštívené
            </h2>
        </template>

        <ul
            v-if="shown.length"
            class="mt-2 divide-y divide-neutral-200"
        >
            <li
                v-for="item in shown"
                :key="item.type + item.id"
            >
                <NuxtLink
                    :to="item.to"
                    class="flex items-center justify-between gap-3 py-2.5"
                    @click="visit(item)"
                >
                    <span class="min-w-0">
                        <span class="block truncate font-medium">{{ item.name }}</span>
                        <span class="block truncate text-xs text-slate-600">{{ item.detail }}</span>
                    </span>
                    <UBadge
                        v-if="item.grade"
                        color="primary"
                        variant="solid"
                        class="shrink-0 w-auto"
                    >
                        {{ item.grade }}
                    </UBadge>
                </NuxtLink>
            </li>
        </ul>

        <div
            v-else-if="term && index"
            class="mt-4 flex items-center justify-between gap-3"
        >
            <p class="font-medium">Nenašiel si boulder?</p>
            <UButton
                to="/info"
                label="Ozvi sa"
                color="primary"
                class="w-auto"
                @click="emit('close')"
            />
        </div>

        <UButton
            v-if="!term && (history.queries.length || history.visited.length)"
            label="Vymazať históriu"
            icon="i-heroicons-trash"
            color="neutral"
            variant="ghost"
            size="xs"
            class="mt-3 w-auto"
            @click="history = {queries: [], visited: []}"
        />
    </div>
</template>

<script
    setup
    lang="ts"
>
import {computed, onMounted, ref} from 'vue'
import {refDebounced, useLocalStorage} from '@vueuse/core'
import {useSupabase, type SearchItem} from '~/composables/useSupabase'

const emit = defineEmits<{
    close: []
}>()

const MAX_RESULTS = 20

const {getSearchIndex} = useSupabase()
// Index prežije zatvorenie hľadania, takže výsledky sú hneď; pri každom otvorení sa na pozadí obnoví
const index = useState<SearchItem[] | null>('searchIndex', () => null)
// flush: 'sync' – zápis po kliknutí na výsledok musí prebehnúť hneď; s predvoleným odloženým zápisom ho zahodí zatvorenie hľadania
// (SSearch sa odmontuje skôr, než sa zápis stihne), takže história ostávala prázdna
const history = useLocalStorage('superskala-search', {queries: [] as string[], visited: [] as SearchItem[]}, {flush: 'sync'})

const query = ref('')
const debouncedQuery = refDebounced(query, 200)

// Bez diakritiky a veľkosti písmen: „co ja“ nájde „Čó ja?“
const normalize = (text: string) => text.normalize('NFD').replace(/\p{M}/gu, '').toLowerCase().trim()

const term = computed(() => normalize(debouncedQuery.value))

const keyed = computed(() => (index.value ?? []).map(item => ({item, key: normalize(item.name)})))

const results = computed(() => keyed.value
    .filter(({key}) => key.includes(term.value))
    // Názvy začínajúce hľadaným výrazom idú pred zhody uprostred
    .sort((a, b) => Number(b.key.startsWith(term.value)) - Number(a.key.startsWith(term.value)))
    .slice(0, MAX_RESULTS)
    .map(({item}) => item))

const shown = computed(() => term.value ? results.value : history.value.visited)

// Najnovšie dopredu, bez duplicít
const pushRecent = <T>(list: T[], entry: T, isSame: (other: T) => boolean, max: number) =>
    [entry, ...list.filter(other => !isSame(other))].slice(0, max)

const remember = () => {
    const text = query.value.trim()
    if (text) history.value.queries = pushRecent(history.value.queries, text, other => other === text, 5)
}

const visit = (item: SearchItem) => {
    remember()
    history.value.visited = pushRecent(history.value.visited, item,
        other => other.type === item.type && other.id === item.id, 8)
    emit('close')
}

onMounted(async () => {
    const fresh = await getSearchIndex()
    // Prázdna odpoveď je výpadok siete, nie zmazaná databáza – starý index si necháme
    if (fresh.length || !index.value) index.value = fresh
})
</script>
