/**
 * Returns true if the user value is greater than the minimum value.
 */
angular.module('slatwalladmin').directive("swvalidationminvalue", [function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationminvalue = 
            	function(modelValue, viewValue) {
        				var constraintValue = attributes.swvalidationminvalue;
        				var userValue = viewValue || 0;
        				if (parseInt(modelValue) >= parseInt(constraintValue))
        				{
        					return true;
        				}
        			return false;
        			
        		};
        }
    };
}]);