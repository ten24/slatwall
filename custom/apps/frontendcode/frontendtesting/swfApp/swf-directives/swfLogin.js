/**
 * This directive will create a form logging in a user.
 * 
 */
angular.module('slatwall').directive('swfLogin', [
        function() { 
            return {
                restrict: 'E',
                transclude: true,
                controller: 
                	function($scope, $element, $attrs) { 
                		   
                    },
                scope: false,
                templateUrl: '/custom/apps/frontendcode/frontendtesting/swfApp/swf-directive-partials/' + "swfLoginPartial.html",
            };
        }
    ]);