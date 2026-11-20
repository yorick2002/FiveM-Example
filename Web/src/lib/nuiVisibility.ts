import { writable } from 'svelte/store';
import { nuiFetch } from './nuiFetch';
import { onNuiMessage } from './nuiListen';

export const visibility = writable(false);

onNuiMessage<{ visible: boolean }>('toggleVisibility', (data) => {
    visibility.set(data.visible);
});

export async function toggleVisibility(show: boolean) {
  visibility.set(show);
  await nuiFetch('toggleVisibility', { visible: show });
}