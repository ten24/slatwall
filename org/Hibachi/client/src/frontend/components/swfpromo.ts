/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />   
class SWFPromoController{
    // @ngInject
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private $slatwall, private dialogService:any){
        this.$slatwall = $slatwall; 
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
    constructor(private pathBuilderConfig, private frontendPartialsPath ){
        this.templateUrl = pathBuilderConfig.buildPartialsPath(frontendPartialsPath)+'promopartial.html';
    }
    // @ngInject
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}
    
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
			pathBuilderConfig,
			frontendPartialsPath
        ) => new SWFPromo(
			pathBuilderConfig,
			frontendPartialsPath
        );
        directive.$inject = [
			'pathBuilderConfig',
            'frontendPartialsPath'
        ];
        return directive;
    }
 
}
export {
  SWFPromoController, SWFPromo  
};

