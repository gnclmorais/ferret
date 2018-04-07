<template>
<div class="box is-paddingless is-clipped">
  <div class="field has-addons">
    <label for="search-input" class="label is-hidden">Search</label>
    <div class="control is-expanded">
      <input type="input"
             id="search-input"
             class="input"
             placeholder="e.g. Happy Bones nyc"
             v-model="query"
             v-on:input="debounceInput" />
    </div>
    <div class="control">
      <button class="button" v-on:click="clear" v-show="this.query">
        <span class="icon"><i class="fa fa-times-circle"></i></span>
      </button>
    </div>
    <div class="control">
      <button class="button is-primary" v-on:click="debounceInput">
        Search
      </button>
    </div>
  </div>
</div>
</template>

<script>
// TODO: Import only debounce?
import * as _ from 'lodash'

import { PlacesBus } from '../buses.js'

export default {
  data: function () {
    return { query: null };
  },
  watch: {
    query() {
      this.debounceInput();
    },
  },
  methods: {
    debounceInput: _.debounce(function () {
      if (!this.query) return;

      console.log('Searching for:', this.query);
      this.$emit('search', this.query);
    }, 500),
    clear() {
      this.query = ''
      this.$emit('clear');
    },
  },
  mounted() {
    PlacesBus.$on('addPlace', this.clear);
  },
};
</script>

<style lang="scss">
</style>
