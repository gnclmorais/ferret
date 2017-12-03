<template lang="haml">
.map-wrapper
  #map
</template>

<script>
import _ from 'lodash'
import Vue from 'vue'
import * as loadMap from 'load-google-maps-api'

var store = {
  debug: true,
  state: {
    results: [],
    places: [],
  },

  setSearch: function (newSearch) {
    if (this.debug) console.log('setSearch triggered with', newSearch);
    this.state.results = newSearch;
  },
  clearSearch: function () {
    if (this.debug) console.log('clearSearch triggered')
    this.state.results = [];
  },

  addPlace: function (newPlace) {
    if (this.debug) console.log('addPlace triggered with', newPlace);
    this.state.places.unshift(newPlace);
  },
  removePlace: function (oldPlace) {
    if (this.debug) console.log('removePlace triggered with', oldPlace);
    const index = this.state.places.indexOf(oldPlace);

    if (index > -1) this.state.places.splice(index, 1);
  },
  setPlaces: function (newPlaces) {
    if (this.debug) console.log('setPlaces triggered with', newPlaces);
    this.state.places = newPlaces;
  },
  clearPlaces: function () {
    if (this.debug) console.log('clearPlaces triggered')
    this.state.places = [];
  }
}

function searchPlaces() {
  Vue.component('search-places', {
    data: function () {
      return { query: null };
    },
    template: '<input type="text"' +
              'placeholder="Search by name or address"' +
              'v-model="query"' +
              'v-on:input="debounceInput" />',
    watch: {
      query: function () {
        this.debounceInput();
      }
    },
    methods: {
      debounceInput: _.debounce(function () {
        if (!this.query) return;

        console.log('Searching for:', this.query);
        var service = new google.maps.places.PlacesService(window.map);
        service.textSearch({
          query: this.query,
        }, function (results, status) {
          if (status == google.maps.places.PlacesServiceStatus.OK) {
            store.setSearch(results);
          } else {
            store.clearSearch();
          }
        });
      }, 500),
    },
  });
};

function listPlaces(existingPlaces) {
  store.setPlaces(existingPlaces);

  Vue.component('places-list-item', {
    props: ['place', 'map'],
    template: '<tr>' +
        '<td data-id="{{ place.id }}" data-place-id="{{ place.place_id }}">' +
          '<div class="row">' +
            '<div class="nine columns">' +
              '<div><strong>{{ place.name }}</strong></div>' +
              '<div>{{ place.address }}</div>' +
            '</div>' +
            '<div class="two columns">' +
              '<button v-on:click="remove(place)">' +
                'Remove' +
              '</button>' +
            '</div>' +
          '</div>' +
        '</td>' +
      '</tr>',
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
  });

  Vue.component('places-list', {
    props: ['map'],
    data: function () {
      return store.state;
    },
    template: '<table v-if="places.length">' +
      '<tbody>' +
        '<places-list-item v-for="place in places" :key="place.id" :place="place" :map="map" v-on:remove="remove(place)"></places-list-item>' +
      '</tbody>' +
    '</table>' +
    '<p v-else>No places :(</p>',
    methods: {
      remove: function (place) {
        console.log('Removing:', place);

        store.removePlace(place);
      },
    }
  });

  //
  // Search results

  Vue.component('search-results', {
    props: ['map'],
    data: function () {
      return store.state;
    },
    template: '<table v-if="results.length">' +
      '<tbody>' +
        '<search-result v-for="place in results" :place="place" :map="map" >' +
        '</search-result>' +
      '</tbody>' +
    '</table>' +
    '<p v-else>No places :(</p>',
  });

  Vue.component('search-result', {
    props: ['map', 'place'],
    template: '<tr>' +
        '<td data-id="{{ place.id }}" data-place-id="{{ place.place_id }}">' +
          '<div class="row">' +
            '<div class="three columns">' +
              '<button v-on:click="addToList(place, $event)">' +
                '+ add' +
              '</button>' +
            '</div>' +
            '<div class="nine columns">' +
              '<div><strong>{{ place.name }}</strong></div>' +
              '<div>{{ place.formatted_address }}</div>' +
            '</div>' +
          '</div>' +
        '</td>' +
      '</tr>',
    methods: {
      addToList: function (place, event) {
        debugger;
        console.log('this.places:', this.places);

        this.$http.post('/pins', {
          // TODO pin details
          map: this.map,
          place: place,
        }).then(response => {
          var data = JSON.parse(response.body);

          // TODO
          console.log('response success:', data);

          store.addPlace(data.place);
        }, response => {
          var data = JSON.parse(response.body);

          // TODO error callback
          console.log('response failuer:', response);
        });
      },
    },
  });
};

searchPlaces();
//listPlaces(JSON.parse(this.params.places));

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
