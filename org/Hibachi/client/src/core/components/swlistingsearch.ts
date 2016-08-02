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

    //@ngInject
    constructor(
        public $hibachi,
        public metadataService,
        public collectionService,
        public observerService
    ) {
        if(angular.isUndefined(this.showToggleFilters)){
            this.showToggleFilters = true;
        }
        if(angular.isUndefined(this.showToggleDisplayOptions)){
            this.showToggleDisplayOptions = true; 
        }

        this.backupColumnsConfig = this.collectionConfig.getColumns();
    
        this.filterPropertiesList = {};

        $hibachi.getFilterPropertiesByBaseEntityName(this.collectionConfig.baseEntityAlias).then((value)=> {
            metadataService.setPropertiesList(value, this.collectionConfig.baseEntityAlias);
            this.filterPropertiesList[this.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias(this.collectionConfig.baseEntityAlias);
            metadataService.formatPropertiesList(this.filterPropertiesList[this.collectionConfig.baseEntityAlias], this.collectionConfig.baseEntityAlias);
        });
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
        collectionConfig : "=",
        paginator : "=",
        getCollection : "&",
        toggleFilters : "&?",
        toggleDisplayOptions : "&?",
        showToggleFilters : "=?",
        showToggleDisplayOptions : "=?"
    };
    public controller = SWListingSearchController;
    public controllerAs = 'swListingSearch';

    //@ngInject
    constructor(
        public collectionPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.collectionPartialsPath) + "listingsearch.html";
    }

    public static Factory(){
        var directive = (
            corePartialsPath,
            hibachiPathBuilder
        )=> new SWListingSearch(
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'corePartialsPath', 'hibachiPathBuilder'];
        return directive;
    }
}

export{
    SWListingSearch
}
