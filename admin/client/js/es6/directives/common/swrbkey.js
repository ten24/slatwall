'use strict';
angular.module('slatwalladmin')
    .directive('swRbkey', [
    '$slatwall',
    'observerService',
    'utilityService',
    '$rootScope',
    '$log',
    function ($slatwall, observerService, utilityService, $rootScope, $log) {
        return {
            restrict: 'A',
            scope: {
                swRbkey: "="
            },
            link: function (scope, element, attrs) {
                var rbKeyValue = scope.swRbkey;
                var bindRBKey = function () {
                    if (angular.isDefined(rbKeyValue) && angular.isString(rbKeyValue)) {
                        element.text($slatwall.getRBKey(rbKeyValue));
                    }
                };
                if (!$slatwall.getRBLoaded()) {
                    observerService.attach(bindRBKey, 'hasResourceBundle');
                }
                else {
                    bindRBKey();
                }
            }
        };
    }]);

//# sourceMappingURL=../../directives/common/swrbkey.js.map