<template>
<div class="field">
  <label for="search-input" class="label">Search</label>
  <div class="control">
    <input type="input"
           name="search-input"
           class="input"
           placeholder="e.g. Happy Bones nyc"
           v-model="query"
           v-on:input="debounceInput" />
  </div>
</div>
</template>

<script>
import * as _ from 'lodash'

export default {
  data: function () {
    return { query: null };
  },
  watch: {
    query: function () {
      this.debounceInput();
    }
  },
  methods: {
    debounceInput: _.debounce(function () {
      if (!this.query) return;
      console.log('Searching for:', this.query);

      this.$emit('search', this.query);
    }, 500),
  },
};


// function listPlaces(existingPlaces) {
//   store.setPlaces(existingPlaces);


//   Vue.component('search-result', {
//   });
// };

// searchPlaces();
// listPlaces(JSON.parse(this.params.places));

// new Vue({
//   el: '.v-interactive', //'.v-results',
//   data: store,
//   components: { App },
//   // TODO: where is the template?
//   created: function () {
//     var that = this;

//     var $map = document.getElementById('map');

//     var map = new google.maps.Map($map, {
//       center: {lat: -33.8688, lng: 151.2195},
//       zoom: 13,
//       mapTypeId: 'roadmap',
//     });

//     window.map = map;

//     // Text Search service
//     var service = new google.maps.places.PlacesService(map);

//     // Create the search box and link it to the UI element.
//     //var input = document.getElementById('pac-input');
//     var input = $('.js-search-place').get(0);
//     return; // TODO Move this code into a proper component

//     var searchBox = new google.maps.places.SearchBox(input);
//     //map.controls[google.maps.ControlPosition.TOP_LEFT].push(input);

//     // Bias the SearchBox results towards current map's viewport.
//     map.addListener('bounds_changed', function() {
//       searchBox.setBounds(map.getBounds());
//     });

//     var markers = [];
//     // Listen for the event fired when the user selects a prediction and retrieve
//     // more details for that place.
//     searchBox.addListener('places_changed', function() {
//       var places = searchBox.getPlaces();

//       if (places.length == 0) {
//         return;
//       }

//       // Clear out the old markers.
//       markers.forEach(function(marker) {
//         marker.setMap(null);
//       });
//       markers = [];

//       // For each place, get the icon, name and location.
//       var bounds = new google.maps.LatLngBounds();
//       places.forEach(function(place) {
//         if (!place.geometry) {
//           console.log("Returned place contains no geometry");
//           return;
//         }
//         var icon = {
//           url: place.icon,
//           size: new google.maps.Size(71, 71),
//           origin: new google.maps.Point(0, 0),
//           anchor: new google.maps.Point(17, 34),
//           scaledSize: new google.maps.Size(25, 25)
//         };

//         // Create a marker for each place.
//         markers.push(new google.maps.Marker({
//           map: map,
//           icon: icon,
//           title: place.name,
//           position: place.geometry.location
//         }));

//         if (place.geometry.viewport) {
//           // Only geocodes have viewport.
//           bounds.union(place.geometry.viewport);
//         } else {
//           bounds.extend(place.geometry.location);
//         }
//       });
//       map.fitBounds(bounds);
//     });
//   },
// });

// export default {
//   created: function () {
//     loadMap({
//       key: process.env.GOOGLE_MAPS_API_KEY,
//       libraries: ['places'],
//     })
//     .then(function (_googleMaps) {
//       var map = new google.maps.Map(document.getElementById('map'), {
//         center: { lat: -34.397, lng: 150.644 },
//         zoom: 8,
//       });

//       console.log('Key:', process.env.GOOGLE_MAPS_API_KEY);
//     })
//     .catch(function (err) {
//       console.error(err);
//     });
//   }
// };
</script>

<style lang="scss">
.u-fullheight {
  height: 100%;
}

.map-wrapper {
  position: relative;
  height: 100%;
}

#map {
  position: absolute;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
}
</style>
