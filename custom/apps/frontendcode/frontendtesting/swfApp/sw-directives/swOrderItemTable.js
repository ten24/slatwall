/**
 * This directive will create a form for displaying a list of orderitems on an order.
 * 
 */
angular.module('hibachiScope')
    .directive('swOrderItemTable', [
        '$slatwall',
        'hibachiScopeService',
        function($slatwall, hibachiScopeService) {
            return {
                restrict: 'E',
                transclude: true,
                scope: {
                    prefix: "@",
                    fieldList: "=",
                    formName: "@"
                },
                templateUrl: '/custom/apps/slatwallcms/incstore/assets/js/ng-directives/swOrderItemTablePartial.html',
                replace: true,
                link: 
                		function(scope, element, attrs) {
                			console.log("This is an orderitem table");
                			
                			
                			
                		}
            };
        }
    ]);