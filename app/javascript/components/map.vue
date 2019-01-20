<template>
<div>
  <div id="map"></div>
  <button type="button" class="button button--reset-zoom" title="Reset zoom"
          v-on:click="setMapBoundaries">
    <span class="icon">
      <i class="fas fa-compress-arrows-alt"></i>
    </span>
  </button>
  <button type="button" class="button button--where-am-i" title="Where am I?"
          v-on:click="showMyLocation">
    <span class="icon">
      <i class="fas fa-map-marked-alt"></i>
    </span>
  </button>
</div>
</template>

<script>
import * as loadMap from 'load-google-maps-api'
import { Promise } from 'bluebird'
import * as _ from 'lodash'

import { PlacesBus } from '../buses.js'
import MapInfoCard from './MapInfoCard.js'
import MapUtils from '../utils/maps'

const showCard = (map, marker, place) => {
  const infoWindow = new google.maps.InfoWindow({
    content: MapInfoCard(place),
  });
  infoWindow.open(map, marker);
  return infoWindow;
};

let previouslyOpenCard;
const makeMarker = (markers, place, map, number, location) => {
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

  marker.addListener('click', function (mmap, pplace, mmarker) {
    PlacesBus.$emit('focusPlace', pplace);

    if (previouslyOpenCard) previouslyOpenCard.close();
    previouslyOpenCard = showCard(mmap, mmarker, pplace);
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
      myLocation: {},
    };
  },
  computed: {
    allPlaces() {
      return this.localPlaces || [];
    },
  },
  created() {
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
            makeMarker(
              this.markers,
              place,
              this.map,
              number,
              results[0].geometry.location
            );

            resolve();
          }, error => {
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
      const latLngBounds = new google.maps.LatLngBounds();

      this.markers.forEach(marker => latLngBounds.extend(marker.getPosition()));

      // Set a max zoom for the focus...
      this.map.setOptions({ maxZoom: 15 });

      // ... adjust map zoom to fit all markers...
      this.map.fitBounds(latLngBounds);

      // ... and now reset the zoom for users to do whatever they want!
      _.debounce(() => this.map.setOptions({ maxZoom: null }));
    },
    loadLocation() {
      const geoMarker = new GeolocationMarker(window.map);

      window.google.maps.event.
        addListenerOnce(geoMarker, 'position_changed', () => {
          this.myLocation = {
            center: geoMarker.getPosition(),
            bounds: geoMarker.getBounds(),
            timestamp: new Date().getTime(),
          };
          map.setCenter(this.myLocation.center);
          map.fitBounds(this.myLocation.bounds);
        });
    },
    showMyLocation() {
      // Try HTML5 geolocation
      if (navigator.geolocation) {
        if (this.myLocation.center && this.myLocation.bounds) {
          map.setCenter(this.myLocation.center);
          map.fitBounds(this.myLocation.bounds);

          const howLongAgo = new Date().getTime() - (this.myLocation.timestamp || 0);
          if (howLongAgo < 5000) return;
        }

        import('geolocation-marker').then(this.loadLocation);
      } else {
        // Browser doesn't support Geolocation
        alert('Sorry, your browser doesn’t support that feature');
      }
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
  top: 10px;
  right: 10px;
}

.button--where-am-i {
  position: absolute;
  z-index: 1;
  top: 55px;
  right: 10px;
}
</style>
