/**
 * Returns true if the user value is greater than the min length.
 */
/**
 * Returns true if the user value is greater than the minimum value.
 */
angular.module('slatwalladmin').directive("swvalidationminlength", [function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationminlength = 
            	function(modelValue, viewValue) {

        				var constraintValue = attributes.swvalidationminlength;
        				var userValue = viewValue || 0;
        				if (parseInt(viewValue.length) >= parseInt(constraintValue))
        				{
        					
        					return true;
        				}
        				$log.debug('invalid min length');
        			return false;
        			
        		};
        }
    };
}]);