/// <reference path='../../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../typings/tsd.d.ts' />

class SWEntityActionBarController{
    public init = () =>{
    }
    
    constructor(){
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
        pageTitle:"@",
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
            partialsPath
        ) => new SWEntityActionBar(partialsPath);
        directive.$inject = ['partialsPath'];
        return directive;
        
    }
    
    
    constructor(private partialsPath){
        this.templateUrl = partialsPath+'entityactionbar.html';
    }
    
    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
        
    }
}
export{
    SWEntityActionBar
}
    
//	angular.module('slatwalladmin').directive('swEntityActionBar',['partialsPath',(partialsPath) => new SWEntityActionBar(partialsPath)]);


