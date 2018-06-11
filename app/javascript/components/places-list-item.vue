<template>
  <li class="media item" :class="{ focus: focused }"
      :data-id="place.id" :data-place-id="place.place_id" :data-index="place.index">
    <div class="media-content" v-on:click="focusOnMap(place.place)">
      <div class="content">
        <p>
          <strong v-show="!title.editing" v-on:click.stop="focusTitleInput">
            {{ place.name }}
          </strong>
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
        <div class="level-left">
          <div v-for="(tag, index) in place.tagged_pins" class="level-item">
            <div class="tags has-addons">
              <button class="tag is-dark" v-on:click="filterByTag(tag)">
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
      <button class="button is-white is-hidden" title="Edit name"
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
    props: ['place', 'map'],
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
        if (this.timeout) {
          clearTimeout(this.timeout);
          console.log('clearTimeout');
        }

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
        this.timeout = setTimeout(() => { this.focused = false; }, 3000);
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

        postTaggedPin.bind(this)(tag, this.place.id);
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
  }
</style>
