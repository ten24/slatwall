angular.module('slatwalladmin')
    .directive('swListingDisplay', [
    '$log',
    '$timeout',
    '$location',
    '$slatwall',
    'formService',
    'productPartialsPath',
    'paginationService',
    function ($log, $timeout, $location, $slatwall, formService, productPartialsPath, paginationService) {
        return {
            restrict: 'E',
            scope: {},
            templateUrl: productPartialsPath + "listingDisplay.html",
            link: function (scope, element, attrs) {
            } //<--End link
        };
    }
]);

//# sourceMappingURL=../../directives/product/swlistingpages.js.map