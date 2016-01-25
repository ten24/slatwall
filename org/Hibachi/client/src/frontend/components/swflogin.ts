/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWFLoginController{
    public pObject:string;
    // @ngInject
    constructor(private $route,private $log:ng.ILogService, private $window:ng.IWindowService, private $hibachi:any, private dialogService:any){
        this.$hibachi = $hibachi; 
        this.pObject   = "Account_Login";
    }
}

class SWFLogin implements ng.IDirective{
    
    public restrict:string = 'E';
    public scope = {};
    public bindToController={};
    public controller=SWFLoginController
    public controllerAs="SwfLogin";
    public templateUrl;
    
    // @ngInject
    constructor(private hibachiPathBuilder, private frontendPartialsPath ){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(frontendPartialsPath)+'logindirectivepartial.html';
    }
    
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}
    
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
			hibachiPathBuilder,
            frontendPartialsPath
        ) => new SWFLogin(
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
   SWFLoginController, SWFLogin 
};

