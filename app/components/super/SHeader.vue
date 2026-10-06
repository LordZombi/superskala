<template>
    <header class="relative z-30">
        <div
            class="flex justify-between items-center pointer-events-auto bg-white px-4 py-2"
        >
            <NuxtLink
                to="/"
                class="flex items-center gap-2 group"
            >
                <h1 class="text-xl font-bold">
                    Superskaly
                </h1>
            </NuxtLink>

            <div class="flex items-center gap-2">
                <UButton
                    id="search-toggle"
                    icon="i-heroicons-magnifying-glass"
                    aria-label="Hľadať"
                    :aria-expanded="isSearchOpen"
                    color="neutral"
                    variant="ghost"
                    class="rounded-full"
                    @click="isSearchOpen = !isSearchOpen"
                />

                <UButton
                    to="/"
                    icon="i-heroicons-map"
                    aria-label="Mapa"
                    color="neutral"
                    variant="ghost"
                    class="rounded-full"
                />

                <UButton
                    to="/admin/editor"
                    icon="i-heroicons-pencil"
                    aria-label="Topo editor"
                    color="neutral"
                    variant="ghost"
                    class="rounded-full"
                />

                <UButton
                    to="/info"
                    icon="i-heroicons-information-circle"
                    aria-label="O projekte"
                    color="neutral"
                    variant="ghost"
                    class="rounded-full"
                />

                <UColorModeButton/>
            </div>
        </div>

        <SSearch
            v-if="isSearchOpen"
            @close="closeSearch"
        />
    </header>
</template>

<script
    setup
    lang="ts"
>
import {nextTick, ref, watch} from 'vue'
import SSearch from '~/components/super/SSearch.vue'

const route = useRoute()
const isSearchOpen = ref(false)

const closeSearch = async () => {
    isSearchOpen.value = false
    // Fokus sa vráti na tlačidlo, inak by po zavretí ostal stratený
    await nextTick()
    // Cez id: koreň UButton nie je samotný <button>, $el.focus() preto padal
    document.getElementById('search-toggle')?.focus()
}

watch(() => route.fullPath, () => isSearchOpen.value = false)
</script>
