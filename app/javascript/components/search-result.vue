<template>
<div class="media search-result" v-on:click="focusOnMap(place)">
  <div class="media-left">
    <button title="Add place" class="button" v-on:click="addToList(place)">
      +
    </button>
  </div>
  <div class="media-content" :data-id="place.id" :data-place-id="place.place_id">
    <strong>{{ place.name }}</strong>
    <br>
    {{ place.formatted_address }}
    <br>
  </div>
</div>
</template>

<script>
import { PlacesBus } from '../buses.js'

export default {
  props: ['map', 'place'],
  methods: {
    focusOnMap: function (place) {
      const geocoder = new google.maps.Geocoder();

      geocoder.geocode({
        'address': place.formatted_address
      }, function (results, status) {
        if (status == google.maps.GeocoderStatus.OK) {
          const location = results[0].geometry.location;
          console.log('Location:', location);

          const delta = window.screen.width / 6;

          const newLocation = new google.maps.LatLng(
            location.lat(),
            location.lng() + delta
          );

          // Center map on location
          window.map.setCenter(newLocation);

          // Set map zoom
          window.map.setZoom(14);

          // Add marker on location
          var marker = new google.maps.Marker({
            map: window.map,
            position: results[0].geometry.location,
          });
        } else {
          console.log(
            "Geocode was not successful for the following reason: " + status
          );
        }
      });
    },
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

<style lang="scss">
.search-result {
  padding: 10px;
}
.search-result:nth-child(even) { background-color: #ffffff; }
.search-result:nth-child(odd)  { background-color: #f8f8f8; }

// // // // // // // // // // // // // // // // // // // // // // // // // // //
// Overrides
//
.media + .media {
  margin: 0;
}
</style>
