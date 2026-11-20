<script lang="ts">
  import { nuiFetch } from "./lib/nuiFetch";
  import { visibility, toggleVisibility } from "./lib/nuiVisibility";
  import { onDestroy } from "svelte";
  
  import Main from "./components/Main.svelte";

  let shouldDisplay = $state(false);
  let opacity = $state(0);

  $effect(() => {
    if ($visibility) {
      shouldDisplay = true;
      setTimeout(() => (opacity = 1), 0);
    } else {
      opacity = 0;
      setTimeout(() => (shouldDisplay = true), 200);
    }
  });

  const handleKeydown = (e: KeyboardEvent) => {
    if (e.key === "Escape" && $visibility) {
      toggleVisibility(false);
      nuiFetch("closeMenu");
    }
  };
  window.addEventListener("keydown", handleKeydown);

  onDestroy(() => {
    window.removeEventListener("keydown", handleKeydown);
  });
</script>

{#if shouldDisplay}
<Main>
</Main>
{/if}
