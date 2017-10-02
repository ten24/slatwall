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
    public swListingDisplay;
    public searchableOptions;
    public swListingControls;

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

    public $onInit=()=>{
        //snapshot searchable options in the beginning
        this.searchableOptions = angular.copy(this.swListingDisplay.collectionConfig.columns);
        this.selectedSearchColumn={title:'All'};

        this.configureSearchableColumns(this.selectedSearchColumn);
    }

    public selectSearchColumn = (column?)=>{
        this.selectedSearchColumn = column;
        this.configureSearchableColumns(column);
        if(this.searchText){
            this.search();
        }
    };


    private search =()=>{
        if(this.searchText.length > 0 ){
            this.listingService.setExpandable(this.listingId, false);
        } else {
            this.listingService.setExpandable(this.listingId, true);
        }

        this.collectionConfig.setKeywords(this.searchText);

        this.swListingDisplay.collectionConfig = this.collectionConfig;

        this.observerService.notify('swPaginationAction',{type:'setCurrentPage', payload:1});

    };

    private configureSearchableColumns=(column)=>{

        var searchableColumn = "";
        if(column.propertyIdentifier){
            searchableColumn = column.propertyIdentifier;
        //default to All columns
        }

        for(var i = 0; i < this.swListingDisplay.collectionConfig.columns.length; i++){
            if(searchableColumn.length){
                if(searchableColumn === this.swListingDisplay.collectionConfig.columns[i].propertyIdentifier){
                    this.swListingDisplay.collectionConfig.columns[i].isSearchable = true;
                }else{
                    this.swListingDisplay.collectionConfig.columns[i].isSearchable = false;
                }
            }else{
                this.swListingDisplay.collectionConfig.columns[i].isSearchable = true;
            }
        }
    }


}

class SWListingSearch  implements ng.IDirective{

    public templateUrl;
    public restrict = 'EA';
    public scope = {};
    public require = {swListingDisplay:"?^swListingDisplay",swListingControls:'?^swListingControls'}
    public bindToController =  {
        collectionConfig : "<?",
        paginator : "=?",
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
            listingPartialPath,
            hibachiPathBuilder
        )=> new SWListingSearch(
            scopeService,
            listingPartialPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'scopeService', 'listingPartialPath', 'hibachiPathBuilder'];
        return directive;
    }

}

export{
    SWListingSearch
}
