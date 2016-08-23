//example usage: webpack --config webpack-frontend-develop.config.js -p

var devConfig = require('./webpack.config');

devConfig
    .setupApp(__dirname, './frontend/bootstrap.ts')
    .setOutputName('slatwall_frontend.js')
;

module.exports = devConfig;