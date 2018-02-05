<template>
<div class="media" :data-id="place.id" :data-place-id="place.place_id">
  <div class="media-content">
    <div class="content">
      <p>
        <strong>{{ place.place.name }}</strong>
        <br>
        {{ place.place.address }}
      </p>
    </div>
  </div>
  <div class="media-right" v-show="loggedIn">
    <button class="button" v-on:click="remove(place)">Remove</button>
  </div>
</div>
</template>

<script>
export default {
  props: ['loggedIn', 'place', 'map'],
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
