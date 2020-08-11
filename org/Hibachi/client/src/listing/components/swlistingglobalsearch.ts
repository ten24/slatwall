/// <reference path='../../../typings/hibachiTypescript.d.ts' />
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
        this.searching = true;

        if(this._timeoutPromise){
            this.$timeout.cancel(this._timeoutPromise);
        }

        this._timeoutPromise = this.$timeout(()=>{
            this.getCollection();
        }, 500);
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
    
    public template= require('./listingglobalsearch.html');
    
    public static Factory(){
        return /** @ngInject */ () => new this();
    }

}
export{
    SWListingGlobalSearch
}


