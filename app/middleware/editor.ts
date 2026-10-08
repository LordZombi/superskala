// Skutočnú ochranu robí RLS v databáze, toto len pošle neprihláseného na prihlásenie.
// getSession() číta úložisko priamo, takže hneď po prihlásení nepredbehne stav z useSupabaseUser().
export default defineNuxtRouteMiddleware(async () => {
    const {data} = await useSupabaseClient().auth.getSession()
    if (!data.session) return navigateTo('/admin/login')
})
