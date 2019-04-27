<template>
  <li class="media item" :class="classObject"
      :data-id="place.id" :data-place-id="place.place_id" :data-index="place.index">
    <div class="media-content media-content--max-width" v-on:click="focusOnMap(place.place)">
      <div class="content">
        <p>
          <span class="has-text-weight-bold"
                v-show="!title.editing" v-on:click.stop="focusTitleInput">
            {{ place.name }}
          </span>
          <input :class="{ input: true, 'is-small': true, 'is-danger': title.hasError }"
                 type="text" v-show="title.editing"
                 @keyup.enter="saveTitle(place.name)"
                 @keyup.esc="blurTitleInput"
                 v-on:input="onTitleChange"
                 v-model="title.input" ref="titleInput">
          <br>
          {{ place.place.address }}
        </p>
      </div>
      <div class="level">
        <div class="level-left level-left--wrap">
          <div v-for="(tag, index) in place.tagged_pins" class="level-item">
            <div class="tags has-addons">
              <button class="tag is-light" v-on:click.stop="filterByTag(tag)">
                {{ tag.name }}
              </button>
              <a class="tag is-delete" href="#"
                 v-on:click.stop="removeTag(index)"
                 v-if="tag.id && loggedIn"></a>
            </div>
          </div>
          <div class="level-item" v-if="loggedIn">
            <button class="tag is-light" v-on:click.stop="focusTagInput" v-show="!addingTag">
              + add tag
            </button>
            <input :class="{ input: true, 'is-small': true, 'is-danger': hasError }"
                   type="text" v-show="addingTag"
                   @keyup.enter="saveTag" @keyup.esc="blurTagInput"
                   v-on:input="onChange"
                   v-model="tagInput" ref="tagInput">
          </div>
        </div>
      </div>
    </div>
    <span class="item-handle icon" v-show="false">
      <i class="fa fa-bars"></i>
    </span>
    <div class="media-right" v-show="loggedIn">
      <button class="button is-white" title="Edit name"
              v-on:click.stop="focusTitleInput" v-show="!title.editing">
        <span class="icon"><i class="fas fa-pen-square"></i></span>
      </button>
      <br class="is-hidden">
      <button class="button is-danger is-inverted" title="Remove from map"
              v-on:click="remove(place)">
        <span class="icon"><i class="fa fa-minus-square"></i></span>
      </button>
    </div>
  </li>
</template>

<script>
  import Vue from 'vue'
  import { PlacesBus } from '../buses.js'
  import MapUtils from '../utils/maps'

  import { updatePin } from 'modules/pins';
  import { postTaggedPin, deleteTaggedPin } from 'modules/tagged-pins';

  export default {
    props: ['index', 'place', 'map'],
    data() {
      return {
        alreadyFetched: {},
        focused: false,
        loggedIn: this.$store.state.loggedIn,
        addingTag: false,
        tags: [],
        tagInput: '',
        hasError: false,
        title: {
          input: this.place.name,
          editing: false,
          hasError: false,
        },
      };
    },
    computed: {
      classObject() {
        return {
          focus: this.focused,
          even: this.isEven(),
        };
      },
    },
    mounted() {
      PlacesBus.$on('focusPlace', this.focusOnList);
      document.addEventListener('click', this.handleClickOutside);
    },
    destroyed() {
      document.removeEventListener('click', this.handleClickOutside);
    },
    methods: {
      isEven() {
        return this.index % 2 !== 0;
      },
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
        if (this.timeout) {
          clearTimeout(this.timeout);
          console.log('clearTimeout');
        }

        if (this.place.id !== place.id) {
          this.focused = false
          return;
        }
        console.log('Focused place:', place, this.place.id, place.id);

        this.$el.scrollIntoView(false, {
          behavior: 'smooth',
          block: 'center',
          inline: 'nearest',
        });

        this.focused = true;
        this.timeout = setTimeout(() => { this.focused = false; }, 3000);
      },
      focusOnMap: function (place) {
        console.log('Clicked on:', place);

        const fetchedLocation = this.alreadyFetched[place.id];
        if (fetchedLocation) {
          map.panTo(fetchedLocation);
          return;
        }

        if (place.lat && place.lng) {
          const location = new google.maps.LatLng(place.lat, place.lng);
          map.panTo(location);
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

          console.log('Viewport:', result.geometry.viewport)

          // Adapt map bounds to the kind of place
          map.fitBounds(result.geometry.viewport);

          const marker = new google.maps.Marker({
            position: location,
            map: map,
          });

          PlacesBus.$emit('markerAdded', marker);

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
      focusTitleInput() {
        if (!this.loggedIn) return;

        this.title.editing = true;
        this.$nextTick(() => this.$refs.titleInput.focus());
      },
      focusTagInput() {
        this.addingTag = true;
        this.$nextTick(() => this.$refs.tagInput.focus());
      },
      blurTitleInput() {
        this.title.editing = false;
      },
      blurTagInput() {
        this.addingTag = false;
      },
      alreadyExists(tag) {
        return this.place.tagged_pins.findIndex(
          tagged_pin => tagged_pin.name === tag
        ) > -1;
      },
      saveTitle(oldTitle) {
        const newTitle = this.title.input.trim();

        // Reset title input
        this.title.editing = false;

        if (this.title.input === oldTitle) {
          console.log('Title is the same, skipping…');
          this.hasError = false;
          return;
        }

        updatePin(this.place.id, newTitle);

        this.place.name = newTitle;
      },
      saveTag() {
        const tag = this.tagInput.trim();

        if (this.alreadyExists(tag)) {
          console.log('Repeated tag, place add something different');
          this.hasError = true;
          return;
        }

        this.place.tagged_pins.push({ name: tag });
        this.tagInput = '';
        this.addingTag = false;

        postTaggedPin(this, tag, this.place.id);
      },
      removeTag(index) {
        const [removedTag] = this.place.tagged_pins.splice(index, 1);

        if (removedTag) {
          console.log('delete tag', removedTag);
          deleteTaggedPin(removedTag.id, removedTag.name);
        }
      },
      onTitleChange() {
        this.title.hasError = false;
      },
      onChange() {
        this.hasError = false;
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

  .even {
    background: $white-ter;
  }

  li {
    &::before {
      content: attr(data-index);
      color: white;
      background: $info;
      margin-right: 5px;
      border-radius: 50%;
      min-width: 25px;
      height: 25px;
      text-align: center;
    }

    margin: 0px !important; // Override .media rules
    padding: 20px;
  }

  .media-content--max-width {
    max-width: 100%;
  }

  .level-left--wrap {
    flex-wrap: wrap;
    max-width: 100%
  }
</style>
