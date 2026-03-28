export default defineNuxtRouteMiddleware((to, from) => {
    if (!import.meta.dev) {
        return navigateTo('/')
    }
})
