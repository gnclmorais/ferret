const path = require('path');

const ExtractTextPlugin = require('extract-text-webpack-plugin');

// https://storybook.js.org/configurations/custom-webpack-config/
module.exports = (baseConfig, env, defaultConfig) => {
  defaultConfig.resolve.alias.vue = 'vue/dist/vue.js';

  defaultConfig.module.rules.push({
    test: /\.scss$/,
    use: [{
      loader: "style-loader"
    }, {
      loader: "css-loader", options: {
        sourceMap: true,
      },
    }, {
      loader: "sass-loader", options: {
        sourceMap: true,
      }
    }],
  });
  defaultConfig.module.rules.push({
    test: /\.css$/,
    loader: 'style-loader!css-loader',
    options: {
      sourceMap: true,
    },
    include: __dirname,
  });

  return defaultConfig;
};
