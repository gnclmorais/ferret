<template>
<tr>
  <td :data-id="place.id" :data-place-id="place.place_id">
    <div class="row">
      <div class="nine columns">
        <div><strong>{{ place.name }}</strong></div>
        <div>{{ place.address }}</div>
      </div>
      <div class="two columns">
        <button v-on:click="remove(place)">Remove</button>
      </div>
    </div>
  </td>
</tr>
</template>

<script>
export default {
  props: ['place', 'map'],
  methods: {
    remove: function (place) {
      this.$http.delete('/pins/' + place.id)
        .then(_success => {
          this.$emit('removePlace', place);
        }, failure => {
          // TODO error callback
          console.log('did not remove:', failure);
        });
    },
  },
};
</script>

<style></style>
