/**
 * True if the data type matches the given data type.
 */
/**
 * Validates true if the model value is a numeric value.
 */
angular.module('slatwalladmin').directive("swvalidationdatatype", [function() {
    return {
        restrict: "A",
        require: "^ngModel",
         
        link: function(scope, element, attributes, ngModel) {
                var MY_EMAIL_REGEXP =  /^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$/;
        		ngModel.$validators.swvalidationdatatype = 
            	function(modelValue) {
        			if (angular.isString(modelValue) && attributes.swvalidationdatatype === "string"){return true;}
        			if (angular.isNumber(parseInt(modelValue)) && attributes.swvalidationdatatype === "numeric"){return true;}
        			if (angular.isArray(modelValue) && attributes.swvalidationdatatype === "array"){return true;}
        			if (angular.isDate(modelValue) && attributes.swvalidationdatatype === "date"){return true;}
        			if (angular.isObject(modelValue) && attributes.swvalidationdatatype === "object"){return true;}
                    if (attributes.swvalidationdatatype === 'email'){
                        return MY_EMAIL_REGEXP.test(modelValue);
                    }
               	    if	(angular.isUndefined(modelValue && attributes.swvalidationdatatype === "undefined")){return true;}
            		return false;
            };
        }
    };
}]);