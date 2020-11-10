/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWEntityActionBarController{
    public pageTitle; 
    public pageTitleRbKey; 
    
    public init = () =>{
        if(angular.isDefined(this.pageTitleRbKey)){
            this.pageTitle = this.rbkeyService.getRBKey(this.pageTitleRbKey);
        }
    }

    //@ngInject
    constructor(private rbkeyService){
        this.init();
    }
}

class SWEntityActionBar implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude = true;
    public bindToController={
        /*Core settings*/
        type:"@",
        object:"=",
        pageTitle:"@?",
        pageTitleRbKey:"@?",
        edit:"=",
        /*Action Callers (top buttons)*/
        showcancel:"=",
        showcreate:"=",
        showedit:"=",
        showdelete:"=",

        /*Basic Action Caller Overrides*/
        createModal:"=",
        createAction:"=",
        createQueryString:"=",

        backAction:"=",
        backQueryString:"=",

        cancelAction:"=",
        cancelQueryString:"=",

        deleteAction:"=",
        deleteQueryString:"=",

        /*Process Specific Values*/
        processAction:"=",
        processContext:"="

    };
    public controller=SWEntityActionBarController
    public controllerAs="swEntityActionBar";
    public templateUrl;

    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,hibachiPathBuilder
        ) => new SWEntityActionBar(corePartialsPath,hibachiPathBuilder);
        directive.$inject = ['corePartialsPath','hibachiPathBuilder'];
        return directive;

    }

    //@ngInject
    constructor(private corePartialsPath,hibachiPathBuilder){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath)+'entityactionbar.html';
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWEntityActionBar
}

//	angular.module('slatwalladmin').directive('swEntityActionBar',['corePartialsPath',(corePartialsPath) => new SWEntityActionBar(corePartialsPath)]);


