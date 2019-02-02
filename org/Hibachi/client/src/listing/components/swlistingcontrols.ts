/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingControlsController {
    public swListingDisplay:any;
    private selectedSearchColumn;
    private filterPropertiesList;
    private collectionConfig;

    private searchText;
    private backupColumnsConfig;
    private listingColumns;
    private displayOptionsClosed:boolean=true;
    private filtersClosed:boolean=true;
    private personalCollectionsClosed:boolean=true;
    private showExport:boolean; 
    private showReport:boolean;
    private showFilters:boolean;
    private showPersonalCollections:boolean;
    private showPrintOptions:boolean; 
    private showToggleFilters:boolean;
    private showToggleSearch:boolean;
    private showToggleDisplayOptions:boolean;
    private newFilterPosition;
    private itemInUse;
    private getCollection;
    private tableId;
    public columnIsControllableMap = {};
    public simple:boolean;


    //@ngInject
    constructor(
        public $hibachi,
        public metadataService,
        public collectionService,
        public listingService,
        public observerService
    ) {
        if(angular.isUndefined(this.showPrintOptions)){
            this.showPrintOptions = false;
        }
        if(angular.isUndefined(this.showExport)){
            this.showExport = true; 
        }
        if(angular.isUndefined(this.showReport)){
            this.showReport = true; 
        }
        
        if(angular.isUndefined(this.showToggleSearch)){
            this.showToggleSearch = true;
        }
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
        if(angular.isUndefined(this.simple)){
            this.simple = true;
        }


        this.filterPropertiesList = {};

        $hibachi.getFilterPropertiesByBaseEntityName(this.collectionConfig.baseEntityAlias).then((value)=> {
            metadataService.setPropertiesList(value, this.collectionConfig.baseEntityAlias);
            this.filterPropertiesList[this.collectionConfig.baseEntityAlias] = metadataService.getPropertiesListByBaseEntityAlias(this.collectionConfig.baseEntityAlias);
            metadataService.formatPropertiesList(this.filterPropertiesList[this.collectionConfig.baseEntityAlias], this.collectionConfig.baseEntityAlias);
        });

        this.observerService.attach(this.filterActions, 'filterItemAction');

    }
    public filterActions =(res)=>{

        if(res.action == 'add' || res.action == 'remove'){
            this.observerService.notifyById('swPaginationAction',this.tableId ,{type:'setCurrentPage', payload:1});
        }
        this.filtersClosed = true;
    };

    public getSelectedSearchColumnName = () =>{
        return (angular.isUndefined(this.selectedSearchColumn)) ? 'All' : this.selectedSearchColumn.title;
    };

    public canDisplayColumn = (column) =>{

        if(!this.listingColumns || !this.listingColumns.length){
            return true;
        }

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
        this.observerService.notifyById('swPaginationAction',this.tableId,{type:'setCurrentPage', payload:1});
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
            this.observerService.notifyById('swPaginationAction',this.tableId ,{type:'setCurrentPage', payload:1});
        }
    };

    public toggleFilters = ()=>{
        if(this.filtersClosed) {

            if(this.simple){
                this.newFilterPosition = this.collectionService.newFilterItem(this.collectionConfig.filterGroups[0].filterGroup,this.setItemInUse);
            }
        }
        this.filtersClosed = !this.filtersClosed;
    };

    public togglePersonalCollections = () =>{
        this.personalCollectionsClosed = !this.personalCollectionsClosed;
    }

    public selectFilterItem = (filterItem) =>{
        this.filtersClosed = false;
        this.collectionService.selectFilterItem(filterItem);
    };

    public saveCollection = (collectionConfig)=>{
        if(collectionConfig){
            this.collectionConfig = collectionConfig;
        }
        this.swListingDisplay.collectionConfig = this.collectionConfig;
        this.observerService.notifyById('swPaginationAction',this.tableId ,{type:'setCurrentPage',payload:1});
    };

    public exportCollection = () =>{
        this.swListingDisplay.exportCurrentList(); 
    }

    public printCollection = (printTemplateID) =>{
        this.swListingDisplay.printCurrentList(printTemplateID);
    }

}

class SWListingControls  implements ng.IDirective{

    public static $inject = ['listingPartialPath', 'hibachiPathBuilder'];
    public templateUrl;
    public restrict = 'E';
    public scope = {};
    public require={swListingDisplay:'?^swListingDisplay'}

    public bindToController =  {
        collectionConfig : "=",
        tableId : "=?",
        getCollection : "&",
        showReport:"=?",
        showExport: "=?",
        showFilters : "=?",
        showPrintOptions: "=?",
        showToggleSearch: "=?",
        showToggleFilters : "=?",
        showToggleDisplayOptions : "=?",
        displayOptionsClosed:"=?",
        simple:"=?"
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
            listingPartialPath,
            hibachiPathBuilder
        )=> new SWListingControls(
            listingPartialPath,
            hibachiPathBuilder
        );
        directive.$inject = [ 'listingPartialPath', 'hibachiPathBuilder'];
        return directive;
    }
}

export{
    SWListingControls
}
