/**
 * Returns true if the uservalue is empty and false otherwise
 */

angular.module('slatwalladmin').directive("swvalidationrequired", function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationrequired = 
            	function(modelValue, viewValue) {
        				if (modelValue)
        				{
        					return true; 
        				}
        			return false;
        		}
        }
    };
});