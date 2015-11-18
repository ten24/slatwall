
    
    
class SWNumbersOnly implements ng.IDirective{
    public restrict = "A";
    public require = "ngModel";
    public scope = {
        ngModel:'=',
        minNumber:'=?'
    }
    
    public static Factory(){
        var directive = () => new SWNumbersOnly();
        directive.$inject = [];
        return directive;
    }
    
    public link:ng.IDirectiveLinkFn = ($scope: any, element:any, attrs:any, modelCtrl: ng.INgModelController) =>{

        modelCtrl.$parsers.push(function (inputValue) {
            var modelValue:any = modelCtrl.$modelValue;
            
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
export{
    SWNumbersOnly
}
    