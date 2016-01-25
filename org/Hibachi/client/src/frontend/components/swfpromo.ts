/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />   
class SWFPromoController{
    // @ngInject
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private $hibachi, private dialogService:any){
        this.$hibachi = $hibachi; 
    }
}

class SWFPromo implements ng.IDirective{
    
    public restrict:string = 'E';
    public scope = {};
    public bindToController={};
    public controller=SWFPromoController
    public controllerAs="SWFPromo";
    public templateUrl;
    
    // @ngInject
    constructor(private hibachiPathBuilder, private frontendPartialsPath ){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(frontendPartialsPath)+'promopartial.html';
    }
    // @ngInject
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}
    
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
			hibachiPathBuilder,
			frontendPartialsPath
        ) => new SWFPromo(
			hibachiPathBuilder,
			frontendPartialsPath
        );
        directive.$inject = [
			'hibachiPathBuilder',
            'frontendPartialsPath'
        ];
        return directive;
    }
 
}
export {
  SWFPromoController, SWFPromo  
};

