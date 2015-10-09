/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('hibachiScope')
    .directive('swLoginForm', [
        '$slatwall',
        'hibachiScopeService',
        function($slatwall, hibachiScopeService) {
            return {
                restrict: 'E',
                transclude: true,
                scope: false,
                templateUrl: '/custom/apps/slatwallcms/incstore/assets/js/ng-directive-partials/swLoginFormPartial.html',
                replace: false,
                link: 
                        function(scope, element, attrs) {
                            
                            
                            
                        }
            };
        }
    ]);