/**
 * Validates true if the model value (user value) is a numeric value.
 * @event This event fires on every change to an input.
 */
angular.module('slatwalladmin').directive("swvalidationisnumeric", function() {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function(scope, element, attributes, ngModel) {
        		ngModel.$validators.swvalidationisnumeric = 
            	function(modelValue, viewValue) {
        			//console.log(viewValue);
        			//Returns true if this is not a number.
            		if (!isNaN(viewValue)){
            			return true;
            		}else{
            			return false;
            		}
            }
        }
    };
});