<template>
<div>
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
</div>
</template>

<script>
export default {
  props: ['place', 'map'],
  methods: {
    remove: function (place) {
      this.$http.delete('/pins/' + place.id).then(response => {
        //var data = JSON.parse(response.body);
        //console.log('remove successful:', data);

        console.log('remove successful:', place);
        this.$emit('remove', place);
      }, response => {
        var data = JSON.parse(response.body);

        // TODO error callback
        console.log('did not remove:', response);
      });
    },
  },
};
</script>

<style></style>
