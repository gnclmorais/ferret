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
    <div class="level">
      <div class="level-left">
        <div v-for="(tag, index) in place.tagged_pins" class="level-item">
          <div class="tags has-addons">
            <button class="tag is-dark" v-on:click="filterByTag(tag)">
              {{ tag.name }}
            </button>
            <a class="tag is-delete" href="#"
               v-on:click="removeTag(index)"
               v-if="tag.id && loggedIn"></a>
          </div>
        </div>
        <div class="level-item" v-if="loggedIn">
          <button class="tag is-light" v-on:click="focusTagInput" v-show="!addingTag">
            + add tag
          </button>
          <input class="input is-small" type="text" v-show="addingTag"
                 @keyup.enter="saveTag" @keyup.esc="blurTagInput"
                 v-model="tagInput" ref="tagInput">
        </div>
      </div>
    </div>
  </div>
  <span class="item-handle icon" v-show="false">
    <i class="fa fa-bars"></i>
  </span>
  <div class="media-right" v-show="loggedIn">
    <button class="button" v-on:click="remove(place)">Remove</button>
  </div>
</li>
</template>

<script>
import Vue from 'vue'
import { PlacesBus } from '../buses.js'
import MapUtils from '../utils/maps'

function postTaggedPin(tag_name, pin_id) {
  console.log('tag:', tag_name);
  console.log('pin:', pin_id);

  Vue.http.post('/tagged_pins', {
    tagged_pin: { tag_name, pin_id },
  }).then(success => {
    const newTag = success.body;
    console.log('new tag:', newTag);

    const i = this.place.tagged_pins.findIndex(tag => tag.name === newTag.name);
    console.log('found tag at ' + i)
    this.$set(this.place.tagged_pins, i, newTag);

    // TODO
    console.log('success tagging a pin', success)
  }, failure => {
    switch (failure.status) {
      case 409:
        // TODO
        console.log('error 409 while tagging a pin')
        break;
      default:
        // TODO
        console.log('error while tagging a pin')
        break;
    }
  });
};

const deleteTaggedPin = (id, name) => {
  if (!id) {
    console.log('That’s not right, we need an Id for TaggedPin');
    return;
  }

  Vue.http.delete(`/tagged_pins/${id}`).then(success => {
    // TODO
    console.log('deleted a tag on a pin')
  }, failure => {
    switch (failure.status) {
      case 409:
        // TODO
        console.log('error 409 while deleting a tag on a pin');
        break;
      default:
        // TODO
        console.log('error while deleting a tag on a pin');
        break;
    }
  });
};

export default {
  props: ['place', 'map'],
  data() {
    return {
      alreadyFetched: {},
      focused: false,
      loggedIn: this.$store.state.loggedIn,
      addingTag: false,
      tags: [],
      tagInput: '',
    };
  },
  mounted() {
    PlacesBus.$on('focusPlace', this.focusOnList);
    document.addEventListener('click', this.handleClickOutside);
  },
  destroyed() {
    document.removeEventListener('click', this.handleClickOutside);
  },
  methods: {
    handleClickOutside(event) {
      if (!this.$el.contains(event.target)) {
        this.addingTag = false;
      }
    },
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
    focusTagInput() {
      this.addingTag = true;
      this.$nextTick(() => this.$refs.tagInput.focus());
    },
    blurTagInput() {
      this.addingTag = false;
    },
    saveTag() {
      const tag = this.tagInput;

      this.place.tagged_pins.push({ name: tag });
      this.tagInput = '';
      this.addingTag = false;

      postTaggedPin.bind(this)(tag, this.place.id);
    },
    removeTag(index) {
      const [removedTag] = this.place.tagged_pins.splice(index, 1);

      if (removedTag) {
        console.log('delete tag', removedTag);
        deleteTaggedPin(removedTag.id, removedTag.name);
      }
    },
    filterByTag(tag) {
      this.$emit('filterByTag', tag);
    },
  },
};
</script>

<style lang="scss" scoped>
@import '~bulma/bulma';

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

li {
  // &:nth-child(odd) {
  //   background-color: whitesmoke;
  // }

  &::before {
    content: counter(places-counter);
    counter-increment: places-counter;

    color: white;
    background: $info;
    margin-right: 5px;
    border-radius: 50%;
    min-width: 25px;
    height: 25px;
    text-align: center;
  }
}
</style>
