/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
var slatwalladmin;
(function (slatwalladmin) {
    class SWNumbersOnly {
        constructor() {
            this.restrict = "A";
            this.require = "ngModel";
            this.scope = {
                ngModel: '=',
                minNumber: '=?',
                maxNumber: '=?'
            };
            this.link = ($scope, element, attrs, modelCtrl) => {
                modelCtrl.$parsers.push((inputValue) => {
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
    }
    slatwalladmin.SWNumbersOnly = SWNumbersOnly;
    angular.module('slatwalladmin').directive('swNumbersOnly', [() => new SWNumbersOnly()]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../../directives/common/swnumbersonly.js.map