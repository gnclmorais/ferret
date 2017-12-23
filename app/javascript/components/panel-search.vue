<template>
  <div>
    <search-input v-on:search="search"></search-input>
    <search-list :map="map" :results="places"></search-list>
  </div>
</template>

<script>
import Input from './search-input.vue'
import List from './search-results.vue'

const store = [];

export default {
  props: ['map'],
  data() {
    return {
      places: []
    }
  },
  components: {
    'search-input': Input,
    'search-list': List,
  },
  methods: {
    search(query) {
      console.log('Parent searching…', query);

      var service = new google.maps.places.PlacesService(window.map);

      service.textSearch({
        query: query,
      }, (results, status) => {
        if (status != google.maps.places.PlacesServiceStatus.OK) {
          console.log('Errors:', status);
        }

        console.log('Places found:', results.length)
        this.places = results;
      });
    }
  }
};
</script>

<style>
</style>
