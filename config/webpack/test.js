const merge = require('webpack-merge')
const environment = require('./environment')
const customConfig = require('./custom')

module.exports = merge({
  resolve: {
    alias: {
      vue: 'vue/dist/vue.js',
    },
  },
}, environment.toWebpackConfig(), customConfig)
