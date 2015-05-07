/**
 * Validates true if the model value matches a regex string.
 */
angular.module('slatwalladmin').directive("swvalidationregex", [function () {
    return {
        restrict: "A",
        require: "^ngModel",
        link: function (scope, element, attributes, ngModel) {
            ngModel.$validators.swvalidationregex = function (modelValue) {
                //Returns true if this user value (model value) does match the pattern 
                var pattern = attributes.swvalidationregex;
                var regex = new RegExp(pattern);
                if (regex.test(modelValue)) {
                    return true;
                }
                else {
                    return false;
                }
            };
        }
    };
}]);

//# sourceMappingURL=../../../directives/common/validation/swvalidationregex.js.map