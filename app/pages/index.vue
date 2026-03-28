<template>
    <div class="relative h-full">
        <MapView class="absolute inset-0 z-0"/>

        <ClimbDetailSheet/>
    </div>
</template>

<script
    setup
    lang="ts"
>
definePageMeta({
    layout: 'map'
})
</script>
