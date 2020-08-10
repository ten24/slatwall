/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

//import pagination = require('../services/paginationservice');
//var PaginationService = pagination.PaginationService;
//'use strict';
class SWPaginationBarController{
    public limitCountTotal;
    public paginator;
    public swListingDisplay:any;
    private showToggleDisplayOptions:boolean;
    private listingId;

    public $onInit=()=>{
    this.limitCountTotal = this.swListingDisplay.collectionConfig.limitCountTotal; // fetch from config file
    }
    //@ngInject
    constructor(
        public paginationService,
        public observerService
    ){
        if(angular.isUndefined(this.paginator)){
            this.paginator = paginationService.createPagination();
        }
    }
    //Documentation: Toggle flag function to either show or turn off all records count fetch.
    public toggleCountLimit = (count)=>{
        if (this.limitCountTotal > 0 ){ 
            this.limitCountTotal = 0; 
        }else{
            this.limitCountTotal =  this.swListingDisplay.collectionConfig.limitCountTotal; // fetch again from config file
        }
        this.updateListingSearchConfig({
            limitCountTotal : this.limitCountTotal   
        });
    }
    /* updateListingSearchConfig Should not be copied again here and must ideally be reused from sqlistingsearch.ts and extended above */
    public updateListingSearchConfig(config?) {
        var newListingSearchConfig = { ...this.swListingDisplay.collectionConfig.listingSearchConfig, ...config };
        this.swListingDisplay.collectionConfig.listingSearchConfig = newListingSearchConfig;
        this.listingId = this.paginator.uuid;
        this.observerService.notifyById('swPaginationAction',this.listingId, {type:'setCurrentPage', payload:1});
    }
}

 class SWPaginationBar implements ng.IDirective{
    public template = require('./paginationbar.html');
    public restrict:string = 'E';
   
    public scope = {};
    public require = {swListingDisplay:"?^swListingDisplay",swListingControls:'?^swListingControls'};
    public bindToController={
        collectionConfig : "=",
        paginator : "=?",
        listingId : "@?",
        showToggleSearch:"=?",
    };
    public controller=SWPaginationBarController;
    public controllerAs="swPaginationBar";

    public static Factory():ng.IDirectiveFactory {
        return /** @ngInject */ () => new this();
    }
}


export {
    SWPaginationBar,
    SWPaginationBarController
};
