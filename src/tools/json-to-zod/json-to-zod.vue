<script setup lang="ts">
import { ref } from 'vue';
import JSON5 from 'json5';
import { withDefaultOnError } from '@/utils/defaults';
import type { UseValidationRule } from '@/composable/validation';

const rootName = ref('schema');

const rules: UseValidationRule<string>[] = [
  {
    validator: (v: string) =>
      v.trim() === '' ||
      (() => {
        JSON5.parse(v);
        return true;
      })(),
    message: 'Provided JSON is not valid.',
  },
];

async function convertJsonToZod(value: string): Promise<string> {
  const trimmed = value.trim();
  if (!trimmed) return '';

  let parsed: unknown;
  try {
    parsed = JSON5.parse(trimmed);
  } catch {
    return '';
  }

  try {
    const { jsonToZod } = await import('json-to-zod');
    return jsonToZod(parsed, rootName.value, true).trim();
  } catch {
    return '';
  }
}

async function transformer(value: string): Promise<string> {
  return value.trim() === '' ? '' : await withDefaultOnError(() => convertJsonToZod(value), '');
}
</script>

<template>
  <format-transformer
    input-label="Your JSON"
    input-placeholder="Paste your JSON here..."
    output-label="Zod Schema"
    output-language="typescript"
    :input-validation-rules="rules"
    :transformer="transformer"
  >
    <template #settings>
      <div class="mt-4 flex items-center gap-2">
        <label for="rootName" class="text-sm font-medium">Root Schema Name</label>
        <input
          id="rootName"
          v-model="rootName"
          type="text"
          class="rounded border border-gray-300 px-2 py-1 text-sm"
          placeholder="schema"
        />
      </div>
    </template>
  </format-transformer>
</template>
