/* eslint no-console: 0 */
// Run this example by adding <%= javascript_pack_tag 'hello_vue' %> (and
// <%= stylesheet_pack_tag 'hello_vue' %> if you set extractStyles to true
// in config/webpack/loaders/vue.js) to the head of your layout file,
// like app/views/layouts/application.html.erb.
// All it does is render <div>Hello Vue</div> at the bottom of the page.

// import Vue from 'vue';
// import * as VueGoogleMaps from 'vue2-google-maps';

// import App from '../app.vue';
// import Map from '../components/app.vue';

// Vue.use(VueGoogleMaps, {
//   load: {
//     key: process.env.GOOGLE_MAPS_API_KEY,
//     libraries: 'places',
//   }
// });

// document.addEventListener('DOMContentLoaded', () => {
//   document.body.appendChild(document.createElement('hello'));
//   const app = new Vue(App).$mount('hello');
// });


// The above code uses Vue without the compiler, which means you cannot
// use Vue to target elements in your existing html templates. You would
// need to always use single file components.
// To be able to target elements in your existing html/erb templates,
// comment out the above code and uncomment the below
// Add <%= javascript_pack_tag 'hello_vue' %> to your layout
// Then add this markup to your html template:
//
// <div id='hello'>
//   {{message}}
//   <app></app>
// </div>

import Vue from 'vue'
import VueResource from 'vue-resource'

import List from '../components/places-list.vue'
import Map from '../components/map.vue'
import Search from '../components/panel-search.vue'

Vue.use(VueResource)

document.addEventListener('DOMContentLoaded', () => {
  // TODO: Remove when solved
  Vue.config.devtools = true;

  const app = new Vue({
    el: '#edit-map',
    template: '#template-edit-map',
    data: {
      message: 'Can you say hello?'
    },
    components: {
      'v-places-list': List,
      'v-search-panel': Search,
      'v-map': Map,
    },
  })
})
