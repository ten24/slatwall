/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingControlsController {
    private selectSearchColumn;
    private selectedSearchColumn;
    private getSelectedSearchColumnName;
    private filterPropertiesList;
    private collectionConfig;



    //@ngInject
    constructor(
        public $hibachi,
        public metadataService
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

    }
}

class SWListingControls  implements ng.IDirective{

    public static $inject = ['corePartialsPath', 'hibachiPathBuilder'];
    public templateUrl;
    public restrict = 'E';
    public scope = {};

    public bindToController =  {
        collectionConfig : "="
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
