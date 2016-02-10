//example usage: webpack --config webpack-frontend-develop.config.js -p

var devConfig = require('./webpack.config');
var ngAnnotatePlugin = require('ng-annotate-webpack-plugin');

//points to the bootstrap located in the frontend modules directory.
devConfig.entry.app = "./frontend/bootstrap.ts";

//change output filename
devConfig.output.filename = "slatwall_frontend.js";
module.exports = devConfig;