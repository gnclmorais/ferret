<template>
<div>
  <div id="map"></div>
  <button type="button" class="button button--reset-zoom"
          v-on:click="setMapBoundaries">
    Reset zoom
  </button>
</div>
</template>

<script>
import * as loadMap from 'load-google-maps-api'
import { Promise } from 'bluebird'

import { PlacesBus } from '../buses.js'
import MapUtils from '../utils/maps'

export default {
  props: ['places'],
  data() {
    return {
      markers: [],
      map: null,
      localPlaces: this.places
    };
  },
  computed: {
    allPlaces() {
      return this.localPlaces || [];
    },
  },
  mounted() {
    //console.log('Places:', this.localPlaces);
  },
  created() {
    console.log('Places:', this.places);

    loadMap({
      key: process.env.GOOGLE_MAPS_API_KEY,
      libraries: ['places'],
    })
    .then(this.renderMap)
    .catch(console.error);

    PlacesBus.$on('updated', (places) => {
      this.localPlaces = places;
      this.renderMap()
    });
  },
  methods: {
    renderMap() {
      var map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: -34.397, lng: 150.644 },
        zoom: 8,
        mapTypeControl: true,
        mapTypeControlOptions: {
          style: google.maps.MapTypeControlStyle.HORIZONTAL_BAR,
          position: google.maps.ControlPosition.BOTTOM_CENTER
        },
        fullscreenControl: false,
      });

      window.map = map;
      this.map = map;

      this.addAllMarkers();
    },
    addAllMarkers() {
      this.markers = [];

      console.log('this.allPlaces', this.allPlaces);

      Promise.map(this.allPlaces, (place, index) => {
        return new Promise((resolve, reject) => {
          const number = index + 1;

          console.log(`Place ${index}:`, place);

          MapUtils.geocode(place.place.address, results => {
            console.log(`Results for ${index}:`, results);

            let marker = new google.maps.Marker({
              map: this.map,
              label: String(number),
              zIndex: number,
              position: results[0].geometry.location,
            });

            marker.addListener('mouseover', function (mmap, pplace, mmarker) {
              PlacesBus.$emit('focusPlace', pplace);
            }.bind(null, this.map, place, marker));

            this.markers.push(marker);

            resolve();
          }, error => {
            console.log('Error on geocoding:', error);

            reject(new Error(error));
          });
        });
      }).then(() => {
        this.setMapBoundaries();
      }).error(function (e) {
        console.error('Error while putting markers on map:', e.message);
      });
    },
    setMapBoundaries() {
      if (this.markers.length === 0) return;
      console.log('setMapBoundaries');

      const latLngBounds = new google.maps.LatLngBounds();

      this.markers.forEach(marker => {
        console.log('Position:', marker.getPosition());

        latLngBounds.extend(marker.getPosition());
      });

      // Set a max zoom for the focus...
      map.setOptions({ maxZoom: 16 });

      // Center map and adjust Zoom based on the position of all markers.
      this.map.fitBounds(latLngBounds);
      this.map.setCenter(latLngBounds.getCenter());

      // ... and now reset the zoom for users to do whatever they want!
      map.setOptions({ maxZoom: null });
    },
    scrollToPlace() {
      var container = this.$el.querySelector("#container");
      container.scrollTop = container.scrollHeight;
    },
  },
};
</script>

<style lang="scss" scoped>
#map {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: lightblue; // TODO: Remove this
}

.button--reset-zoom {
  position: absolute;
  z-index: 1;
  top: 15px;
  right: 15px;
}
</style>
