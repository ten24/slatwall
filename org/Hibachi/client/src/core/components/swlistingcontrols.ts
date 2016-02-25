/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingControlsController {
    private selectSearchColumn;
    private selectedSearchColumn;
    private getSelectedSearchColumnName;
    private filterPropertiesList;
    private collectionConfig;
    private search;
    private _timeoutPromise;
    private paginator;
    private searching;
    private getCollection;
    private searchText;
    private backupColumnsConfig;
    private createNewFilter;
    private setItemInUse;
    private removeFilter;
    private addSearchFilter;
    private triggerSearch;
    private displayOptionsClosed:boolean=true;
    private filtersClosed:boolean=true;
    private toggleFilters;
    private toggleDisplayOptions;
    private newFilterPosition;

    //@ngInject
    constructor(
        public $hibachi,
        public metadataService,
        public $timeout,
        public collectionService
    ){
        this.selectSearchColumn = (column?)=>{
            this.selectedSearchColumn = column;
            this.triggerSearch();
        };

        this.getSelectedSearchColumnName = () =>{
            return (angular.isUndefined(this.selectedSearchColumn)) ? 'All' : this.selectedSearchColumn.title;
        };

        this.filterPropertiesList = {};
        var filterPropertiesPromise = $hibachi.getFilterPropertiesByBaseEntityName(this.collectionConfig.baseEntityAlias);
        filterPropertiesPromise.then((value)=>{
            metadataService.setPropertiesList(value,this.collectionConfig.baseEntityAlias);
            this.filterPropertiesList[this.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias(this.collectionConfig.baseEntityAlias);
            metadataService.formatPropertiesList(this.filterPropertiesList[this.collectionConfig.baseEntityAlias],this.collectionConfig.baseEntityAlias);
        });

        this.backupColumnsConfig = this.collectionConfig.getColumns();

        this.search = () =>{
            if(this._timeoutPromise) {
                $timeout.cancel(this._timeoutPromise);
            }
            this._timeoutPromise = $timeout(()=>{
                this.collectionConfig.setKeywords(this.searchText);
                this.triggerSearch();
            }, 500);
        };

        this.triggerSearch =()=>{
            if(angular.isDefined(this.selectedSearchColumn)){
                this.backupColumnsConfig = angular.copy(this.collectionConfig.getColumns());
                var collectionColumns = this.collectionConfig.getColumns();
                for(var i = 0; i < collectionColumns.length; i++){
                    if(collectionColumns[i].propertyIdentifier != this.selectedSearchColumn.propertyIdentifier){
                        collectionColumns[i].isSearchable = false;
                    }
                }
                this.paginator.setCurrentPage(1);
                this.collectionConfig.setColumns(this.backupColumnsConfig);
            }else{
                this.paginator.setCurrentPage(1);
            }
        };

        this.setItemInUse = function(booleanValue){
            this.itemInUse = booleanValue;
        };

        this.removeFilter = function(array, index){
            array.splice(index, 1);
        };

        this.addSearchFilter=()=>{
            if(angular.isUndefined(this.selectedSearchColumn)) return;
            this.collectionConfig.addFilter(
                this.selectedSearchColumn.propertyIdentifier,
                this.searchText
            );
            this.searchText = '';
            this.getCollection();
        };


        this.toggleFilters = ()=>{
            this.filtersClosed = !this.filtersClosed;

            if(this.filtersClosed) {
                this.removeFilter(this.collectionConfig.filterGroups[0].filterGroup, this.newFilterPosition);
            }else{
                this.newFilterPosition = this.collectionService.newFilterItem(this.collectionConfig.filterGroups[0].filterGroup,this.setItemInUse);
            }
        };

        this.toggleDisplayOptions=()=>{
            this.displayOptionsClosed = !this.displayOptionsClosed;

        };


    }


}

class SWListingControls  implements ng.IDirective{

    public static $inject = ['corePartialsPath', 'hibachiPathBuilder'];
    public templateUrl;
    public restrict = 'E';
    public scope = {};

    public bindToController =  {
        collectionConfig : "=",
        paginator : "=",
        getCollection : "&"
    };
    public controller = SWListingControlsController;
    public controllerAs = 'swListingControls';

    constructor(
        public collectionPartialsPath,
        public hibachiPathBuilder
    ){
        this.templateUrl = this.hibachiPathBuilder.buildPartialsPath(this.collectionPartialsPath) + "listingcontrols.html";
    }

    public static Factory(){
        var directive = (
            corePartialsPath,
            hibachiPathBuilder
        )=> new SWListingControls(
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'corePartialsPath', 'hibachiPathBuilder'];
        return directive;
    }
}

export{
    SWListingControls
}
