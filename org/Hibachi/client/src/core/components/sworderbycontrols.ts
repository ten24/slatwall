/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWOrderByControlsController {

    public id:string;
    public eventString:string; 

    public collectionConfig:any;//used for getting the properties
    public selectedOrderByColumnIndex:any; 
    public sortCode:string = "ASC";
    public columns:any[]; 
    public disabled:boolean; 
    public inListingDisplay:boolean; 
    public listingId:string;
    public toggleCollectionConfig:boolean; 
    public propertyNotChosen:boolean;

    // @ngInject
    constructor( private listingService, private observerService, private utilityService ){
            this.columns = this.collectionConfig.columns; 
            console.log("orderbycolumns", this.columns)
            this.id = this.utilityService.createID(32); 
            this.eventString = this.id + "swOrderByControlsUpdateOrderBy";
    }

    public changeSortProperty = ():void =>{
        console.log("changeSortProperty", this.sortCode, this.selectedOrderByColumnIndex);
        if(this.selectedOrderByColumnIndex !== ''){
            this.propertyNotChosen=false; 
        } else {
            this.propertyNotChosen=true; 
        }
        this.updateOrderBy(); 
    }

    public updateOrderBy = () =>{
        if(this.columns[this.selectedOrderByColumnIndex] != null){
            var propertyIdentifier = this.columns[this.selectedOrderByColumnIndex].propertyIdentifier;
        }
         switch(this.sortCode){
            case "ASC":
                if(propertyIdentifier !=null){
                    this.disabled = false; 
                    if(angular.isDefined(this.collectionConfig)){
                        this.collectionConfig.toggleOrderBy(propertyIdentifier,true);//single column mode true
                    }
                    if(this.inListingDisplay){
                        this.listingService.setSingleColumnOrderBy(this.listingId, propertyIdentifier, "ASC");
                        this.listingService.setManualSort(this.listingId, false); 
                    }
                }
                break; 
            case "DESC":
                if(propertyIdentifier !=null){
                    this.disabled = false; 
                    if(angular.isDefined(this.collectionConfig)){
                        this.collectionConfig.toggleOrderBy(propertyIdentifier,true);//single column mode true
                    }
                    if(this.inListingDisplay){
                        this.listingService.setSingleColumnOrderBy(this.listingId, propertyIdentifier, "DESC");
                        this.listingService.setManualSort(this.listingId, false); 
                    }
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
        this.updateOrderBy();
    }

    public sortDescending = ():void =>{
        this.sortCode = 'DESC'; 
        this.updateOrderBy();
    }

    public manualSort = ():void =>{
        this.sortCode = 'MANUAL'
        this.updateOrderBy();
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
