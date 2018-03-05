<template lang="haml">
#map
</template>

<script>
import * as loadMap from 'load-google-maps-api'

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
      this.markers = []

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

      //console.log('Key:', process.env.GOOGLE_MAPS_API_KEY);

      this.addAllMarkers();
    },
    addAllMarkers() {
      // TODO: Fix this
      (this.localPlaces || []).forEach((place, index) => {
        MapUtils.geocode(place.place.address, results => {
          let marker = new google.maps.Marker({
            map: this.map,
            label: '' + (index + 1),
            position: results[0].geometry.location,
            icon: '/assets/icons/pin.svg',
          });

          console.log('add listener');
          marker
            .addListener('click', function (mmap, pplace, mmarker) {
              console.log('$emit focusPlace');

              PlacesBus.$emit('focusPlace', pplace);

              //mmap.setCenter(mmarker.getPosition());
            }.bind(null, this.map, place, marker));

          this.markers.push(marker);

          // TODO: Bring Promises as soon as possible
          if (this.markers.length === this.localPlaces.length) {
            this.setMapBoundaries();
          }
        });
      });
    },
    setMapBoundaries() {
      const latLngBounds = new google.maps.LatLngBounds();

      this.markers.forEach(marker => {
        latLngBounds.extend(marker.getPosition());
      });


      //Center map and adjust Zoom based on the position of all markers.
      this.map.fitBounds(latLngBounds);
      this.map.setCenter(latLngBounds.getCenter());
    },
    scrollToPlace() {
      var container = this.$el.querySelector("#container");
      container.scrollTop = container.scrollHeight;
    },
  },
};
</script>

<style lang="scss">
#map {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: lightblue; // TODO: Remove this
}
</style>
