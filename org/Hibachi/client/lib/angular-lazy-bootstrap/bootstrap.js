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

    function bootstrapApplication(angularApp) {
        angular.element(document).ready(function () {
        	try{
	        	if(angular.isArray(angularApp)){
	        		angular.bootstrap(document, angularApp);
	        	}else{
	        		angular.bootstrap(document, [angularApp]);
	        	}
	        //if bootstrap fails then fall back to ui.bootstrap exclusively
        	}catch(e){
        		angular.bootstrap(document, ['ui.bootstrap']);
        	}
        });
    }

    angular.lazy = function (app, modules) {

        var injector = createInjector(modules),
            $q = injector.get('$q'),
            promises = [],
            errorCallback = angular.noop,
            loadingCallback = angular.noop,
            doneCallback = angular.noop;

        return {

            resolve: function (promise) {
                promise = $q.when(injector.instantiate(promise));
                promises.push(promise);
                return this;
            },

            bootstrap: function () {

                loadingCallback();

                return $q.all(promises)
                    .then(function () {
                        bootstrapApplication(app);
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