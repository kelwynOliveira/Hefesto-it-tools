import { Braces } from '@vicons/tabler';
import { defineTool } from '../tool';
import { translate } from '@/plugins/i18n.plugin';

export const tool = defineTool({
  name: translate('tools.json-to-zod.title'),
  path: '/json-to-zod',
  description: translate('tools.json-to-zod.description'),
  keywords: ['json', 'parse', 'zod', 'convert', 'transform'],
  component: () => import('./json-to-zod.vue'),
  icon: Braces,
  createdAt: new Date('2025-07-18'),
});
