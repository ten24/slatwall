/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
interface SWScope extends ng.IScope{
    ngModel:any,
    currencyCode:string
}

class SWCurrencyFormatter {
	public _timeoutPromise;
    public restrict = "A";
    public require = "ngModel";
    public scope = {
        ngModel:'=',
        currencyCode:'@?'
    }

	constructor(public $filter:ng.IFilterService, public $timeout:ng.ITimeoutService){
	}

    public link:ng.IDirectiveLinkFn = ($scope:SWScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, modelCtrl: ng.INgModelController) =>{
        modelCtrl.$parsers.push((data)=>{
            var currencyFilter:any = this.$filter('swcurrency');
            
            if(isNaN(data)){
                data = 0;
                modelCtrl.$setViewValue(currencyFilter(data,$scope.currencyCode,2,false));
                modelCtrl.$render();
            } else {
                if(this._timeoutPromise){
                    this.$timeout.cancel(this._timeoutPromise);
                }

                this._timeoutPromise = this.$timeout(()=>{
                    modelCtrl.$setViewValue(currencyFilter(data,$scope.currencyCode,2,false));
                    modelCtrl.$render();
                }, 1500);
            }

            return modelCtrl.$viewValue;
        });
         modelCtrl.$formatters.push((data)=>{
            
            if(isNaN(data)){
                data = 0;
            }
            var currencyFilter:any = this.$filter('swcurrency');
            modelCtrl.$setViewValue(currencyFilter(data,$scope.currencyCode,2,false));
            modelCtrl.$render();

            return modelCtrl.$viewValue;
        });
	}

	public static Factory(){
		var directive = (
            $filter,
            $timeout
        )=> new SWCurrencyFormatter(
            $filter,
            $timeout
        );
        directive.$inject = [
            '$filter',
            '$timeout'
        ];
        return directive;
	}

}

export{
    SWCurrencyFormatter
}