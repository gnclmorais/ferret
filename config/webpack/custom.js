const Dotenv = require('dotenv-webpack')
const webpack = require('webpack')

const VueLoaderPlugin = require('vue-loader/lib/plugin');

module.exports = {
  devServer: {
    stats: {
      warnings: false,
    }
  },

  module: {
    rules: [{
      test: /\.vue$/,
      loader: 'vue-loader'
    }, {
      test: /\.js$/,
      loader: 'babel-loader',
      exclude: file => (
        /node_modules/.test(file) &&
        !/\.vue\.js/.test(file)
      )
    }, {
      test: /\.css$/,
      loader: ['vue-style-loader', 'css-loader'],
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
    },
  },
  plugins: [
    new Dotenv({
      path: '.env',
      systemvars: true,
      safe: true,
    }),
    new webpack.ProvidePlugin({
    }),
    new VueLoaderPlugin(),
  ],
}
