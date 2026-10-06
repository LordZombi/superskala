<script
    setup
    lang="ts"
>
import SDivider from "~/components/super/SDivider.vue";
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

            <section
                class="space-y-4"
            >
                <h2
                    class="text-3xl font-black text-neutral-900"
                >
                    Odkiaľ sú topá
                </h2>
                <p
                    class="text-neutral-600 leading-relaxed"
                >
                    Topá a popisy ciest pochádzajú zo sprievodcov portálu boulder.sk. Ďakujeme!
                </p>
                <ULink
                    to="https://boulder.sk/"
                    target="_blank"
                    class="mx-auto block w-fit border-12 border-black"
                >
                    <!-- brightness-0 prefarbí logo načierno bez úpravy súboru; rámik splýva s jeho čiernym okrajom -->
                    <img
                        src="https://boulder.sk/wp-content/themes/b2/logo.svg"
                        alt="boulder.sk (otvorí sa v novej karte)"
                        class="w-80 brightness-0"
                    />
                </ULink>
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

                <UButton
                    icon="i-heroicons-heart"
                    label="Podporiť cez Revolut"
                    to="https://revolut.me/zombi"
                    target="_blank"
                    color="primary"
                    size="lg"
                />
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
                            <strong>Magnézium:</strong> Používaj ho s mierou a po lezení chyty poriadne vykefuj.
                        </p>
                    </div>
                </div>
            </section>

            <SDivider/>

            <section
                class="flex flex-col md:flex-row justify-between items-start md:items-center gap-6 pb-12"
            >
                <div
                    class="space-y-1"
                >
                    <h2
                        class="font-bold text-neutral-900"
                    >
                        Máš pripomienky?
                    </h2>
                    <p
                        class="text-neutral-500"
                    >
                        Napíš nám na
                        <ULink
                            to="mailto:skaly@superdeveloper.sk"
                            class="underline"
                        >skaly@superdeveloper.sk</ULink>
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
                        aria-label="Instagram – lordzombi"
                        color="neutral"
                        variant="ghost"
                        target="_blank"
                    />
                    <UButton
                        href="https://github.com/LordZombi/superskala"
                        icon="i-simple-icons-github"
                        aria-label="GitHub – zdrojový kód Superskál"
                        color="neutral"
                        variant="ghost"
                        target="_blank"
                    />
                </div>
            </section>
        </div>
    </UContainer>
</template>
