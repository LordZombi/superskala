<script
    setup
    lang="ts"
>
import SHeader from "~/components/super/SHeader.vue";
</script>

<template>
    <div class="flex flex-col bg-neutral-50 font-sans">
        <SHeader/>

        <main class="flex-1">
            <slot/>
        </main>
    </div>
</template>
