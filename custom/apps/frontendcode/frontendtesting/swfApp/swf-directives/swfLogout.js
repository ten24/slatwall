/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('slatwall').directive('swfLogout', [
        function() { 
            return {
                restrict: 'E',
                transclude: true,
                controller: 
                	function($scope, $element, $attrs) { 
                		   
                    },
                scope: false,
                templateUrl: '/custom/apps/frontendcode/frontendtesting/swfApp/swf-directive-partials/' + "swfLogoutPartial.html",
            };
        }
    ]);