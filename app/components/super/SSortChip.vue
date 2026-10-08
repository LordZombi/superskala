<template>
    <UButton
        :icon="sortByGrade ? 'i-lucide-arrow-up-narrow-wide' : 'i-lucide-arrow-up-down'"
        label="Podľa obtiažnosti"
        color="neutral"
        :variant="sortByGrade ? 'subtle' : 'outline'"
        size="xs"
        class="rounded-full w-auto"
        :aria-pressed="sortByGrade"
        @click="sortByGrade = !sortByGrade"
    />
</template>

<script
    setup
    lang="ts"
>
// Jeden prepínač pre zoznam v oblasti aj detail cesty, preto zdieľaný stav
const sortByGrade = useState<boolean>('sortByGrade', () => false)
</script>
