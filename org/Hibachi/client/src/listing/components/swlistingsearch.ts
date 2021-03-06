/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import { ObserverService } from "../../core/core.module";
import { LocalStorageService } from "../../core/services/localstorageservice";
import { CollectionService } from "../../collection/services/collectionservice";

class SWListingSearchController {

    private filterPropertiesList;
    private collectionConfig;
    private paginator;
    private searchText;
    private backupColumnsConfig;
    private displayOptionsClosed:boolean=true;
    private filtersClosed:boolean=true;
    private showToggleFilters:boolean;
    private showToggleDisplayOptions:boolean;
    private showAutoRefresh:boolean;
    private newFilterPosition;
    private itemInUse;
    private getCollection;
    private listingId;
    public swListingDisplay:any;
    
    public searchableOptions;
    public searchableColumns:any[];
    private selectedSearchColumn;
   
    private selectedSearchFilter;
    public selectedWildCardPosition;
    public limitCountTotal;
    
    public swListingControls:any;
    public hasPersonalCollections = false;
    public personalCollections:any;
    public selectedPersonalCollection:any;
    public collectionNameSaveIsOpen = false;
    public printTemplateOptions:any[];
    public personalCollectionIdentifier:string;
    
    
    //Auto-refresh
    private autoRefreshIntervalReference = null;
    
    public defaultSearchColumn: any;

    public autoRefreshConfig : any  = {
        'autoRefreshInterval' : 30, // seconds --> for timeout x1000
        'autoRefreshEnabled' : false // if this is set the Listing-Display will refresh itself automatically; at the given `autoRefreshInterval`;
    };
    
    
    //@ngInject
    constructor(
        public $scope,
        public $rootScope,
        public $timeout,
        public $interval : ng.IIntervalService,
        public $hibachi,
        public metadataService,
        public listingService,
        public collectionService : CollectionService,
        public observerService : ObserverService,
        public localStorageService : LocalStorageService,
        public appConfig
    ) {
       
    }
    
    public searchableFilterOptions = [
            {
                title:'Last 1 Month',
                value:'lastOneMonth',
            },
            {
                title:'Last 2 Months',
                value:'lastTwoMonths',
            },
            {
                title:'Last 3 Months',
                value:'lastThreeMonths',
            },
            {
                title:'Last 6 Months',
                value:'lastSixMonths',
            },
            {
                title:'1 Year Ago',
                value:'lastOneYear',
            },
            {
                title:'All Time',
                value:'allRecords',
            }
        ];
        
    public wildCardPositionOptions = [
        {
            title:'Starts with',
            value:'right'
        },
        {
            title:'Ends with',
            value:'left'
        },
        {
            title:'Match Anywhere',
            value:'both'
        },
        {
            title:'Exact Match',
            value:'exact'
        }
    ];

    public $onInit=()=>{
        if(angular.isDefined(this.swListingDisplay.personalCollectionIdentifier)){
            this.personalCollectionIdentifier = this.swListingDisplay.personalCollectionIdentifier;
        }
        this.limitCountTotal = this.swListingDisplay.collectionConfig.limitCountTotal;//Fetching initial val from config
        //snapshot searchable options in the beginning
        this.searchableOptions = angular.copy(this.collectionConfig.columns);
        
        this.searchableColumns = [];
        for(var i = 0; i < this.searchableOptions.length; i++){
            if(this.searchableOptions[i].isSearchable){
                this.searchableColumns.push(this.searchableOptions[i].propertyIdentifier);
            }
        }

        
        if(angular.isDefined(this.swListingDisplay.collectionConfig.listingSearchConfig)){
            this.configureListingSearchConfigControls(this.swListingDisplay.collectionConfig.listingSearchConfig);
        }

        this.selectedSearchColumn={title:'All'};
        
        if(this.defaultSearchColumn){
            this.selectedSearchColumn = this.searchableOptions
                                                .find(column => column.propertyIdentifier === this.collectionConfig.baseEntityAlias+'.'+this.defaultSearchColumn);
        }

        if(!this.selectedSearchColumn){
            this.selectedSearchColumn = { title : 'All' };
        }
        
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
        
       if(this.showAutoRefresh) {
            // on init --> check to set time-out intervals
            let savedAutoRefreshConfig = this.localStorageService.getItem('selectedAutoRefreshConfigs')?.[this.swListingDisplay.personalCollectionKey] as any;
            
            if( savedAutoRefreshConfig ){
                this.autoRefreshConfig = savedAutoRefreshConfig;
            }
            
            if( savedAutoRefreshConfig?.autoRefreshEnabled){
                this.setupAutoRefreshTimeout();
            }
        }
    }
    
    public configureListingSearchConfigControls(searchConfig?) {
        if(!searchConfig) searchConfig = this.swListingDisplay.collectionConfig.listingSearchConfig;
        if(!searchConfig) return;
        if(angular.isDefined(searchConfig.selectedSearchFilterCode)){
             this.selectedSearchFilter = this.searchableFilterOptions
                                            .find(item => item.value === searchConfig.selectedSearchFilterCode );
        }

        if(angular.isDefined(searchConfig.wildCardPosition)){
             this.selectedWildCardPosition = this.wildCardPositionOptions
                                                .find(item => item.value === searchConfig.wildCardPosition );
        }
        
    }
    
    public changeSearchFilter = (filter)=>{
        if(this.swListingDisplay.collectionConfig.listingSearchConfig.selectedSearchFilterCode !== filter.value){
            this.selectedSearchFilter = filter; 
            this.updateListingSearchConfig({
                selectedSearchFilterCode : filter.value       
            });
        }
    }
    
    public changeWildCardPoition = (position)=>{
        if(this.swListingDisplay.collectionConfig.listingSearchConfig.wildCardPosition !== position.value){
            this.selectedWildCardPosition = position;
            this.updateListingSearchConfig({
                wildCardPosition : position.value      
            });
        }
    }

    private updateListingSearchConfig(config?) {
        var newListingSearchConfig = { ...this.swListingDisplay.collectionConfig.listingSearchConfig, ...config };
        this.swListingDisplay.collectionConfig.listingSearchConfig = newListingSearchConfig;//sets the value on listingsearchconfig
        this.observerService.notifyById('swPaginationAction',this.listingId, {type:'setCurrentPage', payload:1});//refreshes the listing
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
            selectedPersonalCollection[this.swListingDisplay.personalCollectionKey] = personalCollection;
            this.localStorageService.setItem('selectedPersonalCollection',angular.toJson(selectedPersonalCollection));
        }else{
            delete selectedPersonalCollection[this.swListingDisplay.personalCollectionKey];

            this.localStorageService.setItem('selectedPersonalCollection',angular.toJson(selectedPersonalCollection));
        }
        window.location.reload();
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
                const currentSelectedPersonalCollection = selectedPersonalCollection[this.swListingDisplay.personalCollectionKey];
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
    
    public onRefresh = () => {
        //notify - Refresh - Listing
        this.observerService.notifyById( 'refreshListingDisplay', this.listingId , null); // this.swListingDisplay.refreshListingDisplay();
    }
    
    public onToggleAutoRefereshEnabled = () => {
        
        if( !this.autoRefreshConfig.autoRefreshEnabled ){
            this.autoRefreshConfig.autoRefreshEnabled = true;
        } 
        else {
            this.autoRefreshConfig.autoRefreshEnabled = false;
        }
        
        // update local-storage
        this.saveSelectedAutoRefreshConfig(this.swListingDisplay.personalCollectionKey, this.autoRefreshConfig);
        
        
        if( !this.autoRefreshConfig.autoRefreshEnabled ){
            // set-timeouts
            this.setupAutoRefreshTimeout();
        } 
        else {
            // unset-timeouts
            this.clearAutoRefreshTimeout();
        }
    }
    
    public onSaveAutoRefereshConfig = () => {
        
        // update local-storage --> save autoRefreshConfig
        this.saveSelectedAutoRefreshConfig(this.swListingDisplay.personalCollectionKey, this.autoRefreshConfig);
        // update-timeputs
        this.setupAutoRefreshTimeout();
    }
    
    private saveSelectedAutoRefreshConfig = ( cacheKey: string, config) => {
	    let selectedAutoRefreshConfigs = this.localStorageService.getItem('selectedAutoRefreshConfigs') || {};
	    selectedAutoRefreshConfigs[ cacheKey ] = angular.copy(config);
	    this.localStorageService.setItem('selectedAutoRefreshConfigs', selectedAutoRefreshConfigs );
    }
    
    private setupAutoRefreshTimeout = () => {
        //clear old timeouts if any
        this.clearAutoRefreshTimeout();
        
        let thisAutoRefreshConfig =  this.localStorageService.getItem('selectedAutoRefreshConfigs')?.[this.swListingDisplay.personalCollectionKey] as any;
        
        if( thisAutoRefreshConfig?.autoRefreshEnabled ){
            this.autoRefreshIntervalReference = this.$interval(this.onRefresh, thisAutoRefreshConfig.autoRefreshInterval*1000);
        }
    }
    
    private clearAutoRefreshTimeout = () => {
        // remove interval
        this.$interval.cancel(this.autoRefreshIntervalReference);
        this.autoRefreshIntervalReference = null;
    }
    
    
    public savePersonalCollection=(collectionName?)=>{
        if(
            this.localStorageService.hasItem('selectedPersonalCollection') &&
            this.localStorageService.getItem('selectedPersonalCollection')[this.swListingDisplay.personalCollectionKey] &&
            (angular.isUndefined(this.personalCollectionIdentifier) ||
            (angular.isDefined(this.localStorageService.getItem('selectedPersonalCollection')[this.swListingDisplay.personalCollectionKey]['collectionDescription']) &&
            this.localStorageService.getItem('selectedPersonalCollection')[this.swListingDisplay.personalCollectionKey]['collectionDescription'] == this.personalCollectionIdentifier))
        ){
            var selectedPersonalCollection = angular.fromJson(this.localStorageService.getItem('selectedPersonalCollection'));
            if(selectedPersonalCollection[this.swListingDisplay.personalCollectionKey]){

                this.$hibachi.savePersonalCollection(
                    {
                        'entityID':selectedPersonalCollection[this.swListingDisplay.personalCollectionKey].collectionID,
                        'collectionConfig':this.swListingDisplay.collectionConfig.collectionConfigString
                    }
                ).then((data)=>{

                });
                return;
            }

        }else if(collectionName){
            var serializedJSONData={
                'collectionConfig':this.swListingDisplay.collectionConfig.collectionConfigString,
                'collectionName':collectionName,
                'collectionDescription':this.personalCollectionIdentifier,
                'collectionObject':this.swListingDisplay.collectionConfig.baseEntityName
            }

            this.$hibachi.savePersonalCollection(
                {
                    'serializedJSONData':angular.toJson(serializedJSONData),
                    'propertyIdentifiersList':'collectionID,collectionName,collectionObject,collectionDescription'
                }
            ).then((data)=>{

                if(!this.localStorageService.hasItem('selectedPersonalCollection')){
                    this.localStorageService.setItem('selectedPersonalCollection','{}');
                }
                var selectedPersonalCollection = angular.fromJson(this.localStorageService.getItem('selectedPersonalCollection'));

                selectedPersonalCollection[this.swListingDisplay.personalCollectionKey] = {
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
            personalCollectionList.addFilter('accountOwner.accountID','${account.accountID}');
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
        
        this.configureSearchableColumns(this.selectedSearchColumn);

        this.observerService.notifyById('swPaginationAction',this.listingId, {type:'setCurrentPage', payload:1});

    };

    private configureSearchableColumns=(column)=>{

        var searchableColumns = [];
        if(column.propertyIdentifier){
            searchableColumns.push(column.propertyIdentifier);
        }else{
            searchableColumns = this.searchableColumns;
        }
        
        if(!searchableColumns.length){
            return;
        }

        for(var i = 0; i < this.swListingDisplay.collectionConfig.columns.length; i++){
            if(searchableColumns.indexOf(this.swListingDisplay.collectionConfig.columns[i].propertyIdentifier) > -1){
                this.swListingDisplay.collectionConfig.columns[i].isSearchable = true;
            }
        }
    }

     public searchByEnterKey = (event)=>{
        if(event.keyCode == 13) {
                  this.search();
                  event.preventDefault();
                  
        }
    }


}

class SWListingSearch  implements ng.IDirective{

    public template = require("./listingsearch.html");
    public restrict = 'EA';
    
    public scope = {};
    public require = {swListingDisplay:"?^swListingDisplay",swListingControls:'?^swListingControls'}
    public bindToController =  {
        collectionConfig : "=",
        paginator : "=?",
        listingId : "@?",
        showAutoRefresh : "<?",
        showToggleSearch:"=?",
        defaultSearchColumn:"=?"
    };
    public controller = SWListingSearchController;
    public controllerAs = 'swListingSearch';
    
    public static Factory(){
        return /** @ngInject */ ()=> new this()
    }

}

export{
    SWListingSearch,
    SWListingSearchController
}
