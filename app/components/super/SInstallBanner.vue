<template>
    <div
        v-if="isShown"
        class="flex items-start gap-3 bg-neutral-900 px-4 py-2 text-sm text-white"
    >
        <UIcon
            name="i-heroicons-device-phone-mobile"
            class="mt-0.5 size-5 shrink-0"
        />

        <p class="flex-1">
            Pridaj si Superskaly na plochu a otváraj ich ako appku, aj bez signálu. {{ hint }}
        </p>

        <button
            type="button"
            class="shrink-0 rounded p-0.5 focus-visible:outline-2 focus-visible:outline-white"
            aria-label="Zavrieť tip"
            @click="isDismissed = true"
        >
            <UIcon
                name="i-heroicons-x-mark"
                class="block size-5"
            />
        </button>
    </div>
</template>

<script
    setup
    lang="ts"
>
import {computed} from 'vue'
import {useLocalStorage, useMediaQuery} from '@vueuse/core'

// Appka je len klientská (ssr: false), navigator je teda vždy k dispozícii
const isIos = /iPhone|iPad|iPod/.test(navigator.userAgent)
// Na iPhone sa dá appka pridať na plochu len zo Safari; ostatné prehliadače (Brave…) majú navigator.standalone nedefinované
const isMobile = isIos ? 'standalone' in navigator : /Android/.test(navigator.userAgent)
// Už nainštalovaná appka beží v samostatnom okne, tam tip nedáva zmysel
const isInstalled = useMediaQuery('(display-mode: standalone)')
// flush: 'sync', inak by zápis po zavretí tipu nemusel prebehnúť
const isDismissed = useLocalStorage('superskala-install-tip', false, {flush: 'sync'})

const isShown = computed(() => isMobile && !isInstalled.value && !isDismissed.value)

const hint = isIos
    ? 'V Safari ťukni na „Zdieľať“ a vyber „Pridať na plochu“.'
    : 'V prehliadači ťukni na menu ⋮ a vyber „Inštalovať aplikáciu“ alebo „Pridať na plochu“.'
</script>
