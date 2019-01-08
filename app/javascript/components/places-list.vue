<template>
<div class="list-wrapper">
  <article class="message is-marginless" v-show="isFiltered">
    <div class="message-body">
      Filtered by <strong>{{ filteringTag.name }}</strong>
      <br>
      <button class="is-button" v-on:click="clearFilter">Clear filter</button>
    </div>
  </article>

  <ol class="content list" v-if="localPlaces.length">
    <places-list-item v-for="(place, index) in localPlaces" :key="place.id"
                      :index="index" :place="place" :map="map"
                      v-on:removePlace="remove(index)"
                      v-on:filterByTag="onFilterByTag">
    </places-list-item>
  </ol>

  <article v-else class="message has-text-centered has-background-white">
    <p class="message-body">
      No places in the map yet
    </p>
  </article>
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
      originalPlaces: this.places.map((place, i) => {
        place.index = i + 1;
        return place;
      }),
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

      place.index = this.localPlaces.length + 1;
      this.localPlaces.push(place);

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
.list-wrapper {
  overflow: auto;
}

.padding-giver {
  padding: 20px;
}
</style>
