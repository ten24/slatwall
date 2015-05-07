'use strict';
var GulpConfig = (function () {
    function GulpConfig() {
        this.source = './admin/client/ts/';
        
        this.ngSlatwallcfm = './api/views/js/ngslatwall.cfm';
        
        this.tsOutputPath = './admin/client' + '/js/es6';
        this.allJavaScript = ['./admin/client' + '/js/**/*.js'];
        this.allTypeScript = this.source+ '/**/*.ts';
       
        this.ngSlatwallTypescript = './client/ts/modules/*.ts';
        this.ngSlatwallOutputPath = './client/js/es6';
		
        this.typings = './client/typings/';
        this.libraryTypeScriptDefinitions = './client/typings/**/*.ts';
        this.appTypeScriptReferences = this.typings + 'slatwallTypescript.d.ts';
        
        this.compilePath = 'admin/client/js/';
        this.es6Path = './admin/client/js/es6/**/*.js';
        this.es5Path = './admin/client/js/es5/**/*.js';
        this.modelPath = './model/entity/**/*.cfc';
        
        //this.es5Path = 'admin/client/js/es5/**/*.js',
        //this.propertiesPath = 'config/resourceBundles/*.properties',
    }
    return GulpConfig;
})();
module.exports = GulpConfig;