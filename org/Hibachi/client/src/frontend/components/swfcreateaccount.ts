/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFCreateAccountController{
    //@ngInject
    constructor(private $hibachi:any){
        this.$hibachi = $hibachi; 
    }
}

class SWFCreateAccount implements ng.IDirective {
    
    public restrict:string = 'E';
    public scope = {};
    public bindToController={};
    public controller=SWFCreateAccountController;
    public controllerAs="SwfCreateAccount";
    public templateUrl;
    
    public static Factory():ng.IDirectiveFactory{
    var directive:ng.IDirectiveFactory = (
        pathBuilderConfig,
        frontendPartialsPath
    ) => new SWFCreateAccount(
        pathBuilderConfig,
        frontendPartialsPath
    );
    
    directive.$inject = [
        'pathBuilderConfig',
        'frontendPartialsPath'
    ];
    return directive;
    }
    //@ngInject
    constructor(private pathBuilderConfig, private frontendPartialsPath:any){
        this.templateUrl = this.templateUrl = pathBuilderConfig.buildPartialsPath(frontendPartialsPath)+'createaccountpartial.html';
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}

}
export {
  SWFCreateAccount,
  SWFCreateAccountController  
};
