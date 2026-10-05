<script
    setup
    lang="ts"
>
import SHeader from "~/components/super/SHeader.vue";

// Ťahanie panelov nesmie spustiť pull-to-refresh ani gumovanie stránky
useHead({
    htmlAttrs: {class: 'overscroll-none'},
})
</script>

<template>
    <div class="h-dvh flex flex-col bg-neutral-50 font-sans">
        <SHeader/>

        <main class="flex-1">
            <slot/>
        </main>
    </div>
</template>
