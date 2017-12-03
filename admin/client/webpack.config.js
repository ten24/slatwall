var devConfig = require('../../org/Hibachi/client/webpack.config');
var webpack = require('webpack');
var path = require('path');
var customPath = __dirname;
console.log("Custom: ", customPath);
var PATHS = {
    app: path.join(customPath, '/src'),
    lib: path.join(customPath, '/lib')
};
if(typeof bootstrap !== 'undefined'){
    devConfig.entry.app[this.entry.app.length - 1] = bootstrap;
}
devConfig.output.path = PATHS.app;
devConfig.context = PATHS.app;
        
module.exports = devConfig;