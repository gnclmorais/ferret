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
import * as _ from 'lodash'

import { PlacesBus } from '../buses.js'
import MapUtils from '../utils/maps'

export default {
  props: ['map', 'place'],
  data() {
    return {
      marker: null,
    };
  },
  destroyed() {
    console.log('destroyed', this.marker);

    if (this.marker) this.marker.setMap(null);
  },
  methods: {
    focusOnMap: function (place) {
      console.log('Clicked on:', place);

      const geocoder = new google.maps.Geocoder();

      geocoder.geocode({
        'address': place.formatted_address
      }, (results, status) => {
        if (status !== google.maps.GeocoderStatus.OK) {
          console.log('Problems with search:', status);
          return;
        }

        const result = results[0];
        const location = result.geometry.location;

        // Adapt map bounds to the kind of place
        map.fitBounds(result.geometry.viewport);

        if (!this.marker) {
          const marker = new google.maps.Marker({
            position: location,
            map: map,
          });
          this.marker = marker;
        }

        // Recentre the map based on the clicked point
        // const delta = window.screen.width / 3;
        // MapUtils.offsetCenter(map, location, delta);
      });
    },
    addToList: function (place, event) {
      console.log('Map:', this.map);
      console.log('Place:', place);

      const placeAttributes = _.extend(
        _.pick(place, [
          'id', 'place_id', 'name', 'formatted_address'
        ]),
        {
          lat: place.geometry.location.lat(),
          lng: place.geometry.location.lng(),
        }
      );

      this.$http.post('/pins', {
        map: this.map,
        place: placeAttributes,
      }).then(success => {
        PlacesBus.$emit('addPlace', success.body);
      }, failure => {
        switch (failure.status) {
          case 409:
            this.$toasted.show('Already added to this map');
            break;
          default:
            this.$toasted.show('Request failed, try again later');
            break;
        }
      });
    },
  },
};
</script>

<style lang="scss" scoped>
.search-result {
  padding: 10px;
}
.search-result:nth-child(even) { background-color: #ffffff; }
.search-result:nth-child(odd)  { background-color: #f8f8f8; }
</style>
