<template>
    <UCard>
        <template #header>
            <div class="flex justify-between items-center">
                <h1 class="text-2xl font-bold text-primary-500 dark:text-primary-400">Topo Editor</h1>
                <div class="col-auto">
                    <UButton
                        variant="soft"
                        icon="i-heroicons-plus-circle"
                        @click="$emit('newClimb')"
                    >
                        Nový Climb
                    </UButton>
                </div>
            </div>
        </template>

        <div class="space-y-6">
            <!-- Climb ID -->
            <UFormField
                label="Climb ID"
                description="UUID of the climb to update"
            >
                <UInput
                    v-model="climbId"
                    placeholder="New climb will have a generated ID"
                    icon="i-heroicons-finger-print"
                    disabled
                />
            </UFormField>

            <!-- Image Upload -->
            <UFormField
                label="Boulder Image"
                description="Upload a new image for the boulder"
            >
                <UInput
                    type="file"
                    @change="handleImageUpload"
                    icon="i-heroicons-arrow-up-tray"
                    accept="image/*"
                />
            </UFormField>

            <hr class="border-t border-gray-200 dark:border-gray-800 my-6"/>

            <!-- Drawing Mode -->
            <div>
                <h2 class="text-lg font-semibold text-primary-500 dark:text-primary-400 mb-3">Drawing Mode</h2>
                <div class="grid grid-cols-3 gap-2 mb-2">
                    <UButton
                        :variant="mode === 'start' ? 'solid' : 'outline'"
                        color="primary"
                        @click="mode = 'start'"
                        icon="i-heroicons-map-pin"
                        label="Set Start"
                    />
                    <UButton
                        :variant="mode === 'top' ? 'solid' : 'outline'"
                        color="error"
                        @click="mode = 'top'"
                        icon="i-heroicons-flag"
                        label="Set Top"
                    />
                    <UButton
                        :variant="mode === 'path' ? 'solid' : 'outline'"
                        color="info"
                        @click="mode = 'path'"
                        icon="i-heroicons-pencil-square"
                        label="Draw Path"
                    />
                </div>
                <UButton
                    block
                    color="neutral"
                    variant="soft"
                    @click="clearDrawing"
                    icon="i-heroicons-trash"
                >
                    Clear Drawing
                </UButton>
            </div>

            <hr class="border-t border-gray-200 dark:border-gray-800 my-6"/>

            <!-- Climb Details -->
            <div>
                <h2 class="text-lg font-semibold text-primary-500 dark:text-primary-400 mb-3">Climb Details</h2>
                <div class="space-y-4">
                    <UFormField label="Climb Name">
                        <UInput
                            v-model="climbName"
                            placeholder="e.g., Šak ty"
                            icon="i-heroicons-tag"
                        />
                    </UFormField>

                    <UFormField label="Grade">
                        <USelectMenu
                            v-model="gradeId"
                            :items="availableGrades"
                            value-key="id"
                            label-key="font"
                            placeholder="Select grade"
                        />
                    </UFormField>

                    <UCheckbox
                        v-model="isSitStart"
                        name="isSitStart"
                        label="Sit Start"
                    />
                </div>
            </div>

            <hr class="border-t border-gray-200 dark:border-gray-800 my-6"/>

            <UButton
                block
                size="lg"
                color="primary"
                icon="i-heroicons-cloud-arrow-up"
                @click="$emit('save')"
            >
                Uložiť zmeny
            </UButton>
        </div>
    </UCard>
</template>

<script
    setup
    lang="ts"
>
/**
 * @file Sidebar component for the Topo Editor. Manages form inputs, drawing mode, and image upload.
 * All data is managed via v-model from the parent.
 */

interface Grade {
    id: number;
    font: string;
    value: number;
}

defineProps<{
    availableGrades: Grade[];
}>();

// Define models for two-way data binding with the parent component
const climbId = defineModel<string>('climbId', {default: ''});
const imageUrl = defineModel<string>('imageUrl', {default: ''});
const climbName = defineModel<string>('climbName', {default: ''});
const gradeId = defineModel<number>('gradeId');
const isSitStart = defineModel<boolean>('isSitStart', {default: false});
const mode = defineModel<'start' | 'top' | 'path'>('mode', {default: 'path'});

// Models for drawing data, passed to Canvas and cleared here
const startPos = defineModel<{ x: number, y: number } | null>('startPos', {default: null});
const topPos = defineModel<{ x: number, y: number } | null>('topPos', {default: null});
const pathPoints = defineModel<{ x: number, y: number }[]>('pathPoints', {default: () => []});

// Supabase client for image upload
const client = useSupabaseClient();

// Define emitted events
defineEmits(['save', 'newClimb']);

/**
 * Clears all drawing data (start, top, and path points).
 */
const clearDrawing = () => {
    startPos.value = null;
    topPos.value = null;
    pathPoints.value = [];
};

/**
 * Handles the image file upload to Supabase storage.
 * Updates the imageUrl model with the public URL of the uploaded image.
 * @param {Event} event - The change event from the file input.
 */
const handleImageUpload = async (event: Event) => {
    const input = event.target as HTMLInputElement;
    if (!input.files || input.files.length === 0) {
        return;
    }

    const [file] = input.files;
    if (!file) {
        console.error('No file selected');
        return
    }

    const fileExt = file.name.split('.').pop();
    const fileName = `${Date.now()}-${Math.random().toString(36).substring(2, 9)}.${fileExt}`;

    try {
        const {data, error} = await client.storage
            .from('boulder-photos')
            .upload(fileName, file);

        if (error) throw error;

        const {data: publicUrlData} = client.storage.from('boulder-photos').getPublicUrl(data.path);
        imageUrl.value = publicUrlData.publicUrl;
    } catch (error: any) {
        alert(`Image upload failed: ${error.message}`);
        console.error('Image upload error:', error);
    } finally {
        input.value = '';
    }
}
</script>
