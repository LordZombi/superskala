<script
    setup
    lang="ts"
>
import SDivider from "~/components/super/SDivider.vue";

definePageMeta({
    middleware: 'dev'
})
</script>

<template>
    <UContainer
        class="py-24 max-w-3xl"
    >
        <div
            class="space-y-12"
        >
            <section
                class="space-y-4"
            >
                <h1
                    class="text-5xl font-bold"
                >
                    O projekte
                </h1>
                <p
                    class="text-lg text-neutral-600 leading-relaxed"
                >
                    Superskaly sú digitálnym sprievodcom pre moderného bouldristu. Naším cieľom je zmapovať slovenské
                    skaly s milimetrovou presnosťou a priniesť topos, ktoré sa dajú čítať aj na ostrom slnku s magnéziom
                    na prstoch.
                </p>
            </section>

            <SDivider/>

            <section
                class="bg-primary-50 p-8 rounded-3xl border border-primary-100 space-y-6"
            >
                <div
                    class="space-y-2"
                >
                    <h2
                        class="text-2xl font-black text-primary-900"
                    >
                        Prispej na mádžo a kofolu
                    </h2>
                    <p
                        class="text-primary-700"
                    >
                        Tvorba, údržba a prevádzka apky stojí kopec času, energie a peňazí. Ak ti Superskaly pomohli
                        nájsť
                        tvoj nový projekt, budeme vďační za akúkoľvek podporu.
                    </p>
                </div>

                <div
                    class="flex flex-wrap gap-4"
                >
                    <UButton
                        icon="i-heroicons-heart"
                        label="Kúpiť kávu (3€)"
                        color="primary"
                        size="lg"
                    />
                    <UButton
                        icon="i-heroicons-bolt"
                        label="Podporiť rozvoj (10€)"
                        color="primary"
                        variant="outline"
                        size="lg"
                    />
                </div>
            </section>

            <section
                class="space-y-6"
            >
                <h2
                    class="text-3xl font-black text-neutral-900"
                >
                    Rešpektujme skaly
                </h2>
                <div
                    class="grid gap-4"
                >
                    <div
                        class="flex items-center gap-4 p-4 rounded-2xl bg-neutral-100 border border-neutral-200"
                    >
                        <UIcon
                            name="i-heroicons-trash"
                            class="w-6 h-6 text-neutral-500 shrink-0"
                        />
                        <p
                            class="text-sm text-neutral-700"
                        >
                            <strong>Žiadne odpadky:</strong> Čo si si do lesa priniesol, to si aj odnes. Vrátane ohorkov
                            a šupiek od banánov.
                        </p>
                    </div>
                    <div
                        class="flex items-center gap-4 p-4 rounded-2xl bg-neutral-100 border border-neutral-200"
                    >
                        <UIcon
                            name="i-heroicons-no-symbol"
                            class="w-6 h-6 text-neutral-500 shrink-0"
                        />
                        <p
                            class="text-sm text-neutral-700"
                        >
                            <strong>Magnézium:</strong> Používaj ho s mierou a po dolezení chytov ich poriadne vykefuj.
                        </p>
                    </div>
                </div>
            </section>

            <UDivider/>

            <section
                class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 pb-12"
            >
                <div
                    class="space-y-1"
                >
                    <h3
                        class="font-bold text-neutral-900"
                    >
                        Máš pripomienky?
                    </h3>
                    <p
                        class="text-neutral-500"
                    >
                        Napíš nám na info@superskala.sk
                    </p>
                </div>
                <div
                    class="flex items-center gap-2"
                >
                    <div class="col-auto text-nowrap">
                        Made with 💪 by
                    </div>
                    <UButton
                        href="https://www.instagram.com/lordzombi"
                        icon="i-simple-icons-instagram"
                        color="neutral"
                        variant="ghost"
                        target="_blank"
                    />
                    <UButton
                        href="https://github.com/LordZombi/superskala"
                        icon="i-simple-icons-github"
                        color="neutral"
                        variant="ghost"
                        target="_blank"
                    />
                </div>
            </section>
        </div>
    </UContainer>
</template>
