/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWOrderByControlsController {

    public collectionConfig:any;//used for getting the properties
    public selectedOrderByColumnIndex:any; 
    public sortCode:string = "ASC";
    public columns:any[]; 
    public disabled:boolean; 
    public inListingDisplay:boolean; 
    public listingId:string;
    public toggleCollectionConfig:boolean; 

    // @ngInject
    constructor( private listingService ){
            this.columns = this.collectionConfig.columns; 
            console.log("orderbycolumns", this.columns)
    }

    public changeSortProperty = ():void =>{
        switch(this.sortCode){
            case "ASC":
                this.disabled = false; 
                if(angular.isDefined(this.collectionConfig)){
                    this.collectionConfig.toggleOrderBy(this.columns[this.selectedOrderByColumnIndex].propertyIdentifier,true);//single column mode true
                }
                if(this.inListingDisplay){
                    this.listingService.setSingleColumnOrderBy(this.listingId,this.columns[this.selectedOrderByColumnIndex].propertyIdentifier,"ASC");
                    this.listingService.setManualSort(this.listingId, false); 
                }
                break; 
            case "DESC":
                this.disabled = false; 
                if(angular.isDefined(this.collectionConfig)){
                    this.collectionConfig.toggleOrderBy(this.columns[this.selectedOrderByColumnIndex].propertyIdentifier,true);//single column mode true
                }
                if(this.inListingDisplay){
                    this.listingService.setSingleColumnOrderBy(this.listingId,this.columns[this.selectedOrderByColumnIndex].propertyIdentifier,"DESC");
                    this.listingService.setManualSort(this.listingId, false); 
                }
                break; 
            case "MANUAL":
                //flip listing
                this.disabled = true; 
                if(this.inListingDisplay){
                    this.listingService.setManualSort(this.listingId, true); 
                }
                break; 
        }
    }

    public sortAscending = ():void =>{
        this.sortCode = 'ASC'; 
    }

    public sortDescending = ():void =>{
        this.sortCode = 'DESC'; 
    }

    public manualSort = ():void =>{
        this.sortCode = 'MANUAL'
    }

}

class SWOrderByControls implements ng.IDirective{

    public templateUrl;
    public transclude=true; 
    public restrict = "EA";
    public scope = {};

    public bindToController = {
        collectionConfig:"=?",
        selectedOrderByColumn:"=?",
        inListingDisplay:"=?",
        toggleCollectionConfig:"=?"
    };
    public controller=SWOrderByControlsController;
    public controllerAs="swOrderByControls";

    // @ngInject
    constructor( public $compile, 
                 private scopeService, 
                 private corePartialsPath,
                 hibachiPathBuilder
    ){
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(corePartialsPath) + "orderbycontrols.html";
    }

    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                if( $scope.swOrderByControls.inListingDisplay && 
                    this.scopeService.hasParentScope("swListingDisplay")
                ){
                    var listingDisplayScope = this.scopeService.locateParentScope("swListingDisplay")["swListingDisplay"];
                    $scope.swOrderByControls.listingId = listingDisplayScope.tableID; 
                }
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {

            }
        };
    }

    public static Factory(){
        var directive:ng.IDirectiveFactory = (
            $compile
            ,scopeService 
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWOrderByControls(
            $compile
            ,scopeService
            ,corePartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = ["$compile","scopeService","corePartialsPath",
            "hibachiPathBuilder"];
        return directive;
    }
}
export{
    SWOrderByControls,
    SWOrderByControlsController
}
