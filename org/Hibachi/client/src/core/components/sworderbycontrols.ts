/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWOrderByControlsController {

    public id:string;
    public eventString:string; 

    public collectionConfig:any;//used for getting the properties
    public selectedPropertyIdentifier:any; 
    public sortCode:string = "ASC";
    public columns:any[]; 
    public disabled:boolean; 
    public inListingDisplay:boolean; 
    public listingId:string;
    public toggleCollectionConfig:boolean; 
    public propertyNotChosen:boolean;

    // @ngInject
    constructor( private listingService, private observerService, private utilityService ){
            if(angular.isDefined(this.collectionConfig)){
                 this.columns = this.collectionConfig.columns; 
            } 
            this.id = this.utilityService.createID(32); 
            this.eventString = this.id + "swOrderByControlsUpdateOrderBy";
    }

    public updateSortOrderProperty = ():void =>{
        if(angular.isDefined(this.selectedPropertyIdentifier)){
            this.propertyNotChosen=false; 
        } else {
            this.propertyNotChosen=true; 
        }
        this.updateOrderBy(); 
    }

    public updateOrderBy = () =>{
        if(angular.isDefined(this.selectedPropertyIdentifier) && this.selectedPropertyIdentifier.length > 0){
            var propertyIdentifier = this.selectedPropertyIdentifier;
        }
        switch(this.sortCode){
            case "ASC":
                this.disabled = false; 
                if(propertyIdentifier != null){
                    if(angular.isDefined(this.collectionConfig)){
                        this.collectionConfig.toggleOrderBy(propertyIdentifier,true);//single column mode true
                    }
                    if(this.inListingDisplay){
                        this.listingService.setSingleColumnOrderBy(this.listingId, propertyIdentifier, "ASC");
                    }
                }
                if(this.inListingDisplay) this.listingService.setManualSort(this.listingId, false); 
                break; 
            case "DESC":
                this.disabled = false; 
                if(propertyIdentifier != null){
                    if(angular.isDefined(this.collectionConfig)){
                        this.collectionConfig.toggleOrderBy(propertyIdentifier,true);//single column mode true
                    }
                    if(this.inListingDisplay){
                        this.listingService.setSingleColumnOrderBy(this.listingId, propertyIdentifier, "DESC");
                    }
                    if(this.inListingDisplay) this.listingService.setManualSort(this.listingId, false); 
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
        console.log("sortMANUAL");
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
                    this.scopeService.hasParentScope($scope,"swListingDisplay")
                ){
                    var listingDisplayScope = this.scopeService.locateParentScope($scope,"swListingDisplay")["swListingDisplay"];
                    $scope.swOrderByControls.listingId = listingDisplayScope.tableID; 
                    if( $scope.swOrderByControls.collectionConfig == null && 
                        listingDisplayScope.collectionConfig != null
                    ){
                        $scope.swOrderByControls.collectionConfig = listingDisplayScope.collectionConfig;
                    }
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
