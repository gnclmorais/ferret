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
  resolve: {
    alias: {
      jquery: 'jquery/src/jquery',
    },
  },
  plugins: [
    new Dotenv({
      path: '.env',
      systemvars: true,
      safe: true,
    }),
    new webpack.ProvidePlugin({
       $: 'jquery',
    }),
  ],
  entry: {
    vendor: ['jquery', 'jquery-ujs'],
  },
}
