var slatwalladmin;
(function (slatwalladmin) {
    class SWNumbersOnly {
        constructor() {
            this.restrict = "A";
            this.require = "ngModel";
            this.scope = {};
            this.link = (scope, element, attrs, modelCtrl) => {
                modelCtrl.$formatters.push(function (inputValue) {
                    var modelValue = modelCtrl.$modelValue;
                    console.log("model: " + modelValue);
                    console.log("input: " + inputValue);
                    return modelValue;
                });
                modelCtrl.$parsers.push(function (inputValue) {
                    var modelValue = modelCtrl.$modelValue;
                    console.log("model: " + modelValue);
                    console.log("input: " + inputValue);
                    return modelValue;
                });
            };
        }
    }
    slatwalladmin.SWNumbersOnly = SWNumbersOnly;
    angular.module('slatwalladmin').directive('swNumbersOnly', [() => new SWNumbersOnly()]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swnumbersonly.js.map