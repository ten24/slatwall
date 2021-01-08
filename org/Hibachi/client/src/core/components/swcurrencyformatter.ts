/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
interface SWScope extends ng.IScope{
    ngModel:any,
    currencyCode:string,
    locale:string
}

class SWCurrencyFormatter {
	public _timeoutPromise;
    public restrict = "A";
    public require = "ngModel";
    public scope = {
        ngModel:'=',
        currencyCode:'@?',
        locale:'@?'
    }

    // @ngInject;
	constructor(public $filter:ng.IFilterService, public $timeout:ng.ITimeoutService){
	}

    public link:ng.IDirectiveLinkFn = ($scope:SWScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, modelCtrl: ng.INgModelController) =>{
        if(element[0].nodeName == 'INPUT'){
            $scope.locale = 'en-us';
        }
        modelCtrl.$parsers.push((data)=>{

            var currencyFilter:any = this.$filter('swcurrency');
            
            if(this._timeoutPromise){
                this.$timeout.cancel(this._timeoutPromise);
            }

            this._timeoutPromise = this.$timeout(()=>{
                
                modelCtrl.$setViewValue(
                    currencyFilter(data, $scope.currencyCode, 2, false, $scope.locale)
                );
                
                modelCtrl.$render();
                
            }, 1500);
            
            return modelCtrl.$viewValue;
        });
        
        modelCtrl.$formatters.push((data)=>{

            var currencyFilter:any = this.$filter('swcurrency');
            
            modelCtrl.$setViewValue(
                currencyFilter(data, $scope.currencyCode, 2, false, $scope.locale)
            );
            modelCtrl.$render();

            return  modelCtrl.$viewValue;
        });
	}

	public static Factory(){
		return /** @ngInject; */ ($filter,$timeout) => new this($filter,$timeout);
	}

}

export{
    SWCurrencyFormatter
}