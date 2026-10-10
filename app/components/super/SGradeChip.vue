<template>
    <UButton
        icon="i-lucide-biceps-flexed"
        label="Filter"
        :color="range ? 'success' : 'neutral'"
        :variant="range ? 'subtle' : 'outline'"
        size="xs"
        class="rounded-full w-auto"
        :aria-pressed="!!range"
        @click="range = range ? null : [grades.at(0)!.value, grades.at(-1)!.value]"
    />

    <div
        v-if="range"
        class="s-grade-chip flex basis-full flex-col gap-4"
    >
        <ul class="s-grade-chip__bars flex h-24 items-end">
            <li
                v-for="grade in grades"
                :key="grade.value"
                class="s-grade-chip__bar flex h-full min-w-0 flex-1 flex-col items-center justify-end gap-0.5 px-0.5 text-[10px] font-mono"
            >
                <span class="text-slate-600">{{ grade.count }}</span>
                <span
                    aria-hidden="true"
                    :class="['w-full rounded-t', grade.value >= range[0] && grade.value <= range[1] ? 'bg-success' : 'bg-slate-200']"
                    :style="{height: `${grade.count / maxCount * 70}%`}"
                ></span>
                <span class="max-w-full text-[9px] tracking-tighter">{{ grade.font }}</span>
            </li>
        </ul>

        <!-- Okraj = polovica stĺpca mínus polovica úchytu (size-5), aby úchyty ležali presne pod stredmi stĺpcov -->
        <USlider
            v-model="indexes"
            :min="0"
            :max="grades.length - 1"
            :step="1"
            color="success"
            class="s-grade-chip__slider"
            :ui="{thumb: 'size-5'}"
            :style="{margin: `0 calc(${50 / grades.length}% - 0.625rem)`}"
            :aria-label="`Rozsah obtiažnosti ${rangeLabel}`"
        />
        <p
            class="text-center text-sm font-medium text-slate-600"
            aria-live="polite"
        >
            {{ rangeLabel }}
        </p>
    </div>
</template>

<script
    setup
    lang="ts"
>
import {computed} from 'vue'

// Obtiažnosti oblasti od najľahšej s počtom ciest; model je zvolený rozsah (hodnoty stupňov) alebo null, keď filter nie je zapnutý
const {grades} = defineProps<{ grades: { font: string, value: number, count: number }[] }>()
const range = defineModel<[number, number] | null>({default: null})

const maxCount = computed(() => Math.max(...grades.map(grade => grade.count)))

// Posuvník pracuje s poradím v zozname, lebo stupne nie sú rozmiestnené rovnomerne (6C+ → 7A)
const indexes = computed<[number, number]>({
    get: () => range.value
        ? [grades.findIndex(g => g.value >= range.value![0]), grades.findLastIndex(g => g.value <= range.value![1])]
        : [0, grades.length - 1],
    set: ([from, to]) => range.value = [grades[from]!.value, grades[to]!.value],
})

const rangeLabel = computed(() => range.value
    ? [...new Set([grades[indexes.value[0]]?.font, grades[indexes.value[1]]?.font])].join(' – ')
    : '')
</script>
