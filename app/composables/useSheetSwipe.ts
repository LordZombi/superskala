import {ref, toValue, type MaybeRefOrGetter} from 'vue'
import {useSwipe} from '@vueuse/core'

type MaybeElement = MaybeRefOrGetter<HTMLElement | null | undefined>

/**
 * Gestá spodného panela na mobile: potiahnutie dole ho zmenší, hore zväčší.
 * Dole reaguje len keď je obsah odscrollovaný na začiatku, inak by sa bilo so scrollovaním obsahu.
 * Z bežnej veľkosti ide potiahnutie hore do onUp (napr. celá obrazovka), z rovnakého dôvodu
 * len keď ním nie je čo scrollovať: začalo mimo obsahu alebo je obsah na konci.
 */
export function useSheetSwipe(sheet: MaybeElement, scroller: MaybeElement, {onUp, onLeft, onRight}: {
    onUp?: () => void
    onLeft?: () => void
    onRight?: () => void
} = {}) {
    const isMinimized = ref(false)
    let startedAtTop = true
    let canGrow = true

    useSwipe(sheet, {
        onSwipeStart: ({target}) => {
            const content = toValue(scroller)

            startedAtTop = !content?.scrollTop
            canGrow = !content
                || !content.contains(target as Node)
                || content.scrollTop + content.clientHeight >= content.scrollHeight - 1
        },
        onSwipeEnd: (_, direction) => {
            if (direction === 'up' && isMinimized.value) isMinimized.value = false
            else if (direction === 'up' && canGrow) onUp?.()
            else if (direction === 'down' && startedAtTop) isMinimized.value = true
            else if (direction === 'left') onLeft?.()
            else if (direction === 'right') onRight?.()
        },
    })

    return {isMinimized}
}
