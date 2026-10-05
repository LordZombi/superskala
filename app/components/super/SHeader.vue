<template>
    <header class="">
        <div
            class="flex justify-between items-center pointer-events-auto bg-white px-4 py-2"
        >
            <NuxtLink
                to="/"
                class="flex items-center gap-2 group"
            >
                <h1 class="text-xl font-bold">
                    Superskaly
                </h1>
            </NuxtLink>

            <div class="flex items-center gap-2">
                <UButton
                    to="/"
                    icon="i-heroicons-map"
                    aria-label="Mapa"
                    color="neutral"
                    variant="ghost"
                    class="rounded-full"
                />

                <UButton
                    to="/admin/editor"
                    icon="i-heroicons-pencil"
                    aria-label="Topo editor"
                    color="neutral"
                    variant="ghost"
                    class="rounded-full"
                />

                <UButton
                    to="/info"
                    icon="i-heroicons-information-circle"
                    aria-label="O projekte"
                    color="neutral"
                    variant="ghost"
                    class="rounded-full"
                />

                <UColorModeButton/>
            </div>
        </div>
    </header>
</template>
