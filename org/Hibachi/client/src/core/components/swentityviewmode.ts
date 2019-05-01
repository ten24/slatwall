/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWEntityViewModeController{
    
    public edit:boolean;
    
    //@ngInject
    constructor( private observerService,
                 private rbkeyService
    ){
        
    }
    
    public $onInit = () =>{
        this.observerService.attach(this.setEdit,'swEntityActionBar')
    }

    public setEdit = (payload) =>{
        this.edit = payload.edit;
    }
}

class SWEntityViewMode implements ng.IDirective{

    public restrict:string = 'EA';
    public scope = {};
    public transclude = true;
    public bindToController={};
    public controller=SWEntityViewModeController
    public controllerAs="swEntityViewMode";
    
    public template=`
        <div ng-if="!swEntityViewMode.edit" 
             ng-transclude>
        </div>
    `;

    public static Factory(){
        var directive:ng.IDirectiveFactory=() => new SWEntityViewMode();
        directive.$inject = [];
        return directive;

    }

    //@ngInject
    constructor(){
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWEntityViewMode
}

//	angular.module('slatwalladmin').directive('swEntityActionBar',['corePartialsPath',(corePartialsPath) => new SWEntityViewMode(corePartialsPath)]);


