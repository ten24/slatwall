var slatwalladmin;
(function (slatwalladmin) {
    class SWNumbersOnly {
        constructor() {
            this.restrict = "A";
            this.require = "ngModel";
            this.scope = {
                ngModel: '=',
                minNumber: '=?'
            };
            this.link = ($scope, element, attrs, modelCtrl) => {
                modelCtrl.$parsers.push(function (inputValue) {
                    var modelValue = modelCtrl.$modelValue;
                    if (inputValue != "" && !isNaN(Number(inputValue))) {
                        if ((angular.isDefined($scope.minNumber) && Number(inputValue) > $scope.minNumber) || !angular.isDefined($scope.minNumber)) {
                            modelValue = Number(inputValue);
                        }
                        else if (angular.isDefined($scope.minNumber)) {
                            modelValue = $scope.minNumber;
                        }
                    }
                    return modelValue;
                });
            };
        }
    }
    slatwalladmin.SWNumbersOnly = SWNumbersOnly;
    angular.module('slatwalladmin').directive('swNumbersOnly', [() => new SWNumbersOnly()]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swnumbersonly.js.map
