/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFLogoutController{
    //@ngInject
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private $hibachi:any){
        this.$hibachi = $hibachi; 
    }
}
class SWFLogout implements ng.IDirective{
    
    public restrict:string = 'E';
    public scope = {};
    public bindToController={};
    public controller=SWFLogoutController
    public controllerAs="SWFLogout";
    public templateUrl;
    
    // @ngInject
    constructor(private hibachiPathBuilder, private frontendPartialsPath ){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(frontendPartialsPath)+'logoutdirectivepartial.html';
    }
    
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}
    
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
			hibachiPathBuilder,
            frontendPartialsPath
        ) => new SWFLogout(
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
  SWFLogoutController, SWFLogout  
};
