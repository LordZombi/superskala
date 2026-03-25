<script setup lang="ts">
const client = useSupabaseClient()

// State pre dáta z DB
const boulders = ref<any[]>([])
const selectedBoulder = ref<any>(null)
const climbs = ref<any[]>([])
const selectedClimb = ref<any>(null)
const loading = ref(false)

// Editor State
const mode = ref<'start' | 'top' | 'path'>('path')
const imageContainer = ref<HTMLElement | null>(null)

// Form State (všetko v jednom objekte pre ľahký update)
const form = ref({
    id: '',
    name: '',
    grade_font: '',
    grade_value: 0,
    is_sit_start: false,
    topo_path: '',
    start_x: null as number | null,
    start_y: null as number | null,
    top_x: null as number | null,
    top_y: null as number | null
})

// Načítanie bouldrov pri štarte
onMounted(async () => {
    const { data } = await client.from('boulders').select('*').order('name')
    boulders.value = data || []
})

// Keď vyberieš boulder, načítaj jeho cesty
watch(selectedBoulder, async (newBoulder) => {
    if (!newBoulder) return
    const { data } = await client.from('climbs').select('*').eq('boulder_id', newBoulder.id).order('name')
    climbs.value = data || []
    selectedClimb.value = null
})

// Načítanie konkrétnej cesty do formulára
const loadClimbData = () => {
    if (!selectedClimb.value) return
    form.value = { ...selectedClimb.value }
}

// AUTOMATICKÝ UPLOAD FOTKY
const handleFileUpload = async (event: any) => {
    const file = event.target.files[0]
    if (!file || !selectedBoulder.value) return

    loading.value = true
    const fileExt = file.name.split('.').pop()
    const fileName = `${selectedBoulder.value.id}-${Date.now()}.${fileExt}`

    // 1. Nahraj do Storage (bucket: 'boulders')
    const { data, error } = await client.storage
        .from('boulder-photos')
        .upload(fileName, file)

    if (data) {
        const { data: { publicUrl } } = client.storage.from('boulder-photos').getPublicUrl(fileName)

        // 2. Ulož URL k bouldru v DB
        await client.from('boulders')
            .update({ image_url: publicUrl })
            .eq('id', selectedBoulder.value.id)

        selectedBoulder.value.image_url = publicUrl
    }
    loading.value = false
}

// LOGIKA KRESLENIA (v percentách pre responzivitu)
const handleSvgClick = (event: MouseEvent) => {
    if (!imageContainer.value || !selectedBoulder.value?.image_url) return

    const rect = imageContainer.value.getBoundingClientRect()
    const x = ((event.clientX - rect.left) / rect.width) * 100
    const y = ((event.clientY - rect.top) / rect.height) * 100

    if (mode.value === 'start') {
        form.value.start_x = Number(x.toFixed(2))
        form.value.start_y = Number(y.toFixed(2))
    } else if (mode.value === 'top') {
        form.value.top_x = Number(x.toFixed(2))
        form.value.top_y = Number(y.toFixed(2))
    } else if (mode.value === 'path') {
        const prefix = form.value.topo_path ? ' L' : 'M'
        form.value.topo_path += `${prefix} ${x.toFixed(2)} ${y.toFixed(2)}`
    }
}

// ULOŽENIE DO SUPABASE
const saveToSupabase = async () => {
    if (!form.value.id) return
    loading.value = true

    const { error } = await client.from('climbs')
        .update({
            name: form.value.name,
            grade_font: form.value.grade_font,
            grade_value: form.value.grade_value,
            topo_path: form.value.topo_path,
            start_x: form.value.start_x,
            start_y: form.value.start_y,
            top_x: form.value.top_x,
            top_y: form.value.top_y,
            is_sit_start: form.value.is_sit_start
        })
        .eq('id', form.value.id)

    if (!error) alert('Dáta úspešne uložené! 🧗‍♂️')
    else console.error(error)
    loading.value = false
}
</script>

<template>
    <div class="min-h-screen bg-slate-950 text-slate-100 p-4 lg:p-8 font-sans">
        <div class="max-w-7xl mx-auto grid grid-cols-1 lg:grid-cols-3 gap-8">

            <div class="lg:col-span-2 space-y-4">
                <div class="flex items-center justify-between">
                    <h1 class="text-2xl font-black text-emerald-500 tracking-tighter uppercase italic">Superskala Editor</h1>
                    <div v-if="selectedBoulder" class="text-sm text-slate-400 font-mono">{{ selectedBoulder.name }}</div>
                </div>

                <div
                    ref="imageContainer"
                    v-if="selectedBoulder?.image_url"
                    class="relative border-4 border-slate-800 rounded-2xl overflow-hidden shadow-2xl bg-slate-900 cursor-crosshair"
                    @click="handleSvgClick"
                >
                    <img :src="selectedBoulder.image_url" class="w-full h-auto block select-none" alt="Boulder Topo">

                    <svg class="absolute inset-0 w-full h-full pointer-events-none" viewBox="0 0 100 100" preserveAspectRatio="none">
                        <path :d="form.topo_path" fill="none" stroke="#10b981" stroke-width="1.5" stroke-linecap="round" stroke-linejoin="round" />
                        <circle v-if="form.start_x" :cx="form.start_x" :cy="form.start_y" r="2" fill="#10b981" stroke="white" stroke-width="0.5" />
                        <circle v-if="form.top_x" :cx="form.top_x" :cy="form.top_y" r="2" fill="#ef4444" stroke="white" stroke-width="0.5" />
                    </svg>
                </div>

                <div v-else class="aspect-video bg-slate-900 border-4 border-dashed border-slate-800 rounded-2xl flex flex-col items-center justify-center text-slate-500">
                    <p class="text-xl font-bold uppercase tracking-widest mb-2">Žiadna fotka</p>
                    <p class="text-sm">Vyber kameň a nahraj fotku z disku.</p>
                </div>
            </div>

            <div class="bg-slate-900 p-6 rounded-2xl border border-slate-800 shadow-xl space-y-6 h-fit sticky top-8">

                <div class="space-y-4">
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-500 tracking-widest">1. Výber Sektora / Bouldra</label>
                        <select v-model="selectedBoulder" class="w-full bg-slate-800 border-none rounded-xl p-3 text-sm focus:ring-2 focus:ring-emerald-500 transition-all">
                            <option :value="null">Vyber kameň...</option>
                            <option v-for="b in boulders" :key="b.id" :value="b">{{ b.name }}</option>
                        </select>
                    </div>

                    <div v-if="selectedBoulder" class="p-3 bg-emerald-500/5 rounded-xl border border-emerald-500/20">
                        <input type="file" @change="handleFileUpload" class="text-xs text-slate-400 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-xs file:font-bold file:bg-emerald-500 file:text-white hover:file:bg-emerald-400 transition-all" />
                    </div>
                </div>

                <div v-if="selectedBoulder" class="space-y-4 pt-4 border-t border-slate-800">
                    <div class="space-y-2">
                        <label class="text-[10px] font-black uppercase text-slate-500 tracking-widest">2. Výber konkrétnej cesty</label>
                        <div class="flex gap-2">
                            <select v-model="selectedClimb" class="flex-1 bg-slate-800 border-none rounded-xl p-3 text-sm">
                                <option v-for="c in climbs" :key="c.id" :value="c">{{ c.name }} ({{ c.grade_font }})</option>
                            </select>
                            <button @click="loadClimbData" class="bg-slate-700 px-4 rounded-xl hover:bg-slate-600 font-bold text-xs uppercase transition-all">Načítať</button>
                        </div>
                    </div>
                </div>

                <div v-if="form.id" class="space-y-4 pt-4 border-t border-slate-800">
                    <div class="grid grid-cols-3 gap-2">
                        <button @click="mode = 'start'" :class="mode === 'start' ? 'bg-emerald-500 text-white shadow-lg shadow-emerald-900/40' : 'bg-slate-800 text-slate-400'" class="p-3 rounded-xl text-[10px] font-black uppercase transition-all">Štart</button>
                        <button @click="mode = 'top'" :class="mode === 'top' ? 'bg-red-500 text-white shadow-lg shadow-red-900/40' : 'bg-slate-800 text-slate-400'" class="p-3 rounded-xl text-[10px] font-black uppercase transition-all">Top</button>
                        <button @click="mode = 'path'" :class="mode === 'path' ? 'bg-blue-500 text-white shadow-lg shadow-blue-900/40' : 'bg-slate-800 text-slate-400'" class="p-3 rounded-xl text-[10px] font-black uppercase transition-all">Čiara</button>
                    </div>

                    <div class="space-y-2">
                        <input v-model="form.name" placeholder="Názov" class="w-full bg-slate-800 border-none rounded-xl p-3 text-sm focus:ring-2 focus:ring-emerald-500" />
                        <div class="grid grid-cols-2 gap-2">
                            <input v-model="form.grade_font" placeholder="7B" class="bg-slate-800 border-none rounded-xl p-3 text-sm focus:ring-2 focus:ring-emerald-500" />
                            <input v-model.number="form.grade_value" type="number" placeholder="70" class="bg-slate-800 border-none rounded-xl p-3 text-sm focus:ring-2 focus:ring-emerald-500" />
                        </div>
                        <label class="flex items-center gap-3 p-3 bg-slate-800 rounded-xl cursor-pointer">
                            <input type="checkbox" v-model="form.is_sit_start" class="w-5 h-5 rounded border-none bg-slate-700 text-emerald-500 focus:ring-0" />
                            <span class="text-xs font-bold text-slate-300">SIT START (SD)</span>
                        </label>
                    </div>

                    <button @click="form.topo_path = ''" class="w-full text-[10px] font-black text-slate-500 hover:text-red-400 uppercase tracking-widest py-2 transition-all">Resetovať nákres</button>

                    <button
                        @click="saveToSupabase"
                        :disabled="loading"
                        class="w-full bg-emerald-500 hover:bg-emerald-400 disabled:opacity-50 text-slate-950 font-black py-4 rounded-2xl shadow-xl shadow-emerald-500/10 transition-all transform active:scale-95"
                    >
                        {{ loading ? 'UKLADÁM...' : 'ULOŽIŤ DO DATABÁZY' }}
                    </button>
                </div>
            </div>
        </div>
    </div>
</template>
