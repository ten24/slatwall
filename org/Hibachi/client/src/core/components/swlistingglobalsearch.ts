/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingGlobalSearchController{
    private searching;
    private searchText;
    private savedSearchText;
    private _timeoutPromise
    public getCollection;
    //@ngInject

    constructor(
        private $timeout
    ){
        this.init();
    }

    public init = () =>{
        this.searching = false;
    }

    public search = () =>{
        if(this.searchText.length >= 2){
            this.searching = true;

            if(this._timeoutPromise){
                this.$timeout.cancel(this._timeoutPromise);
            }

            this._timeoutPromise = this.$timeout(()=>{
                this.getCollection();
            }, 500);
        }else if(this.searchText.length === 0){
            this.$timeout(()=>{
                this.getCollection();
            });
        }
    }
}

class SWListingGlobalSearch implements ng.IDirective{
    public restrict:string = 'EA';
    public scope={};
    public bindToController={
        searching:"=",
        searchText:"=",
        getCollection:"="
    };
    public controller=SWListingGlobalSearchController;
    public controllerAs="swListingGlobalSearch";
    public templateUrl;
    public static Factory(){
        var directive = (utilityService,corePartialsPath,pathBuilderConfig)=>new SWListingGlobalSearch(utilityService,corePartialsPath,pathBuilderConfig);
        directive.$inject = ['utilityService','corePartialsPath','pathBuilderConfig'];
        return directive;
    }
    //@ngInject
    constructor(private utilityService,corePartialsPath,pathBuilderConfig){
        this.templateUrl = pathBuilderConfig.buildPartialsPath(corePartialsPath) + "listingglobalsearch.html";
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

    }
}
export{
    SWListingGlobalSearch
}


