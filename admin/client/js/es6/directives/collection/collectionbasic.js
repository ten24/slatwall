angular.module('slatwalladmin').directive('swCollectionBasic', [
    '$log',
    '$location',
    '$slatwall',
    'formService',
    'collectionPartialsPath',
    function ($log, $location, $slatwall, formService, collectionPartialsPath) {
        return {
            restrict: 'A',
            scope: {
                collection: "="
            },
            templateUrl: collectionPartialsPath + "collectionbasic.html",
            link: function (scope, element, attrs) {
            }
        };
    }
]);

//# sourceMappingURL=../../directives/collection/collectionbasic.js.map