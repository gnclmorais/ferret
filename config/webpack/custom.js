const Dotenv = require('dotenv-webpack')
const webpack = require('webpack')

module.exports = {
  module: {
    loaders: [{
      test: /\.js$/,
      loader: 'babel',
      exclude: /node_modules/
    }, {
      test: /\.vue$/,
      loader: 'vue'
    }, {
      test: /\.s[a|c]ss$/,
      loader: 'style!css!sass'
    }]
  },
  plugins: [
    new Dotenv({
      path: '.env',
      safe: true,
    }),
    new webpack.ProvidePlugin({
       $: 'jquery',
       jQuery: 'jquery',
    }),
  ]
}
