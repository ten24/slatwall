'use strict';
angular.module('slatwalladmin').directive('swCollection', [
    '$http',
    '$compile',
    '$log',
    'collectionPartialsPath',
    'collectionService',
    function ($http, $compile, $log, collectionPartialsPath, collectionService) {
        return {
            restrict: 'A',
            templateUrl: collectionPartialsPath + "collection.html",
            link: function (scope, $element, $attrs) {
                scope.toggleCogOpen = $attrs.toggleoption;
                //Toggles open/close of filters and display options
                scope.toggleFiltersAndOptions = function () {
                    if (scope.toggleCogOpen === false) {
                        scope.toggleCogOpen = true;
                    }
                    else {
                        scope.toggleCogOpen = false;
                    }
                };
            }
        };
    }
]);

//# sourceMappingURL=../../directives/collection/swcollection.js.map