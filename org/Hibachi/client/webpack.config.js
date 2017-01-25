var webpack = require('webpack');
var ForceCaseSensitivityPlugin = require('force-case-sensitivity-webpack-plugin');

var path = require('path');
var PATHS = {
    app: path.join(__dirname, '/src'),
    lib: path.join(__dirname, '/lib')
};

var appConfig = {
    context:PATHS.app,
    entry: {
        app:['./bootstrap.ts']
    },
    watch:true,
    output: {
        path: PATHS.app,
        filename: 'bundle.js'
    },
    // Turn on sourcemaps
    //devtool: 'source-map',
    resolve: {
        extensions: ['', '.webpack.js', '.web.js', '.ts', '.js'],
        alias:{}
    },
    module: {
        noParse: [ /bower_components/ ],
        loaders: [
            {
                test: /\.ts$/, loader: 'ts-loader',
                exclude: /node_modules/
            }
        ]
    },
    plugins: [
        new ForceCaseSensitivityPlugin()
    ],
    setupApp: function(customPath, bootstrap){
        PATHS = {
            app: path.join(customPath, '/src'),
            lib: path.join(customPath, '/lib')
        };
        if(typeof bootstrap !== 'undefined'){
            this.entry.app[this.entry.app.length - 1] = bootstrap;
        }
        this.output.path = PATHS.app;
        this.context = PATHS.app;
        return this;
    },
    setOutputName: function(outputName){
        this.output.filename = outputName;
        return this;
    },
    addVendor: function (name, vendorPath) {
        this.resolve.alias[name] =  path.join(PATHS.lib, vendorPath);
        this.entry.app.splice(this.entry.app.length - 1, 0, name);
        return this;
    },
    addPlugin: function(plugin){
        this.plugins.push(plugin);
        return this;
    },
    addLoader: function(loader){
        this.module.loaders.push(loader);
        return this;
    }

};
appConfig
    .addVendor('date','date/date.min.js')
    .addVendor('angular','angular/angular.min.js')
    .addVendor('angular-lazy-bootstrap','angular-lazy-bootstrap/bootstrap.js')
    .addVendor('ui.bootstrap','angular-ui-bootstrap/ui.bootstrap.min.js')
    .addVendor('angular-resource','angular/angular-resource.min.js')
    .addVendor('angular-cookies','angular/angular-cookies.min.js')
    .addVendor('angular-route','angular/angular-route.min.js')
    .addVendor('angular-animate','angular/angular-animate.min.js')
    .addVendor('angular-sanitize','angular/angular-sanitize.min.js')
    .addVendor('metismenu','metismenu/metismenu.js')
    .addVendor('angularjs-datetime-picker','angularjs-datetime-picker/angularjs-datetime-picker.js')
    
    
; 
module.exports = appConfig;