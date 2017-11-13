<template>
<table v-if="results.length">
  <tbody>
    <search-result v-for="place in results" :place="place" :map="map" >
    </search-result>
  </tbody>
</table>
<p v-else>No places :(</p>
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

<style>

</style>
