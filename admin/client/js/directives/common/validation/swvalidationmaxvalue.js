/**
 * Returns true if the user value is greater than the min value.
 */
angular.module('slatwalladmin').directive("swvalidationmaxvalue", [function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationmaxvalue = 
            	function(modelValue, viewValue) {

        				var constraintValue = attributes.swvalidationmaxvalue;
        				var userValue = viewValue || 0;
        				if (parseInt(viewValue) <= parseInt(constraintValue))
        				{
        					return true;
        				}
        			return false;
        			
        		};
        }
    };
}]);