(function (angular) {

    'use strict';

    //Generic   

    function makeArray(arr) {
        if(!arr){
            return [];
        }
        return angular.isArray(arr) ? arr : [arr];
    }

    //Angular

    function provideRootElement(modules, element) {
        element = angular.element(element);
        modules.unshift(['$provide',
            function ($provide) {
                $provide.value('$rootElement', element);
            }]);
    }

    function createInjector(injectorModules, element) {
        var modules = ['ng'].concat(makeArray(injectorModules));
        if (element) {
            provideRootElement(modules, element);
        }
        return angular.injector(modules);
    }
    
    /**
     * `config = {  strictDi: boolean }`
     * `strictDi` - disable automatic function annotation for the application. 
     * This is meant to assist in finding bugs which break minified code. 
     * 
     * Defaults to `false`.
     * 
     */
    function bootstrapApplication(angularApp, config) {
        
        angular.element(document).ready(function () {
        	try{
        	    // https://docs.angularjs.org/api/ng/function/angular.bootstrap
	        	if(angular.isArray(angularApp)){
	        		angular.bootstrap(document, angularApp, config);
	        	}
	        	else {
	        		angular.bootstrap(document, [angularApp], config);
	        	}
	        //if bootstrap fails then fall back to ui.bootstrap exclusively
        	}
        	catch(e) {
        	    console.error(e);
        		angular.bootstrap(document, ['ui.bootstrap'], config);
        	}
        });
    }

    angular.lazy = function (app, modules) {

        var injector = createInjector(modules),
            $q = injector.get('$q'),
            promises = [],
            loadingCallback = angular.noop,
            doneCallback = angular.noop;

        var errorCallback =  (e) => console.error(`Boogtstraping ${app} FAILED`, e);
            
        return {

            resolve: function (promise) {
                promise = $q.when(injector.instantiate(promise));
                promises.push(promise);
                return this;
            },

            bootstrap: function (strictDi=false) {
                loadingCallback();

                return $q.all(promises)
                    .then(function () {
                        bootstrapApplication(app, { 'strictDi': strictDi } );
                    }, errorCallback)
                    .finally(doneCallback);
            },

            loading: function(callback){
                loadingCallback = callback;
                return this;
            },

            done: function(callback){
                doneCallback = callback;
                return this;
            },

            error: function(callback){
                errorCallback = callback;
                return this;
            }
        };

    };

})(angular);