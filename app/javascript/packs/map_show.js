import Vue from 'vue'
import VueResource from 'vue-resource'
Vue.use(VueResource)

import store from '../store/index.js'
import setState from '../store/state.js'

import List from '../components/places-list.vue'
import Map from '../components/map.vue'

document.addEventListener('DOMContentLoaded', () => {
  setState(store);

  new Vue({
    store,
    el: '#places-list',
    render(h) {
      return h(List, {
        props: {
          //loggedIn: this.$el.attributes[":logged_in"].value === "true",
          map: JSON.parse(this.$el.attributes[":map"].value),
          places: JSON.parse(this.$el.attributes[":places"].value),
        },
      });
    },
  });

  new Vue({
    el: '#map',
    render(h) {
      return h(Map, {
        props: {
          'places': JSON.parse(this.$el.attributes[":places"].value),
        },
      });
    },
  });
})
