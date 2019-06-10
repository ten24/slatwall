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
    public swListingDisplay:any;
    public searchableOptions;
    public swListingControls;
    public hasPersonalCollections:boolean=false;
    public personalCollections:any;
    public selectedPersonalCollection:any;
    public collectionNameSaveIsOpen:boolean=false;
    public printTemplateOptions:any[];
    public personalCollectionIdentifier:string;

    //@ngInject
    constructor(
        public $rootScope,
        public $hibachi,
        public metadataService,
        public listingService,
        public collectionService,
        public observerService,
        public localStorageService,
        public appConfig
    ) {
       
    }

    public $onInit=()=>{
        if(angular.isDefined(this.swListingDisplay.personalCollectionIdentifier)){
            this.personalCollectionIdentifier = this.swListingDisplay.personalCollectionIdentifier;
        }
        //snapshot searchable options in the beginning
        this.searchableOptions = angular.copy(this.swListingDisplay.collectionConfig.columns);
        this.selectedSearchColumn={title:'All'};

        this.configureSearchableColumns(this.selectedSearchColumn);

        if(this.swListingControls.showPrintOptions){
            //load the options
            
            //this will prevent icon from flashing on action bar
            this.swListingControls.showPrintOptions=false
            
            var printTemplateOptionsCollection = this.collectionConfig.newCollectionConfig('PrintTemplate');
            printTemplateOptionsCollection.addFilter('printTemplateObject', this.swListingDisplay.collectionConfig.baseEntityName);
            printTemplateOptionsCollection.setAllRecords(true); 
            printTemplateOptionsCollection.getEntity().then(
                (response)=>{
                    
                    this.printTemplateOptions = response.records; 
                    if (this.printTemplateOptions.length !== 0) {
                        this.swListingControls.showPrintOptions=true;
                    }
                }, 
                (reason)=>{
                    throw("swListingSearch couldn't load printTemplateOptions because: " + reason);
                }
            );
        }
    }

    public selectSearchColumn = (column?)=>{
        this.selectedSearchColumn = column;
        this.configureSearchableColumns(column);
        if(this.swListingDisplay.searchText){
            this.search();
        }
    };

    public selectPersonalCollection = (personalCollection?) =>{
        if(!this.localStorageService.hasItem('selectedPersonalCollection')){
            this.localStorageService.setItem('selectedPersonalCollection','{}');
        }
        var selectedPersonalCollection = angular.fromJson(this.localStorageService.getItem('selectedPersonalCollection'));
        if(personalCollection){
            selectedPersonalCollection[personalCollection.collectionObject.toLowerCase()] = personalCollection;
            this.localStorageService.setItem('selectedPersonalCollection',angular.toJson(selectedPersonalCollection));
        }else{
            delete selectedPersonalCollection[this.swListingDisplay.baseEntityName.toLowerCase()];

            this.localStorageService.setItem('selectedPersonalCollection',angular.toJson(selectedPersonalCollection));
        }
        window.location.href = this.appConfig.baseURL+'?'+this.appConfig.action+'='+'entity.list'+this.swListingDisplay.baseEntityName.toLowerCase();
    }
    
    public deleteReportCollection = (persistedCollection)=>{
        this.$hibachi.saveEntity(
            'Collection',
            persistedCollection.collectionID,
            {},
            'delete'
        ).then((data)=>{

        });
    }
    
    public deletePersonalCollection = (personalCollection)=>{
        this.$hibachi.saveEntity(
            'Collection',
            personalCollection.collectionID,
            {
                'softDeleteFlag':true
            },
            'save'
        ).then((data)=>{
            if(this.localStorageService.hasItem('selectedPersonalCollection')){
                const selectedPersonalCollection = angular.fromJson(this.localStorageService.getItem('selectedPersonalCollection'));
                const currentSelectedPersonalCollection = selectedPersonalCollection[this.swListingDisplay.collectionConfig.baseEntityName.toLowerCase()];
                if(currentSelectedPersonalCollection){
                    const currentSelectedPersonalCollectionID = currentSelectedPersonalCollection.collectionID;
                    if(personalCollection.collectionID === currentSelectedPersonalCollectionID){
                        this.selectPersonalCollection();
                    }
                }
            }
            this.hasPersonalCollections = false;
            this.getPersonalCollections();
        });
    }

    public savePersonalCollection=(collectionName?)=>{
        if(
            this.localStorageService.hasItem('selectedPersonalCollection') &&
            this.localStorageService.getItem('selectedPersonalCollection')[this.swListingDisplay.collectionConfig.baseEntityName.toLowerCase()] &&
            (angular.isUndefined(this.personalCollectionIdentifier) ||
            (angular.isDefined(this.localStorageService.getItem('selectedPersonalCollection')[this.swListingDisplay.collectionConfig.baseEntityName.toLowerCase()]['collectionDescription']) &&
            this.localStorageService.getItem('selectedPersonalCollection')[this.swListingDisplay.collectionConfig.baseEntityName.toLowerCase()]['collectionDescription'] == this.personalCollectionIdentifier))
        ){
            var selectedPersonalCollection = angular.fromJson(this.localStorageService.getItem('selectedPersonalCollection'));
            if(selectedPersonalCollection[this.swListingDisplay.collectionConfig.baseEntityName.toLowerCase()]){

                this.$hibachi.saveEntity(
                    'Collection',
                    selectedPersonalCollection[this.swListingDisplay.collectionConfig.baseEntityName.toLowerCase()].collectionID,
                    {
                        'accountOwner.accountID':this.$rootScope.slatwall.account.accountID,
                        'collectionConfig':this.swListingDisplay.collectionConfig.collectionConfigString
                    },
                    'save'
                ).then((data)=>{

                });
                return;
            }

        }else if(collectionName){
            var serializedJSONData={
                'collectionConfig':this.swListingDisplay.collectionConfig.collectionConfigString,
                'collectionName':collectionName,
                'collectionDescription':this.personalCollectionIdentifier,
                'collectionObject':this.swListingDisplay.collectionConfig.baseEntityName,
                'accountOwner':{
                    'accountID':this.$rootScope.slatwall.account.accountID
                }
            }

            this.$hibachi.saveEntity(
                'Collection',
                "",
                {
                    'serializedJSONData':angular.toJson(serializedJSONData),
                    'propertyIdentifiersList':'collectionID,collectionName,collectionObject,collectionDescription'
                },
                'save'
            ).then((data)=>{

                if(!this.localStorageService.hasItem('selectedPersonalCollection')){
                    this.localStorageService.setItem('selectedPersonalCollection','{}');
                }
                var selectedPersonalCollection = angular.fromJson(this.localStorageService.getItem('selectedPersonalCollection'));

                selectedPersonalCollection[this.swListingDisplay.collectionConfig.baseEntityName.toLowerCase()] = {
                    collectionID:data.data.collectionID,
                    collectionObject:data.data.collectionObject,
                    collectionName:data.data.collectionName,
                    collectionDescription:data.data.collectionDescription
                }
                this.localStorageService.setItem('selectedPersonalCollection',angular.toJson(selectedPersonalCollection));
                this.$rootScope.slatwall.selectedPersonalCollection = selectedPersonalCollection;
                this.collectionNameSaveIsOpen = false;
                this.hasPersonalCollections=false;
            });
            return;
        }

        this.collectionNameSaveIsOpen = true;
    }

    public getPersonalCollections = ()=>{
        if(!this.hasPersonalCollections){
            var personalCollectionList = this.collectionConfig.newCollectionConfig('Collection');
            personalCollectionList.setDisplayProperties('collectionID,collectionName,collectionObject,collectionDescription');
            personalCollectionList.addFilter('accountOwner.accountID',this.$rootScope.slatwall.account.accountID);
            personalCollectionList.addFilter('collectionObject',this.swListingDisplay.baseEntityName);
            personalCollectionList.addFilter('reportFlag',0);
            personalCollectionList.addFilter('softDeleteFlag',true,"!=");
            if(angular.isDefined(this.personalCollectionIdentifier)){
                personalCollectionList.addFilter('collectionDescription',this.personalCollectionIdentifier);
            }
            personalCollectionList.setAllRecords(true);
            personalCollectionList.getEntity().then((data)=>{
                this.personalCollections = data.records;
            });
        }

        this.hasPersonalCollections=true;
    }

    public clearPersonalCollection = ()=>{
        this.selectPersonalCollection();
    }


    private search =()=>{
        if(this.swListingDisplay.searchText.length > 0 ){
            this.listingService.setExpandable(this.listingId, false);
        } else {
            this.listingService.setExpandable(this.listingId, true);
        }

        this.collectionConfig.setKeywords(this.swListingDisplay.searchText);

        this.swListingDisplay.collectionConfig = this.collectionConfig;

        this.observerService.notifyById('swPaginationAction',this.listingId, {type:'setCurrentPage', payload:1});

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
        listingId : "@?",
        showToggleSearch:"=?"
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
