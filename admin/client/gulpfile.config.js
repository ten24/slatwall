'use strict';
var GulpConfig = (function () {
    function GulpConfig() {
        this.source = './admin/client/ts/';

        this.ngSlatwallcfm = './api/views/js/ngslatwall.cfm';

        this.entityPath = './model/entity/*.cfc';
        this.processPath = './model/process/*.cfc';

        this.tsOutputPath = './admin/client' + '/js/es6';
        this.tsOutputPathto5 = './admin/client' + '/js/es5';
        this.allJavaScript = ['./admin/client' + '/js/**/*.js'];
        this.allTypeScript = './src/**/*.ts';

        this.nghibachiTypescript = './client/ts/modules/*.ts';
        this.ngSlatwallOutputPath = './client/js/es6';

        this.typings = './typings/';
        this.libraryTypeScriptDefinitions = './typings/**/*.ts';
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