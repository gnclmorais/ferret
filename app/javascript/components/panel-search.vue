<template>
  <div class="panel-search">
    <search-input v-on:search="search" v-on:clear="clear"></search-input>
    <search-list :map="map" :results="places"></search-list>
    <div class="box media no-results" v-if="noResults">
      <div class="media-content">No places found</div>
    </div>
  </div>
</template>

<script>
import Input from './search-input.vue'
import List from './search-results.vue'

import { PlacesBus } from '../buses.js'

const store = [];

export default {
  props: ['map'],
  data() {
    return {
      noResults: false,
      places: []
    }
  },
  components: {
    'search-input': Input,
    'search-list': List,
  },
  methods: {
    search(query) {
      if (typeof google === "undefined") {
        this.noResults = true;
        PlacesBus.$emit('searchDone', 'No Google; are you online?');
        return;
      }

      var service = new google.maps.places.PlacesService(window.map);

      service.textSearch({
        query: query,
      }, (results, status) => {
        PlacesBus.$emit('searchDone');

        if (status != google.maps.places.PlacesServiceStatus.OK) {
          console.log('Errors:', status);
        }

        console.log('Places found:', results.length)
        this.places = results;
        this.noResults = results.length === 0;
      });
    },
    clear() {
      this.noResults = false;
      this.places = []
    }
  }
};
</script>

<style lang="scss">
.panel-search {
  position: relative;
  z-index: 1;
}

.no-results {
  background-color: white;
  margin-top: 15px;
}
</style>
