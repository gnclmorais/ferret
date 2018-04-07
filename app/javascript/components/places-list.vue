<template>
<div class="list-wrapper">
  <article class="message" v-show="isFiltered">
    <div class="message-body">
      Filtered by <strong>{{ filteringTag.name }}</strong>
      <br>
      <button class="is-button" v-on:click="clearFilter">Clear filter</button>
    </div>
  </article>

  <ol class="content list" v-if="localPlaces.length">
    <places-list-item v-for="(place, index) in localPlaces" :key="place.id"
                      :place="place" :map="map"
                      v-on:removePlace="remove(index)"
                      v-on:filterByTag="onFilterByTag">
    </places-list-item>
  </ol>
  <p v-else class="has-text-centered">
    No places in the map yet
  </p>
</div>
</template>

<script>
import Vue from 'vue'
import Sortable from 'sortablejs'
// Vue.use(Sortable)

import { PlacesBus } from '../buses.js'

import Item from './places-list-item.vue'

export default {
  props: ['map', 'places'],
  data() {
    return {
      originalPlaces: this.places,
      localPlaces: this.places,
      isFiltered: false,
      filteringTag: {},
    }
  },
  methods: {
    onUpdate: function (event) {
      // TODO: Actually save the new order
      this.$http.put(`/maps/${this.map}`, {
        id: this.map,
        pins: this.localPlaces.map(pin => pin.id),
      })
        .then(() => {
          console.log('updated!');
          // TODO success
        }, (err) => {
          console.log('error', err);
          // TODO
        });

      PlacesBus.$emit('updated', this.localPlaces);
      // TODO: Simply re-render the current map view
    },
    remove: function (index) {
      this.localPlaces.splice(index, 1)

      PlacesBus.$emit('updated', this.localPlaces);
    },
    onFilterByTag: function (tag) {
      this.localPlaces = this.originalPlaces.filter((place) => {
        return place.tagged_pins.find((tagged_pin) => {
          return tagged_pin.name === tag.name;
        });
      });
      this.filteringTag = tag;
      this.isFiltered = true;
    },
    clearFilter: function () {
      this.localPlaces = this.originalPlaces;
      this.filteringTag = {};
      this.isFiltered = false;
    },
  },
  components: {
    'places-list-item': Item,
  },
  beforeCreate() {
    PlacesBus.$on('addPlace', place => {
      console.log('New place added:', place)

      this.localPlaces.unshift(place)
      PlacesBus.$emit('updated', this.localPlaces)
    })
  },
  mounted() {
    // Disable sorting for now
    // new Sortable(this.$el, {
    //   handle: '.item-handle',
    //   onUpdate: this.onUpdate,
    // })
  },
};
</script>

<style lang="scss" scoped>
@import '~bulma/bulma';

.list-wrapper {
  overflow: auto;
}

.panel-places {
  position: relative;
  z-index: 1;
}

ol {
  counter-reset: places-counter;
}

li::before {
  content: counter(places-counter);
  counter-increment: places-counter;

  color: white;
  background: $info;
  margin-right: 5px;
  border-radius: 50%;
  min-width: 25px;
  height: 25px;
  text-align: center;
}
</style>
