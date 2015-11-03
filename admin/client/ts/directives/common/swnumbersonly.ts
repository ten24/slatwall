/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />
module slatwalladmin {
    
    export class SWNumbersOnly implements ng.IDirective{
        public restrict = "A";
        public require = "ngModel";
        public scope = {
            ngModel:'=',
            minNumber:'=?', 
            maxNumber:'=?'
        }
        
        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, modelCtrl: ng.INgModelController) =>{

            modelCtrl.$parsers.push((inputValue) =>{
                var modelValue = modelCtrl.$modelValue;
                if(inputValue != "" && !isNaN(Number(inputValue))){ 
                    if(angular.isDefined($scope.minNumber)){
                        if(Number(inputValue) >= $scope.minNumber || !angular.isDefined($scope.minNumber)){
                            modelCtrl.$setValidity("minNumber", true);
                        } else if (angular.isDefined($scope.minNumber)){
                            modelCtrl.$setValidity("minNumber", false);
                        }
                    }
                    if(angular.isDefined($scope.maxNumber)){
                        if(Number(inputValue) <= $scope.maxNumber || !angular.isDefined($scope.maxNumber)){
                            modelCtrl.$setValidity("maxNumber", true);
                        } else if (angular.isDefined($scope.maxNumber)){
                            modelCtrl.$setValidity("maxNumber", false);
                        }
                    }

                    if(modelCtrl.$valid){
                        modelValue = Number(inputValue);  
                    } else { 
                        modelValue = $scope.minNumber;
                    }
                }

                return modelValue;
            });
            
            
		}
    }
    
    angular.module('slatwalladmin').directive('swNumbersOnly',[() => new SWNumbersOnly()]); 

}