// Popisky z databázy smú mať základné HTML (<a>, <strong>, <p>…) vrátane style; všetko ostatné sa zahodí,
// aby sa cez popis nedal dostať na stránku skript. Appka je len klientská (ssr: false), DOMParser je teda vždy k dispozícii.
const ALLOWED_TAGS = new Set([
    'A', 'B', 'STRONG', 'I', 'EM', 'U', 'S', 'SMALL', 'MARK', 'SPAN', 'DIV', 'P', 'BR',
    'UL', 'OL', 'LI', 'H3', 'H4', 'BLOCKQUOTE', 'CODE'
])
// Tieto prvky sa zahadzujú aj s obsahom, ostatné nepovolené sa rozbalia na ich text
const DROPPED_TAGS = new Set(['SCRIPT', 'STYLE', 'IFRAME', 'OBJECT', 'EMBED', 'TEMPLATE', 'NOSCRIPT'])
const SAFE_URL = /^(https?:|mailto:|tel:|\/|#)/i
// url() a position by dovolili preložiť cez stránku cudzí obsah alebo sledovať čitateľa
const UNSAFE_STYLE = /url\(|expression|@import|javascript|behavior|position\s*:|z-index/i

const cleanAttributes = (el: Element) => {
    for (const {name, value} of [...el.attributes]) {
        const isSafeLink = el.tagName === 'A' && name === 'href' && SAFE_URL.test(value.replace(/[\s\u0000-\u001f]/g, ''))
        const isSafeStyle = name === 'style' && !UNSAFE_STYLE.test(value)

        if (!isSafeLink && !isSafeStyle && !(el.tagName === 'A' && name === 'title')) el.removeAttribute(name)
    }

    if (el.tagName === 'A' && el.hasAttribute('href')) {
        el.setAttribute('target', '_blank')
        el.setAttribute('rel', 'noopener noreferrer')
    }
}

const cleanChildren = (parent: Node) => {
    for (const node of [...parent.childNodes]) {
        if (node.nodeType === Node.TEXT_NODE) continue

        const el = node as Element
        if (node.nodeType !== Node.ELEMENT_NODE || DROPPED_TAGS.has(el.tagName)) {
            node.parentNode!.removeChild(node)
            continue
        }

        cleanChildren(el)

        if (ALLOWED_TAGS.has(el.tagName)) cleanAttributes(el)
        else el.replaceWith(...el.childNodes)
    }
}

export const useSafeHtml = () => {
    const sanitize = (html: string | null | undefined): string => {
        if (!html) return ''

        const {body} = new DOMParser().parseFromString(html, 'text/html')
        cleanChildren(body)

        return body.innerHTML
    }

    return {sanitize}
}
