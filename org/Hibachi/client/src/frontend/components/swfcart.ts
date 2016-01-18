/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

interface FindArray<T> extends Array<T> {
    find(predicate: (T) => boolean) : T;
}

class SWFCartController{
    public cart:{};
    public account:{};
    public validCartObjects:FindArray<Object>;
    public hibachiScope:any;
    public objectFound;
    public listItem;
    public object;
    //@ngInject
    constructor(private $log:ng.ILogService, private $window:ng.IWindowService, private frontendPartialsPath, public $rootScope){
        this.$rootScope         = $rootScope;
        this.hibachiScope       = this.$rootScope.hibachiScope;
        this.cart               = this.hibachiScope.cart;
        this.account            = this.hibachiScope.account;
        this.objectFound        = false;
        this.listItem = this.hibachiScope.cart[this.object];
    } 
}

class SWFCart implements ng.IDirective{
    
    public restrict:string = 'E';
    public scope = {};
    public bindToController={
        object: "@?"
    };
    public controller=SWFCartController
    public controllerAs="SwfCart";
    public templateUrl;
    //@ngInject
    constructor(private frontendPartialsPath:any, pathBuilderConfig){
        this.templateUrl = pathBuilderConfig.buildPartialsPath(frontendPartialsPath)+'swfcartpartial.html';
    }
    
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{}
    
    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    frontendPartialsPath,
			pathBuilderConfig
        ) => new SWFCart(
			frontendPartialsPath,
			pathBuilderConfig
        );
        directive.$inject = [
            'frontendPartialsPath',
			'pathBuilderConfig'
        ];
        return directive;
    }
}
export {SWFCartController, SWFCart, FindArray};

