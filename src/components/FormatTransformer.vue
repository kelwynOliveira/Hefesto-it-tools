<script setup lang="ts">
import _ from 'lodash';
import type { UseValidationRule } from '@/composable/validation';
import CInputText from '@/ui/c-input-text/c-input-text.vue';
import { ref, watch, watchEffect, toRefs } from 'vue';

const props = withDefaults(
  defineProps<{
    transformer?: (v: string) => string | Promise<string>
    inputValidationRules?: UseValidationRule<string>[]
    inputLabel?: string
    inputPlaceholder?: string
    inputDefault?: string
    outputLabel?: string
    outputLanguage?: string
  }>(),
  {
    transformer: _.identity,
    inputValidationRules: () => [],
    inputLabel: 'Input',
    inputDefault: '',
    inputPlaceholder: 'Input...',
    outputLabel: 'Output',
    outputLanguage: '',
  },
);

const { transformer, inputValidationRules, inputLabel, outputLabel, outputLanguage, inputPlaceholder, inputDefault }
  = toRefs(props);

const inputElement = ref<typeof CInputText>();

const input = ref(inputDefault.value);
// const output = computed(() => transformer.value(input.value));
const output = ref('');
const isTransforming = ref(false);

watchEffect(async () => {
  isTransforming.value = true;
  try {
    output.value = await transformer.value(input.value);
  } catch (e) {
    console.error("Erro na transformação:", e);
    output.value = 'Erro na transformação.';
  } finally {
    isTransforming.value = false;
  }
});
</script>

<template>
  <CInputText
    ref="inputElement"
    v-model:value="input"
    :placeholder="inputPlaceholder"
    :label="inputLabel"
    rows="20"
    autosize
    raw-text
    multiline
    test-id="input"
    :validation-rules="inputValidationRules"
    monospace
  />

  <div overflow-auto>
    <div mb-5px>
      {{ outputLabel }}
    </div>
    <textarea-copyable :value="output" :language="outputLanguage" :follow-height-of="inputElement?.inputWrapperRef" />
  </div>
</template>
