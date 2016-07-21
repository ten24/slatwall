//example usage: webpack --config webpack-frontend-develop.config.js -p
var path = require('path');
var PATHS = {
    app:__dirname + '/src'
};

var devConfig = require('../../org/Hibachi/client/webpack.config');
devConfig.context=PATHS.app,
//points to the bootstrap located in the frontend modules directory.
devConfig.entry.app = "./bootstrap.ts";
devConfig.output = {
    path: PATHS.app,
    filename: 'bundle.js'
  };

module.exports = devConfig;