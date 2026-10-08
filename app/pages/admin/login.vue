<template>
    <div class="bg-neutral-50 min-h-screen p-4">
        <UCard class="max-w-sm mx-auto mt-12">
            <h2 class="text-lg font-semibold text-primary-500 mb-4">
                Prihlásenie editora
            </h2>
            <form
                class="space-y-4"
                @submit.prevent="codeSent ? verifyCode() : sendCode()"
            >
                <UFormField label="Email">
                    <UInput
                        v-model="email"
                        type="email"
                        autocomplete="email"
                        required
                        :disabled="codeSent"
                    />
                </UFormField>

                <UFormField
                    v-if="codeSent"
                    label="Kód z emailu"
                >
                    <UInput
                        v-model="code"
                        inputmode="numeric"
                        autocomplete="one-time-code"
                        required
                        autofocus
                    />
                </UFormField>

                <UButton
                    type="submit"
                    block
                    :loading="loading"
                >
                    {{ codeSent ? 'Prihlásiť' : 'Poslať kód' }}
                </UButton>
                <UButton
                    v-if="codeSent"
                    block
                    color="neutral"
                    variant="ghost"
                    @click="codeSent = false"
                >
                    Zmeniť email
                </UButton>
            </form>
        </UCard>
    </div>
</template>

<script
    setup
    lang="ts"
>
import {ref} from 'vue';
import {UButton, UCard, UFormField, UInput} from '#components';

const client = useSupabaseClient();
const user = useSupabaseUser();
const toast = useToast();

const email = ref('');
const code = ref('');
const codeSent = ref(false);
const loading = ref(false);

// Prihlásený už je, nie je dôvod zdržovať sa na tejto stránke
if (user.value) await navigateTo('/admin/editor');

// Kód (nie odkaz): v PWA na iPhone sa odkaz z emailu otvorí v Safari a prihlási nesprávnu appku
const sendCode = async () => {
    loading.value = true;
    const {error} = await client.auth.signInWithOtp({email: email.value.trim()});
    loading.value = false;
    if (error) {
        toast.add({title: 'Kód sa nepodarilo poslať', description: error.message, color: 'error'});
        return;
    }
    codeSent.value = true;
    toast.add({title: 'Kód poslaný', description: email.value, color: 'success'});
};

const verifyCode = async () => {
    loading.value = true;
    const {error} = await client.auth.verifyOtp({email: email.value.trim(), token: code.value.trim(), type: 'email'});
    loading.value = false;
    if (error) {
        toast.add({title: 'Kód nesedí', description: error.message, color: 'error'});
        return;
    }
    await navigateTo('/admin/editor');
};
</script>
