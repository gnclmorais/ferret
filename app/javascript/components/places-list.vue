<template>
<div class="content" v-if="localPlaces.length">
  <places-list-item v-for="(place, index) in localPlaces" :key="place.id"
                    :place="place" :map="map"
                    v-on:removePlace="remove(index)">
  </places-list-item>
</div>
<p v-else class="has-text-centered">
  No places in the map yet
</p>
</template>

<script>
import Item from './places-list-item.vue';

import { PlacesBus } from '../buses.js'

export default {
  props: ['map', 'places'],
  data() {
    return {
      localPlaces: this.places
    }
  },
  methods: {
    remove: function (index) {
      this.localPlaces.splice(index, 1)
    },
  },
  components: {
    'places-list-item': Item,
  },
  beforeCreate() {
    PlacesBus.$on('addPlace', place => {
      console.log('New place added:', place)

      this.places.unshift(place)
    })
  }
};
</script>

<style lang="scss">
.panel-places {
  position: relative;
  z-index: 1;
}
</style>
