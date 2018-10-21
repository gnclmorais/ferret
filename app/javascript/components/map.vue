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
import * as _ from 'lodash'

import { PlacesBus } from '../buses.js'
import MapUtils from '../utils/maps'

const makeMarker = (markers, place, map, number, location) => {
  console.log('Number ->', String(number));

  let marker = new google.maps.Marker({
    map: map,
    animation: google.maps.Animation.DROP,
    label: {
      text: String(number),
      color: 'white',
    },
    zIndex: number + 100,
    position: location,
    optimized: false,
  });

  marker.addListener('mouseover', function (mmap, pplace, mmarker) {
    console.log('hovering on', pplace)

    PlacesBus.$emit('focusPlace', pplace);
  }.bind(null, map, place, marker));

  markers.push(marker);
};

export default {
  props: ['places'],
  data() {
    return {
      markers: [],
      map: null,
      focusedMarker: null,
      localPlaces: this.places,
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
      this.renderMap();
    });

    PlacesBus.$on('markerAdded', (marker) => {
      this.focusedMarker = marker;
    });
  },
  methods: {
    renderMap() {
      if (this.map) {
        this.clearAllMarkers();
      } else {
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
      }

      this.addAllMarkers();
    },
    clearAllMarkers() {
      // developers.google.com/maps/documentation/javascript/markers#remove
      this.markers.map(x => x.setMap(null));
      this.markers.length = 0;

      if (this.focusedMarker) {
        this.focusedMarker.setMap(null);
        this.focusedMarker = null;
      }
    },
    addAllMarkers() {
      this.markers = [];

      console.log('this.allPlaces', this.allPlaces);

      Promise.map(this.allPlaces, (place, index) => {
        return new Promise((resolve, reject) => {
          const number = index + 1;

          if (place.place.lat && place.place.lng) {
            makeMarker(
              this.markers,
              place,
              this.map,
              number,
              new google.maps.LatLng(
                place.place.lat, place.place.lng
              ),
            );

            return resolve();
          }

          MapUtils.geocode(place.place.address, results => {
            console.log(`Results for ${index}:`, results);

            makeMarker(
              this.markers,
              place,
              this.map,
              number,
              results[0].geometry.location
            );

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

      this.markers.forEach(marker => latLngBounds.extend(marker.getPosition()));

      // Set a max zoom for the focus...
      this.map.setOptions({ maxZoom: 15 });

      // ... adjust map zoom to fit all markers...
      this.map.fitBounds(latLngBounds);

      // ... and now reset the zoom for users to do whatever they want!
      _.debounce(() => this.map.setOptions({ maxZoom: null }));
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
