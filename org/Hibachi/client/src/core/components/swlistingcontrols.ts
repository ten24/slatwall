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

    //@ngInject
    constructor(
        public $hibachi,
        public metadataService,
        public $timeout
    ){

        this.selectSearchColumn = (column?)=>{
            this.selectedSearchColumn = column;
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

        this.search = () =>{
            if(this._timeoutPromise) {
                $timeout.cancel(this._timeoutPromise);
            }
            this._timeoutPromise = $timeout(()=>{
                this.collectionConfig.setKeywords(this.searchText)
                this.paginator.setCurrentPage(1);
                this.searching = true;
                this.getCollection();
            }, 500);
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
