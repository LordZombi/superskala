<template>
    <UButton
        icon="i-heroicons-share"
        color="neutral"
        variant="soft"
        class="rounded-full shrink-0 w-auto"
        :aria-label="`Zdieľať: ${title}`"
        @click="onShare"
    />
</template>

<script
    setup
    lang="ts"
>
import {useClipboard, useShare} from '@vueuse/core'

const {title, path} = defineProps<{
    title: string
    /** Cesta v rámci apky, napr. /area/123 – doména sa doplní pri zdieľaní */
    path: string
}>()

const toast = useToast()
const {share, isSupported} = useShare()
const {copy} = useClipboard()

const onShare = async () => {
    const url = new URL(path, location.origin).href

    if (isSupported.value) {
        // Zavretie systémového dialógu bez zdieľania nie je chyba
        await share({title, url}).catch(() => {})
        return
    }

    await copy(url)
    toast.add({title: 'Odkaz je skopírovaný', color: 'success'})
}
</script>
