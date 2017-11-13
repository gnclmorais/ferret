const Dotenv = require('dotenv-webpack')

module.exports = {
  resolve: {
    alias: {
      'vue$': 'vue/dist/vue.esm.js',
    }
  },
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
      safe: true
    })
  ]
}
