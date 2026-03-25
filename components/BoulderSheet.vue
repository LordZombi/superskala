<template>
  <div v-if="boulder" class="bg-gray-800 text-white rounded-lg shadow-xl overflow-hidden max-w-2xl mx-auto">

    <!-- Boulder Image with SVG Overlay -->
    <div class="relative">
      <img v-if="boulder.image_url" :src="boulder.image_url" :alt="boulder.name" class="w-full h-auto object-cover">
      <div v-else class="w-full h-96 bg-gray-700 flex items-center justify-center">
        <span class="text-gray-500">No image available</span>
      </div>

      <!-- SVG Overlay for Climbs -->
      <svg v-if="boulder.image_url && activeClimb"
           class="absolute top-0 left-0 w-full h-full"
           :viewBox="`0 0 ${imageDimensions.width} ${imageDimensions.height}`"
           @load="onImageLoad">

        <!-- Topo Path -->
        <path v-if="activeClimb.topo_path"
              :d="activeClimb.topo_path"
              stroke="#10b981"
              stroke-width="3"
              fill="none"
              stroke-linecap="round"
              stroke-linejoin="round"
              class="opacity-80"
        />

        <!-- Start Point -->
        <circle v-if="activeClimb.start_x && activeClimb.start_y"
                :cx="activeClimb.start_x * imageDimensions.width / 100"
                :cy="activeClimb.start_y * imageDimensions.height / 100"
                r="8"
                fill="#10b981"
                stroke="white"
                stroke-width="2"
        />

        <!-- Top Point -->
        <circle v-if="activeClimb.top_x && activeClimb.top_y"
                :cx="activeClimb.top_x * imageDimensions.width / 100"
                :cy="activeClimb.top_y * imageDimensions.height / 100"
                r="8"
                fill="#ef4444"
                stroke="white"
                stroke-width="2"
        />
      </svg>
    </div>

    <!-- Boulder and Climb Info -->
    <div class="p-6">
      <h2 class="text-2xl font-bold">{{ boulder.name }}</h2>

      <div v-if="activeClimb" class="mt-4">
        <h3 class="text-xl font-semibold text-green-400">{{ activeClimb.name }}</h3>
        <p class="text-lg text-gray-300">{{ activeClimb.grade_font }}</p>
      </div>

      <!-- Climb Selector -->
      <div class="mt-6">
        <h4 class="text-sm font-medium text-gray-400 mb-2">Climbs on this boulder:</h4>
        <div class="flex flex-wrap gap-2">
          <button v-for="climb in boulder.climbs"
                  :key="climb.id"
                  @click="setActiveClimb(climb)"
                  :class="['px-3 py-1 rounded-full text-sm font-semibold transition-colors',
                           activeClimb && activeClimb.id === climb.id ? 'bg-green-600 text-white' : 'bg-gray-700 hover:bg-gray-600']">
            {{ climb.name }} ({{ climb.grade_font }})
          </button>
        </div>
      </div>
    </div>
  </div>
  <div v-else class="text-center text-gray-500">
    <p>Loading boulder...</p>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, watch } from 'vue';

// Define the types based on your schema
interface Climb {
  id: string;
  name: string;
  grade_font: string;
  topo_path?: string;
  start_x?: number;
  start_y?: number;
  top_x?: number;
  top_y?: number;
}

interface Boulder {
  id: string;
  name: string;
  image_url?: string;
  climbs: Climb[];
}

const props = defineProps<{
  boulderId: string;
}>();

const { supabase } = useSupabase(); // Assuming you have a composable
const boulder = ref<Boulder | null>(null);
const activeClimb = ref<Climb | null>(null);
const imageDimensions = ref({ width: 1, height: 1 }); // Default to avoid division by zero

const fetchBoulderData = async () => {
  const { data, error } = await supabase
    .from('boulders')
    .select(`
      id,
      name,
      image_url,
      climbs (
        id,
        name,
        grade_font,
        topo_path,
        start_x,
        start_y,
        top_x,
        top_y
      )
    `)
    .eq('id', props.boulderId)
    .single();

  if (error) {
    console.error('Error fetching boulder:', error);
  } else {
    boulder.value = data;
    // Set the first climb as active by default
    if (data && data.climbs && data.climbs.length > 0) {
      setActiveClimb(data.climbs[0]);
    }
  }
};

const setActiveClimb = (climb: Climb) => {
  activeClimb.value = climb;
};

const onImageLoad = (event: Event) => {
  const img = event.target as HTMLImageElement;
  if (img.naturalWidth > 0 && img.naturalHeight > 0) {
    imageDimensions.value = { width: img.naturalWidth, height: img.naturalHeight };
  }
};

// Fetch data when the component is mounted
onMounted(fetchBoulderData);

// Re-fetch if the boulderId prop changes
watch(() => props.boulderId, fetchBoulderData);

// Pre-load image to get dimensions
watch(() => boulder.value?.image_url, (newUrl) => {
  if (newUrl) {
    const img = new Image();
    img.onload = () as any => {
       if (img.naturalWidth > 0 && img.naturalHeight > 0) {
         imageDimensions.value = { width: img.naturalWidth, height: img.naturalHeight };
       }
    };
    img.src = newUrl;
  }
});

</script>
