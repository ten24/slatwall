/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWEntityEditModeController{
    
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

class SWEntityEditMode implements ng.IDirective{

    public restrict:string = 'EA';
    public scope = {};
    public transclude = true;
    public bindToController={};
    public controller=SWEntityEditModeController
    public controllerAs="swEntityEditMode";
    
    public template=`
        <div ng-if="swEntityEditMode.edit" 
             ng-transclude>
        </div>
    `;

    public static Factory(){
        var directive:ng.IDirectiveFactory=() => new SWEntityEditMode();
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
    SWEntityEditMode
}

//	angular.module('slatwalladmin').directive('swEntityActionBar',['corePartialsPath',(corePartialsPath) => new SWEntityEditMode(corePartialsPath)]);


