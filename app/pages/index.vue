<template>
    <div class="relative h-screen w-screen overflow-hidden bg-slate-50 dark:bg-gray-950 font-sans">
        <MapView class="absolute inset-0 z-0"/>

        <ClimbDetailSheet/>
    </div>
</template>

<script
    setup
    lang="ts"
>
// Definujeme zdieľaný stav pre vybratú cestu
const selectedClimbId = useState<string | null>('selectedClimbId', () => null)
</script>

<style>
html, body, #__nuxt {
    height: 100%;
    margin: 0;
    overflow: hidden;
}

.leaflet-container {
    z-index: 1;
}
</style>
