/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWOrderByControlsController {

    public id:string;
    public eventString:string;
    public swListingDisplay:any;

    public collectionConfig:any;//used for getting the properties
    public selectedPropertyIdentifier:any;
    public sortCode:string = "ASC";
    public columns:any[];
    public disabled:boolean;
    public initialSortProperty:string;
    public initialSortDefaultDirection:string;
    public inListingDisplay:boolean;
    public listingId:string;
    public sortPropertyFieldName:string;
    public sortDefaultDirectionFieldName:string;
    public toggleCollectionConfig:boolean;
    public propertyNotChosen:boolean;
    public edit:boolean;

    // @ngInject
    constructor( private listingService,
                 private observerService,
                 private utilityService ){
            if( angular.isUndefined(this.edit)){
                this.edit = true;
            }

            if( angular.isDefined(this.collectionConfig) ){
                 this.columns = this.collectionConfig.columns;
            }
            if( angular.isDefined(this.initialSortDefaultDirection) && this.initialSortDefaultDirection.length > 0){
                this.sortCode = this.initialSortDefaultDirection;
            }
            if( angular.isDefined(this.initialSortProperty) && this.initialSortProperty.length > 0){
                this.selectedPropertyIdentifier = this.initialSortProperty;
            }
            this.id = this.utilityService.createID(32);
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
                    //this.swListingDisplay.sortable = true;
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
        toggleCollectionConfig:"=?",
        initialSortProperty:"@?",
        initialSortDefaultDirection:"@?",
        sortPropertyFieldName:"@?",
        sortDefaultDirectionFieldName:"@?",
        edit:"=?"
    };
    public require = {swListingDisplay:'?^swListingDisplay'};
    public controller=SWOrderByControlsController;
    public controllerAs="swOrderByControls";

    // @ngInject
    constructor( public $compile,
                 private scopeService,
                 private listingService,
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
                    var listingDisplayScope = this.scopeService.getRootParentScope($scope,"swListingDisplay")["swListingDisplay"];
                    $scope.swOrderByControls.listingId = listingDisplayScope.tableID;
                    this.listingService.attachToListingInitiated($scope.swOrderByControls.listingId, $scope.swOrderByControls.updateOrderBy);
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
            ,listingService
            ,corePartialsPath
            ,hibachiPathBuilder

        )=> new SWOrderByControls(
            $compile
            ,scopeService
            ,listingService
            ,corePartialsPath
            ,hibachiPathBuilder
        );
        directive.$inject = ["$compile","scopeService","listingService","corePartialsPath",
            "hibachiPathBuilder"];
        return directive;
    }
}
export{
    SWOrderByControls,
    SWOrderByControlsController
}
