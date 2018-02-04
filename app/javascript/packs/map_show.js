import Vue from 'vue'
import VueResource from 'vue-resource'

import Map from '../components/map.vue'

Vue.use(VueResource)

document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#map',
    render: h => h(Map),
  });
})
