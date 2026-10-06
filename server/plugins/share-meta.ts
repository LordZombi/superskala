// Link previews (WhatsApp, Messenger, iMessage…) read the HTML without running JS,
// so the SPA's client-side title never reaches them. This fills in the title on the server.
const UUID = /^[0-9a-f]{8}(-[0-9a-f]{4}){3}-[0-9a-f]{12}$/i

const escapeHtml = (text: string) => text.replace(/[&<>"]/g, char =>
    ({'&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;'})[char]!)

export default defineNitroPlugin((nitroApp) => {
    nitroApp.hooks.hook('render:html', async (html, {event}) => {
        const [, areaId] = event.path.match(/^\/area\/([^/?#]+)/) ?? []
        if (!areaId || !UUID.test(areaId)) return

        const {url, key} = useRuntimeConfig(event).public.supabase
        const climbId = String(getQuery(event).climb ?? '')

        const fetchRow = <T>(table: string, id: string, select: string) =>
            $fetch<T[]>(`${url}/rest/v1/${table}`, {
                query: {id: `eq.${id}`, select},
                headers: {apikey: key, Authorization: `Bearer ${key}`},
                timeout: 2000,
            }).then(rows => rows[0])

        try {
            const [area, climb] = await Promise.all([
                fetchRow<{ name: string }>('areas', areaId, 'name'),
                UUID.test(climbId)
                    ? fetchRow<{ name: string, topo_number: string | null }>('climbs', climbId, 'name,topo_number')
                    : undefined,
            ])
            if (!area) return

            // Same format as the client-side title in pages/area/[id].vue
            const title = escapeHtml(['Superskaly', area.name,
                climb && [climb.topo_number && `${climb.topo_number}.`, climb.name].filter(Boolean).join(' ')]
                .filter(Boolean).join(' | '))

            html.head = html.head.map(chunk => chunk.replace(/<title>[^<]*<\/title>/, ''))
            html.head.push(`<title>${title}</title><meta property="og:title" content="${title}"><meta property="og:site_name" content="Superskaly">`)
        } catch {
            // A preview title is never worth failing the page for
        }
    })
})
