<template lang="haml">
.map-wrapper
  #map
</template>

<script>
import * as loadMap from 'load-google-maps-api'

export default {
  created: function () {
    loadMap({
      key: process.env.GOOGLE_MAPS_API_KEY,
      libraries: ['places'],
    })
    .then(function (_googleMaps) {
      var map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: -34.397, lng: 150.644 },
        zoom: 8,
      });

      window.map = map;

      console.log('Key:', process.env.GOOGLE_MAPS_API_KEY);
    })
    .catch(function (err) {
      console.error(err);
    });
  }
};
</script>

<style lang="scss">
#edit-map {
  height: 100%;
}

#map {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  z-index: -1;
  background-color: lightblue; // TODO: Remove this
}
</style>
