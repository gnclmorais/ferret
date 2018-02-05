import Vue from 'vue'
import VueResource from 'vue-resource'

import List from '../components/places-list.vue'
import Map from '../components/map.vue'

Vue.use(VueResource)

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#places-list',
    render(h) {
      return h(List, {
        props: {
          loggedIn: this.$el.attributes[":logged_in"].value === "true",
          map: JSON.parse(this.$el.attributes[":map"].value),
          places: JSON.parse(this.$el.attributes[":places"].value),
        },
      });
    },
  });

  new Vue({
    el: '#map',
    render: h => h(Map),
  });
})
