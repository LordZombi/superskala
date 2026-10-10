<script
    setup
    lang="ts"
>
import {onMounted, ref} from "vue";
import SDivider from "~/components/super/SDivider.vue";
import {useSupabase} from "~/composables/useSupabase";

const {getAreasForMap} = useSupabase();
const {buildCommit, buildTime} = useRuntimeConfig().public;
const buildDate = new Date(buildTime).toLocaleString('sk');
const areas = ref<{ id: string, name: string }[]>([]);

onMounted(async () => {
    const all = await getAreasForMap();

    // Tabuľka oblastí nemá krajinu, preto Slovensko poznáme podľa súradníc (približný obdĺžnik okolo hraníc)
    areas.value = all
        .filter((area) => {
            const {lat, lon} = area.lat && area.lon ? area : area.sectors.find(sector => sector.lat && sector.lon) ?? {};

            return lat && lon && lat >= 47.7 && lat <= 49.65 && lon >= 16.8 && lon <= 22.6;
        })
        .map(({id, name}) => ({id, name}))
        .sort((a, b) => a.name.localeCompare(b.name, "sk"));
});
</script>

<template>
    <UContainer
        class="py-12 max-w-4xl"
    >
        <div
            class="space-y-12"
        >
            <section
                class="space-y-4"
            >
                <div
                    class="flex items-center gap-4 text-neutral-900"
                >
                    <!-- dekoratívne: názov hneď vedľa ho už hovorí; maska preberá farbu textu a orezané logo lícuje s okrajom -->
                    <span
                        aria-hidden="true"
                        class="size-12 shrink-0 bg-current mask-[url(/superskala-full.svg)] mask-contain mask-no-repeat mask-center"
                    ></span>
                    <h1
                        class="text-5xl font-bold"
                    >
                        Superskaly
                    </h1>
                </div>
                <p
                    class="text-xl text-neutral-600 leading-relaxed"
                >
                    Apka je <strong class="text-primary-700">zadarmo</strong> a vždy bude.
                </p>
                <p
                    class="text-neutral-600 leading-relaxed"
                >
                    Je to naše <strong class="text-primary-700">poďakovanie</strong> prvolezcom, ktorí cesty
                    objavili a zdokumentovali, aj všetkým, čo sa o skaly a lesy okolo nich starajú.
                </p>
                <p
                    class="text-neutral-600 leading-relaxed"
                >
                    <a href="/"><strong>Superskaly</strong></a> sú digitálnym sprievodcom pre moderného
                    bouldristu. Naším cieľom je zmapovať slovenské skaly s milimetrovou presnosťou a priniesť topos,
                    ktoré sa dajú čítať aj na ostrom slnku s magnéziom na prstoch.
                </p>
            </section>

            <section
                v-if="areas.length"
                class="space-y-4"
            >
                <h2
                    class="text-3xl font-black text-neutral-900"
                >
                    Zmapované oblasti
                </h2>
                <ul
                    class="grid gap-4 sm:grid-cols-2"
                >
                    <li
                        v-for="area in areas"
                        :key="area.id"
                    >
                        <NuxtLink
                            :to="`/area/${area.id}`"
                            class="flex items-center justify-between gap-4 p-4 rounded-2xl bg-neutral-100 border border-neutral-200 font-bold text-neutral-900 hover:bg-neutral-200 focus-visible:outline-2 focus-visible:outline-primary-700"
                        >
                            {{ area.name }}
                            <UIcon
                                name="i-heroicons-arrow-right"
                                class="w-5 h-5 text-neutral-500 shrink-0"
                            />
                        </NuxtLink>
                    </li>
                </ul>
            </section>

            <section
                class="space-y-4"
            >
                <h2
                    class="text-3xl font-black text-neutral-900"
                >
                    Odkiaľ sú topá a legendy
                </h2>
                <p
                    class="text-neutral-600 leading-relaxed"
                >
                    Topá a popisy ciest pochádzajú zo sprievodcov portálu boulder.sk, mýty a legendy o prelezoch zas
                    z ústneho podania lezcov. Ďakujeme!
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
                    <UButton
                        to="/admin/editor"
                        icon="i-heroicons-pencil"
                        label="Topo editor"
                        color="neutral"
                        variant="soft"
                        class="mt-3 w-auto"
                    />
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

            <p class="pb-8 text-xs text-neutral-500">
                Verzia {{ buildCommit }} • zostavené {{ buildDate }}
            </p>
        </div>
    </UContainer>
</template>
