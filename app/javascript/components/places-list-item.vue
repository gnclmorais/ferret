<template>
<li class="media item" :class="{ focus: focused }"
    :data-id="place.id" :data-place-id="place.place_id">
  <div class="media-content" v-on:click="focusOnMap(place.place)">
    <div class="content">
      <p>
        <strong>{{ place.place.name }}</strong>
        <br>
        {{ place.place.address }}
      </p>
    </div>
  </div>
  <span class="item-handle icon" v-show="this.$store.state.loggedIn">
    <i class="fa fa-bars"></i>
  </span>
  <div class="media-right" v-show="this.$store.state.loggedIn">
    <button class="button" v-on:click="remove(place)">Remove</button>
  </div>
</li>
</template>

<script>
import { PlacesBus } from '../buses.js'
import MapUtils from '../utils/maps'

export default {
  props: ['place', 'map'],
  data() {
    return {
      alreadyFetched: {},
      focused: false,
      loggedIn: this.$store.state.loggedIn
    };
  },
  mounted() {
    PlacesBus.$on('focusPlace', this.focusOnList);
  },
  methods: {
    // loggedIn() {
    //   console.log('Store', this.$store)
    //   console.log('Logged in?', )
    //   return this.$store.getters.isLoggedIn()
    // },
    focusOnList(place) {
      console.log('Focused place:', place, this.place.id, place.id);
      if (this.place.id !== place.id) {
        this.focused = false
        return;
      }

      this.$el.scrollIntoView(false, {
        behavior: 'smooth',
        block: 'center',
        inline: 'nearest',
      });

      this.focused = true;
      setTimeout(() => { this.focused = false; }, 3000);
    },
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
          icon: '/assets/icons/pin.svg',
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

<style lang="scss" scoped>
.item {
  position: relative;
}

.item-handle {
  cursor: row-resize;
  position: absolute;
  left: 0;
  top: 30px;

  .item + .item & {
    top: 45px;
  }
}

@keyframes highlight {
    0% { background-color: hsl(48, 100%, 67%); }
  100% { background-color: hsl(0, 0%, 100%); }
}

.focus {
  animation-name: highlight;
  animation-duration: 3s;
  animation-timing-function: ease-in;
}
</style>
