<template>
    <header class="relative z-30">
        <SInstallBanner/>

        <div
            class="flex justify-between items-center pointer-events-auto bg-white px-4 py-2"
        >
            <NuxtLink
                to="/"
                class="flex items-center gap-2 group text-neutral-900"
            >
                <span
                    aria-hidden="true"
                    class="size-6 shrink-0 bg-current mask-[url(/superskala-full.svg)] mask-contain mask-no-repeat mask-center"
                ></span>
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
                    :active="isSearchOpen"
                    color="neutral"
                    variant="ghost"
                    active-variant="soft"
                    class="rounded-full"
                    @click="isSearchOpen = !isSearchOpen"
                />

                <UButton
                    to="/"
                    :active="isMapShown"
                    icon="i-heroicons-map"
                    aria-label="Mapa"
                    color="neutral"
                    variant="ghost"
                    active-variant="soft"
                    class="rounded-full"
                />

                <UButton
                    to="/info"
                    icon="i-heroicons-information-circle"
                    aria-label="O projekte"
                    color="neutral"
                    variant="ghost"
                    active-variant="soft"
                    class="rounded-full"
                />
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
import {computed, nextTick, ref, watch} from 'vue'
import SInstallBanner from '~/components/super/SInstallBanner.vue'
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

// Mapu vidno aj na stránke oblasti, preto je ikona aktívna aj tam
const isMapShown = computed(() => route.path === '/' || route.path.startsWith('/area/'))

watch(() => route.fullPath, () => isSearchOpen.value = false)
</script>
