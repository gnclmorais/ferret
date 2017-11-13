<template>
<tr>
  <td :data-id="place.id" :data-place-id="place.place_id">
    <strong>{{ place.name }}</strong>
    <br>
    {{ place.formatted_address }}
    <br>
    <button v-on:click="addToList(place)">+ add</button>
  </td>
</tr>
</template>

<script>
import { PlacesBus } from '../buses.js'

export default {
  props: ['map', 'place'],
  methods: {
    addToList: function (place, event) {
      console.log('Map:', this.map);
      console.log('Place:', this.place);

      this.$http.post('/pins', {
        // TODO pin details
        map: this.map,
        place: place,
      }).then(success => {
        const data = success.body

        PlacesBus.$emit('addPlace', data.place);
      }, failure => {
        // TODO error callback
        console.log('response failure:', failure);
      });
    },
  },
};
</script>

<style>

</style>
