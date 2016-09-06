/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingSearchController {
    private selectedSearchColumn;
    private filterPropertiesList;
    private collectionConfig;
    private paginator;
    private searchText;
    private backupColumnsConfig;
    private displayOptionsClosed:boolean=true;
    private filtersClosed:boolean=true;
    private showToggleFilters:boolean; 
    private showToggleDisplayOptions:boolean; 
    private newFilterPosition;
    private itemInUse;
    private getCollection;
    private listingId; 

    //@ngInject
    constructor(
        public $hibachi,
        public metadataService,
        public listingService, 
        public collectionService,
        public observerService
    ) {
        if(angular.isUndefined(this.showToggleFilters)){
            this.showToggleFilters = true;
        }
        if(angular.isUndefined(this.showToggleDisplayOptions)){
            this.showToggleDisplayOptions = true; 
        }
    }

    public selectSearchColumn = (column?)=>{
        this.selectedSearchColumn = column;
        if(this.searchText){
            this.search();
        }
    };

    public getSelectedSearchColumnName = () =>{
        return (angular.isUndefined(this.selectedSearchColumn)) ? 'All' : this.selectedSearchColumn.title;
    };

    private search =()=>{
        if(this.searchText.length > 0 ){
            this.listingService.setExpandable(this.listingId, false);
        } else {
            this.listingService.setExpandable(this.listingId, true);
        }
        if(angular.isDefined(this.selectedSearchColumn)){
            this.backupColumnsConfig = angular.copy(this.collectionConfig.getColumns());
            var collectionColumns = this.collectionConfig.getColumns();
            for(var i = 0; i < collectionColumns.length; i++){
                if(collectionColumns[i].propertyIdentifier != this.selectedSearchColumn.propertyIdentifier){
                    collectionColumns[i].isSearchable = false;
                }
            }
            this.collectionConfig.setKeywords(this.searchText);
            this.paginator.setCurrentPage(1);
            this.collectionConfig.setColumns(this.backupColumnsConfig);
        }else{
            this.collectionConfig.setKeywords(this.searchText);
            this.paginator.setCurrentPage(1);
        }
    };

    private addSearchFilter=()=>{
        if(angular.isUndefined(this.selectedSearchColumn) || !this.searchText) return;

        var keywords = this.searchText.split(" ");
        for(var i = 0; i < keywords.length; i++){
            this.collectionConfig.addLikeFilter(
                this.selectedSearchColumn.propertyIdentifier,
                keywords[i],
                '%w%',
                undefined,
                this.selectedSearchColumn.title
            );
        }

        this.searchText = '';
        this.collectionConfig.setKeywords(this.searchText);
        this.paginator.setCurrentPage(1);
    };


}

class SWListingSearch  implements ng.IDirective{

    public templateUrl;
    public restrict = 'EA';
    public scope = {};

    public bindToController =  {
        collectionConfig : "=?",
        paginator : "=?",
        getCollection : "&",
        toggleFilters : "&?",
        toggleDisplayOptions : "&?",
        showToggleFilters : "=?",
        showToggleDisplayOptions : "=?",
        listingId : "@?"
    };
    public controller = SWListingSearchController;
    public controllerAs = 'swListingSearch';

    //@ngInject
    constructor(
        public scopeService, 
        public collectionPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.collectionPartialsPath) + "listingsearch.html";
    }

    public static Factory(){
        var directive = (
            scopeService,
            corePartialsPath,
            hibachiPathBuilder
        )=> new SWListingSearch(
            scopeService, 
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'scopeService', 'corePartialsPath', 'hibachiPathBuilder'];
        return directive;
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element:any, attrs:any) =>{
        if(angular.isUndefined(scope.swListingSearch.collectionConfig) && this.scopeService.hasParentScope(scope, "swListingDisplay")){
<<<<<<< HEAD
            var listingDisplayScope = this.scopeService.locateParentScope(scope, "swListingDisplay")["swListingDisplay"];
=======
            var listingDisplayScope = this.scopeService.getRootParentScope(scope, "swListingDisplay")["swListingDisplay"];
>>>>>>> 8752089deaa3a8bd5071e97f8e60c1e1b7ff9486
            if(listingDisplayScope.collectionConfig != null){
                scope.swListingSearch.collectionConfig = listingDisplayScope.collectionConfig; 
            }
            if(listingDisplayScope.paginator != null){
                scope.swListingSearch.paginator = listingDisplayScope.paginator; 
            }
            scope.swListingSearch.listingId = listingDisplayScope.tableID; 
        }
        scope.swListingSearch.backupColumnsConfig =  scope.swListingSearch.collectionConfig.getColumns();
    }
}

export{
    SWListingSearch
}
