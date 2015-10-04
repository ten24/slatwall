/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('slatwalladmin').directive('swfLogin', [
        '$slatwall',
        function($slatwall) {
            return {
                restrict: 'E',
                transclude: true,
                scope: false,
                templateUrl: '/admin/client/partials/frontend/swfLoginPartial.html',
                replace: false,
                link: 
                        function(scope, element, attrs) {
                         console.log("Instantiated Front-end login directive");   
                            
                            
                        }
            };
        }
    ]);