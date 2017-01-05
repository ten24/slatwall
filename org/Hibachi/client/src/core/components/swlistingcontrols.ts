/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingControlsController {
    private selectedSearchColumn;
    private filterPropertiesList;
    private collectionConfig;
    private paginator;
    private searchText;
    private backupColumnsConfig;
    private listingColumns; 
    private displayOptionsClosed:boolean=true;
    private filtersClosed:boolean=true;
    private showFilters:boolean; 
    private showToggleFilters:boolean; 
    private showToggleDisplayOptions:boolean; 
    private newFilterPosition;
    private itemInUse;
    private getCollection;
    private tableId; 
    private columnIsControllableMap = {}; 

    //@ngInject
    constructor(
        public $hibachi,
        public metadataService,
        public collectionService,
        public listingService, 
        public observerService
    ) {
        if(angular.isUndefined(this.showToggleFilters)){
            this.showToggleFilters = true; 
        }
        if(angular.isUndefined(this.showToggleDisplayOptions)){
            this.showToggleDisplayOptions = true; 
        }
        if(angular.isUndefined(this.showFilters)){
            this.showFilters = false;
        }
        this.backupColumnsConfig = this.collectionConfig.getColumns();

        if(angular.isDefined(this.tableId)){
            this.listingColumns = this.listingService.getListingColumns(this.tableId);
        }
        console.log("this.collectionConfig.getColumns()",this.collectionConfig.getColumns(), this.listingColumns, this.tableId);
    
        this.filterPropertiesList = {};

        $hibachi.getFilterPropertiesByBaseEntityName(this.collectionConfig.baseEntityAlias).then((value)=> {
            metadataService.setPropertiesList(value, this.collectionConfig.baseEntityAlias);
            this.filterPropertiesList[this.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias(this.collectionConfig.baseEntityAlias);
            metadataService.formatPropertiesList(this.filterPropertiesList[this.collectionConfig.baseEntityAlias], this.collectionConfig.baseEntityAlias);
        });

        this.observerService.attach(this.filterActions, 'filterItemAction');

    }
    public filterActions =(res)=>{
        if(res.action == 'add'){
            this.paginator.setCurrentPage(1);
        }
        this.filtersClosed = true;
    };

    public getSelectedSearchColumnName = () =>{
        return (angular.isUndefined(this.selectedSearchColumn)) ? 'All' : this.selectedSearchColumn.title;
    };

    public canDisplayColumn = (column) =>{
        if(angular.isDefined(this.columnIsControllableMap[column.propertyIdentifier])){
            return this.columnIsControllableMap[column.propertyIdentifier]; 
        }
        for(var i=0; i < this.listingColumns.length; i++){
            if(column.propertyIdentifier == this.listingColumns[i].propertyIdentifier){
                this.columnIsControllableMap[column.propertyIdentifier] = true; 
            }
        }
        if(!this.columnIsControllableMap[column.propertyIdentifier]){
            this.columnIsControllableMap[column.propertyIdentifier] = false; 
        }
        return this.columnIsControllableMap[column.propertyIdentifier]; 
    }

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

    public toggleDisplayOptions= (closeButton:boolean=false)=>{
        if(closeButton){
            this.displayOptionsClosed = true; 
        } else { 
            this.displayOptionsClosed = !this.displayOptionsClosed;
        }
    };

    private setItemInUse = (booleanValue)=>{
        this.itemInUse = booleanValue;
    };

    public removeFilter = (array, index, reloadCollection:boolean=true)=>{
        array.splice(index, 1);
        if(reloadCollection){
            this.paginator.setCurrentPage(1);
        }
    };

    public toggleFilters = ()=>{
        if(this.filtersClosed) {
            this.filtersClosed = false;
            this.newFilterPosition = this.collectionService.newFilterItem(this.collectionConfig.filterGroups[0].filterGroup,this.setItemInUse);
        }
    };

    public selectFilterItem = (filterItem) =>{
        this.filtersClosed = false;
        this.collectionService.selectFilterItem(filterItem);
    };

    public saveCollection = ()=>{
        this.getCollection()();
    };

}

class SWListingControls  implements ng.IDirective{

    public static $inject = ['corePartialsPath', 'hibachiPathBuilder'];
    public templateUrl;
    public restrict = 'E';
    public scope = {};

    public bindToController =  {
        collectionConfig : "=",
        tableId : "=?",
        paginator : "=",
        getCollection : "&",
        showFilters : "=?",
        showToggleFilters : "=?", 
        showToggleDisplayOptions : "=?"
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
