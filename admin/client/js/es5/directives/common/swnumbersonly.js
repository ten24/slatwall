/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    var SWNumbersOnly = (function () {
        function SWNumbersOnly() {
            this.restrict = "A";
            this.require = "ngModel";
            this.scope = {
                ngModel: '=',
                minNumber: '=?',
                maxNumber: '=?'
            };
            this.link = function ($scope, element, attrs, modelCtrl) {
                modelCtrl.$parsers.unshift(function (inputValue) {
                    var modelValue = modelCtrl.$modelValue;
                    if (inputValue != "" && !isNaN(Number(inputValue))) {
                        if (angular.isDefined($scope.minNumber)) {
                            if (Number(inputValue) >= $scope.minNumber || !angular.isDefined($scope.minNumber)) {
                                modelCtrl.$setValidity("minNumber", true);
                            }
                            else if (angular.isDefined($scope.minNumber)) {
                                modelCtrl.$setValidity("minNumber", false);
                            }
                        }
                        if (angular.isDefined($scope.maxNumber)) {
                            if (Number(inputValue) <= $scope.maxNumber || !angular.isDefined($scope.maxNumber)) {
                                modelCtrl.$setValidity("maxNumber", true);
                            }
                            else if (angular.isDefined($scope.maxNumber)) {
                                modelCtrl.$setValidity("maxNumber", false);
                            }
                        }
                        if (modelCtrl.$valid) {
                            modelValue = Number(inputValue);
                        }
                        else {
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
