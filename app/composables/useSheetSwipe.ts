import {ref, toValue, type MaybeRefOrGetter} from 'vue'
import {useSwipe} from '@vueuse/core'

type MaybeElement = MaybeRefOrGetter<HTMLElement | null | undefined>

/**
 * Gestá spodného panela na mobile: potiahnutie dole ho zmenší, hore zväčší.
 * Dole reaguje len keď je obsah odscrollovaný na začiatku, inak by sa bilo so scrollovaním obsahu.
 */
export function useSheetSwipe(sheet: MaybeElement, scroller: MaybeElement, {onLeft, onRight}: {
    onLeft?: () => void
    onRight?: () => void
} = {}) {
    const isMinimized = ref(false)
    let startedAtTop = true

    useSwipe(sheet, {
        onSwipeStart: () => {
            startedAtTop = !toValue(scroller)?.scrollTop
        },
        onSwipeEnd: (_, direction) => {
            if (direction === 'up') isMinimized.value = false
            else if (direction === 'down' && startedAtTop) isMinimized.value = true
            else if (direction === 'left') onLeft?.()
            else if (direction === 'right') onRight?.()
        },
    })

    return {isMinimized}
}
