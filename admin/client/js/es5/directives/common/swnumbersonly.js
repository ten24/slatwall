var slatwalladmin;
(function (slatwalladmin) {
    var SWNumbersOnly = (function () {
        function SWNumbersOnly() {
            this.restrict = "A";
            this.require = "ngModel";
            this.scope = {
                ngModel: '=',
                minNumber: '=?'
            };
            this.link = function ($scope, element, attrs, modelCtrl) {
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
        return SWNumbersOnly;
    })();
    slatwalladmin.SWNumbersOnly = SWNumbersOnly;
    angular.module('slatwalladmin').directive('swNumbersOnly', [function () { return new SWNumbersOnly(); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=swnumbersonly.js.map
