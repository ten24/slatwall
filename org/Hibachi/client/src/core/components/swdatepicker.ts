/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDatePicker {
	public _timeoutPromise;
    public restrict = "A";
    public require = "ngModel";
    public scope = {
        options:'<?',
        startDayOfTheMonth:'<?',
        endDayOfTheMonth:'<?',
        startDate:'=?',
        endDate:'=?'
    }

	constructor(){
	}

    public link:ng.IDirectiveLinkFn = ($scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, modelCtrl: ng.INgModelController) =>{
	
	    if(!$scope.options){
	        $scope.options = {
                autoclose: true,
                format: "mm/dd/yyyy",
                setDate: new Date(),
            }
	    }

        if(!$scope.startDayOfTheMonth){
            $scope.startDayOfTheMonth = 1;
        }
        
        if(!$scope.endDayOfTheMonth){
            $scope.startDayOfTheMonth = 31;
        }
        
        if(!$scope.startDate){
            $scope.startDate = Date.now();   
        }
	
	    if(!$scope.endDate){
    	    
    	    $scope.options.beforeShowDay = function(date){
				var dayOfMonth = date.getDate();
				return [ dayOfMonth >= $scope.startDayOfTheMonth && 
				         dayOfMonth <= $scope.endDayOfTheMonth && 
				         date >= $scope.startDate 
				];
			}
	    } else {
	        
	        $scope.options.beforeShowDay = function(date){
				var dayOfMonth = date.getDate();
				return [ dayOfMonth >= $scope.startDayOfTheMonth && 
				         dayOfMonth <= $scope.endDayOfTheMonth && 
				         date >= $scope.startDate &&
				         date < $scope.endDate 
				];
			}
	    }
	
        $(element).datepicker($scope.options);
    }

	public static Factory(){
		var directive = (
        )=> new SWDatePicker(
        );
        directive.$inject = [
        ];
        return directive;
	}

}

export{
    SWDatePicker
}