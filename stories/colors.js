import Vue from 'vue';

import '../app/stylesheets/bulma.scss';

import { storiesOf } from '@storybook/vue';

// Color square
Vue.component('sample', {
  props: ['name', 'color'],
  data() {
    return {
      parent: {
        padding: '20px',
      },
      dimensions: {
        width: '100px',
        height: '100px',
      }
    };
  },
  template: `<div :style="parent">
    <strong>{{ name }}</strong>
    <div :style="dimensions" :class="color"></div>
  </div>`,
});

storiesOf('Colors', module)
  .add('Primary', () => ({
    template: '<sample name="Primary" color="has-background-primary"></sample>',
  }));
