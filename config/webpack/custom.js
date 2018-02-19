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
    }, {
      test: /\.woff(2)?(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      loader: "url-loader?limit=10000&mimetype=application/font-woff"
    }, {
      test: /\.(ttf|eot|svg)(\?v=[0-9]\.[0-9]\.[0-9])?$/,
      loader: "file-loader"
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
