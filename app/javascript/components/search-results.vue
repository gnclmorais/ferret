<template>
<div class="search-results box is-paddingless" v-if="results.length">
  <search-result v-for="place in results" :place="place" :map="map" :key="place.id">
  </search-result>
</div>
</template>

<script>
import Item from './search-result.vue'

export default {
  props: ['map', 'results'],
  components: {
    'search-result': Item,
  }
};
</script>

<style lang="scss">
.search-results {
  max-height: 600px;
  overflow: auto;
}
</style>
