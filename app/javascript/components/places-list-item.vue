<template>
<div class="media" :data-id="place.id" :data-place-id="place.place_id">
  <div class="media-content" v-on:click="focusOnMap(place.place)">
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
import MapUtils from '../utils/maps'

export default {
  props: ['loggedIn', 'place', 'map'],
  data() {
    return {
      alreadyFetched: {},
    };
  },
  methods: {
    focusOnMap: function (place) {
      console.log('Clicked on:', place);

      const fetchedLocation = this.alreadyFetched[place.id];
      if (fetchedLocation) {
        map.panTo(fetchedLocation);
        return;
      }

      const geocoder = new google.maps.Geocoder();

      geocoder.geocode({
        'address': place.address
      }, (results, status) => {
        if (status !== google.maps.GeocoderStatus.OK) {
          console.log('Problems with search:', status);
          return;
        }

        const result = results[0];
        const location = result.geometry.location;

        // Adapt map bounds to the kind of place
        map.fitBounds(result.geometry.viewport);

        const marker = new google.maps.Marker({
          position: location,
          map: map,
        });

        // Recentre the map based on the clicked point
        map.panTo(location);

        this.alreadyFetched[place.id] = location;
      });
    },
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
