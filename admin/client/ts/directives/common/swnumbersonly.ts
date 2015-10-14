module slatwalladmin {
    
    
    export class SWNumbersOnly implements ng.IDirective{
        public restrict = "A";
        public require = "ngModel";
        public scope = {
            ngModel:'=',
            minNumber:'=?'
        }
        
        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, modelCtrl: ng.INgModelController) =>{

            modelCtrl.$parsers.push(function (inputValue) {
                var modelValue = modelCtrl.$modelValue;
                
                if(inputValue != "" && !isNaN(Number(inputValue))){ 
                    if((angular.isDefined($scope.minNumber) && Number(inputValue) > $scope.minNumber) || !angular.isDefined($scope.minNumber)){
                        modelValue = Number(inputValue);
                    } else if (angular.isDefined($scope.minNumber)){
                        modelValue = $scope.minNumber;
                    }
                }

                return modelValue;
            });
		}
    }
    
    angular.module('slatwalladmin').directive('swNumbersOnly',[() => new SWNumbersOnly()]); 

}