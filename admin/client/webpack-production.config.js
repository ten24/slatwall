//webpack --config webpack-production.config.js -p

var WebpackStrip = require('strip-loader');
var devConfig = require('./webpack.config');
var ngAnnotatePlugin = require('ng-annotate-webpack-plugin');

var stripConsolelogs = {
	exlude: /node_modules/,
	loader: WebpackStrip.loader('console.log')
}
//extend and override the devconfig
devConfig.module.loaders.push(stripConsolelogs);

var stripLogDebugs = {
	exlude: /node_modules/,
	loader: WebpackStrip.loader('$log.debug')
}
//extend and override the devconfig
devConfig.module.loaders.push(stripLogDebugs);


devConfig.plugins= [
  	new ngAnnotatePlugin({
        add: true,
        // other ng-annotate options here
    }),
    function()
    {
        /*this.plugin("done", function(stats)
        {
            if (stats.compilation.errors && stats.compilation.errors.length)
            {
            	console.error(stats.compilation.errors);
                
                process.exit(1);
            }
            
        });*/
    }
  ];
devConfig.watch = false;
//change output filename
//devConfig.output.filename = "bundle.min.js";
module.exports = devConfig;
