"use strict";

/**
 * True if the data type matches the given data type.
 */
/**
 * Validates true if the model value is a numeric value.
 */
angular.module("slatwalladmin").directive("swvalidationdatatype", [function () {
    return {
        restrict: "A",
        require: "^ngModel",

        link: function (scope, element, attributes, ngModel) {
            ngModel.$validators.swvalidationdatatype = function (modelValue) {
                if (angular.isString(modelValue) && attributes.swvalidationdatatype === "string") {
                    return true;
                }
                if (angular.isNumber(parseInt(modelValue)) && attributes.swvalidationdatatype === "numeric") {
                    return true;
                }
                if (angular.isArray(modelValue && attributes.swvalidationdatatype === "array")) {
                    return true;
                }
                if (angular.isDate(modelValue && attributes.swvalidationdatatype === "date")) {
                    return true;
                }
                if (angular.isObject(modelValue && attributes.swvalidationdatatype === "object")) {
                    return true;
                }
                if (angular.isUndefined(modelValue && attributes.swvalidationdatatype === "undefined")) {
                    return true;
                }
                return false;
            };
        }
    };
}]);