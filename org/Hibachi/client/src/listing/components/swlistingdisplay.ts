/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingDisplayController{
    /* local state variables */
    public  actions = [];
    public actionBarActions;
    public listActions;
    public adminattributes;
    public administrativeCount;
    public allpropertyidentifiers:string = "";
    public allprocessobjectproperties:string = "false";
    public aggregates = [];
    public buttonGroup = [];
    public childCollectionConfigs = {};
    //not binding
    public collectionID;
    //binding
    public collectionId;
    public collectionPromise;
    public collectionData:any;
    public collectionObject:any;
    public collectionConfig:any;
    public collectionConfigs = [];
    public collectionObjects = [];
    public collection;
    public childPropertyName;
    public colorFilters = [];
    public _columns = [];
    
    get columns(): Array<any> {
        return this._columns;
    }
    set columns(newArray: Array<any>) {
        this._columns = newArray;
        this.columnCount = this._columns ? this._columns.length : 0;
    }
    
    public columnCount;
    public commonProperties;
    public customListingControls:boolean;
    public defaultSelectEvent;
    public disableRules = [];
    public edit:boolean;
    public expandable:boolean;
    public expandableRules = [];
    public exampleEntity:any = "";
    public exportAction;
    public emailAction;
    public printAction;
    public filters = [];
    public filterGroups = [];
    public isAngularRoute:boolean;
    public getCollection;
    public getChildCount;
    public hasCollectionPromise;
    public hideRules = [];
    public listingColumns;
    public multiSlot:boolean;
    public multiselectable:boolean = false;
    public multiselectFieldName;
    public multiselectIdPaths;
    public multiselectPropertyIdentifier;
    public multiselectValues;
    public multipleCollectionDeffered:any;
    public multipleCollectionPromise:any;
    public singleCollectionDeferred:any;
    public singleCollectionPromise:any;
    public norecordstext;
    public orderBys = [];
    public orderByStates = {};
    public orderByIndices = {};
    public paginator:any;
    public pageRecordsWithManualSortOrder = {};
    public parentPropertyName:string;
    public processObjectProperties;
    public hasRecordAddAction:boolean=false;
    public recordAddEvent:string;
    public recordAddAction:string;
    
    public hasRecordDetailAction:boolean=false;
    public recordDetailModal:boolean;
    public recordDetailEvent:string
    public recordDetailAction:string;
    public recordDetailActionProperty:string;
    public recordDetailActionPropertyIdentifier:string;
    public recordDetailQueryString:string;
    
    public hasRecordEditAction:boolean=false;
    public recordEditDisabled:boolean;
    public recordEditModal:boolean;
    public recordEditEvent:string
    public recordEditAction:string;
    public recordEditActionProperty:string;
    public recordEditActionPropertyIdentifier:string;
    public recordEditQueryString:string;
    public recordEditIcon:string='pencil';
    
    public hasRecordDeleteAction:boolean=false;
    public recordDeleteModal:boolean;
    public recordDeleteEvent:string
    public recordDeleteAction:string;
    public recordDeleteActionProperty:string;
    public recordDeleteActionPropertyIdentifier:string;
    public recordDeleteQueryString:string;
    
    public recordProcessButtonDisplayFlag:boolean;
    public reportAction:string;
    public searching:boolean = false;
    public searchText;

	public selectFieldName;
	public selectValue;
    public selectable:boolean = false;
    public showOrderBy:boolean;
    public showExport:boolean;
    public showPrintOptions:boolean; 
    public showSearch:boolean;
    public showReport:boolean;
    public showSearchFilters = false;
    public showTopPagination:boolean;
    public showFilters:boolean;
    public showToggleDisplayOptions:boolean;
    public sortable:boolean = false;
    public sortableFieldName:string;
    public sortProperty;
    public tableID:string;
    public tableclass:string;
    public tableattributes:string;
    public typeaheadDataKey:string;
    public hasSearch:boolean;
    public baseEntity:any;
    public baseEntityName:string;
    public baseEntityID:string;
    public currencyCode:string;

    public selections;
    public multiselectCount;
    public isCurrentPageRecordsSelected;
    public allSelected;
    public name;
    public usingPersonalCollection:boolean;
    public personalCollectionIdentifier:string;
    public personalCollectionKey:string;
    public persistedReportCollections:any;
    public customEndpoint: string;
    public hideUnfilteredResults:boolean;
    public refreshEvent: string;
    public loading: boolean;
    
    
    //@ngInject
    constructor(
        public $scope,
        public $rootScope,
        public $transclude,
        public $timeout,
        public $q,
        public $hibachi,
        public utilityService,
        public collectionConfigService,
        public listingService,
        public paginationService,
        public selectionService,
        public observerService,
        public rbkeyService,
        public localStorageService
    ){
       //init
       this.initListingDisplay( $q, $rootScope, true );

    }
    
    public $onInit = () => {
        // giving it a time-out to run this code in next digest-cycle, so everything is rendered 
        this.$timeout( () =>  this.startLoading() );
        
    }
    
    public refreshListingDisplay = () => {
        this.startLoading();
        
        this.getCollection = this.collectionConfig.getEntity().then((data)=>{
            this.setCollectionData(data);
            this.observerService.notifyById('swPaginationUpdate',this.tableID, this.collectionData);
        })
        .finally( () => this.stopLoading() );
    }
    
    public setCollectionData = ( collectionData) =>{
        this.collectionData = collectionData;
        this.stopLoading();
    }
    
    public startLoading = () => {
        
        if(this.loading) return;
        
        this.loading = true;
        // @ts-ignore from hibachiAssets/js/global.js
        window?.addLoadingDiv?.(this.tableID);
    }
    
    public stopLoading = () => {
        this.loading = false;
        
        this.$timeout( ()=> {
            // @ts-ignore from hibachiAssets/js/global.js
            window?.removeLoadingDiv?.(this.tableID);
        },100); // to avoide flickring of ng-repeat
    }
    
   /**
    * I pulled the ctor logic into its own method so we can reinintialize the 
    * collection on demand (refresh).
    **/
    public initListingDisplay = ($q, $rootScope, initial) => {
        
        //setup a listener for refreshing this listing based on a refrsh event string 
        if (this.refreshEvent && initial){
            this.observerService.attach(this.refreshListingDisplay, this.refreshEvent);
        }
        
        if (initial){
            this.observerService.attach(this.startLoading, "addOrderItemStartLoading");
        }
        
        if (initial){
            this.observerService.attach(this.stopLoading, "addOrderItemStopLoading");
        }
        
        if(angular.isUndefined(this.usingPersonalCollection)){
            this.usingPersonalCollection=false;
        }
        
        if(angular.isUndefined(this.showExport)){
            this.showExport = true;
        }
        
        if(angular.isUndefined(this.showFilters)){
           this.showFilters = true;
        }
        if(angular.isUndefined(this.actionBarActions)){
            this.actionBarActions = {
                export:true,
                print:true,
                email:true
            }
        }else if(typeof this.actionBarActions == 'string'){
            let actionBarArray = this.actionBarActions.split(',');
            this.actionBarActions = {};
            for(let i = 0; i< actionBarArray.length; i++){
                this.actionBarActions[actionBarArray[i]] = true;
            }
        }
        //promises to determine which set of logic will run
        this.multipleCollectionDeffered = $q.defer();
        this.multipleCollectionPromise = this.multipleCollectionDeffered.promise;
        this.singleCollectionDeferred = $q.defer();
        this.singleCollectionPromise = this.singleCollectionDeferred.promise;
        if(angular.isDefined(this.collection) && angular.isString(this.collection)){

            //not sure why we have two properties for this
            this.baseEntityName = this.collection;
            this.collectionObject = this.collection;
            this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);
            
            this.$timeout(()=>{
                this.collection = this.collectionConfig;
                this.columns = this.collectionConfig.columns;
            });

            this.multipleCollectionDeffered.reject();
        }

         if(
             (this.baseEntityName) 
             && (
                 this.usingPersonalCollection 
                 && this.listingService.hasPersonalCollectionSelected(this.personalCollectionKey)
             )
             && (
                angular.isUndefined(this.personalCollectionIdentifier) 
                || (
                    angular.isDefined(this.localStorageService.getItem('selectedPersonalCollection')[this.personalCollectionKey]['collectionDescription']) 
                    && this.localStorageService.getItem('selectedPersonalCollection')[this.personalCollectionKey]['collectionDescription'] == this.personalCollectionIdentifier
                )
            )
        ){
            if(angular.isUndefined(this.personalCollectionKey)){
                this.personalCollectionKey = this.baseEntityName.toLowerCase();
            }
            
            var personalCollection = this.listingService.getPersonalCollectionByBaseEntityName(this.personalCollectionKey);
           
           // personalCollection.addFilter('collectionDescription',this.personalCollectionIdentifier);
            var originalMultiSlotValue = angular.copy(this.multiSlot);
            this.multiSlot = false;
            
            this.startLoading();
            
            personalCollection.getEntity().then((data)=>{
                if(data.pageRecords.length){

                    this.collectionConfig = this.collectionConfigService.newCollectionConfig().loadJson(data.pageRecords[0].collectionConfig);
                    this.collectionConfig.setCurrentPage(1); //even if the saved collection config has a current page, we want to be on page 1 here
                    this.collectionObject = this.baseEntityName;

                    this.$timeout(()=>{
                        this.collection = this.collectionConfig;
                        this.columns = this.collectionConfig.columns;
                    });

                }else{
                    this.multiSlot = originalMultiSlotValue;
                }
                this.processCollection();
            })
            .finally( () => this.stopLoading());

         }else{
            $rootScope.hibachiScope.selectedPersonalCollection = undefined;
            this.processCollection();
        }
        
        if(!this.reportAction && this.baseEntityName){
            this.reportAction = 'entity.reportlist'+this.baseEntityName.toLowerCase();
        }
    }
    
    public processCollection = () =>{
        
        this.initializeState();

        if(angular.isDefined(this.collectionPromise) ){
                this.hasCollectionPromise = true;
                this.multipleCollectionDeffered.reject();
                console.log("Reject");
        }

        if(this.collectionConfig != null ){
            this.multipleCollectionDeffered.reject();
        }

        this.listingService.setListingState(this.tableID, this);
        if(this.collectionConfig && this.collectionConfig.keywords && this.collectionConfig.keywords.length){
            this.searchText = this.collectionConfig.keywords;
        }

        //this is performed after the listing state is set above to populate columns and multiple collectionConfigs if present
        this.$transclude(this.$scope,()=>{});

        this.hasCollectionPromise = angular.isDefined(this.collectionPromise);
        
        if(this.multiSlot){
            this.singleCollectionPromise.then(()=>{
                this.multipleCollectionDeffered.reject();
            });

            this.multipleCollectionPromise.then(
                ()=>{
                    //now do the intial setup
                    this.listingService.setupInMultiCollectionConfigMode(this.tableID);
                }
            ).catch(
                ()=>{
                    //do the initial setup for single collection mode
                    this.listingService.setupInSingleCollectionConfigMode(this.tableID,this.$scope);
                }
            ).finally(
                ()=>{
                    if(angular.isUndefined(this.getCollection)){
                        this.getCollection = this.listingService.setupDefaultGetCollection(this.tableID);
                    }
                    this.paginator.getCollection = this.getCollection;
                    this.observerService.attach(this.getCollectionObserver,'getCollection',this.tableID);
                    
                }
            );
        }else if(this.multiSlot == false){
            
            if(this.columns && this.columns.length){
                this.collectionConfig.columns = this.columns;
            } else if (this.listingColumns && this.listingColumns.length){
                this.columns = this.listingColumns;
            } else if (this.collectionConfig.columns && this.collectionConfig.columns.length){
                this.columns = this.collectionConfig.columns;
            }
            
            //setup selectable
            this.listingService.setupSelect(this.tableID);
            this.listingService.setupMultiselect(this.tableID);
            this.listingService.setupExampleEntity(this.tableID);
            this.setupCollectionPromise();

        }

        if(!this.collectionObject && (this.collectionConfig && this.collectionConfig.baseEntityName)){
            this.collectionObject = this.collectionConfig.baseEntityName;
        }

        if (this.collectionObject){
                this.exampleEntity = this.$hibachi.getEntityExample(this.collectionObject);
        }
        this.observerService.attach(this.getCollectionByPagination,'swPaginationAction',this.tableID);
    }
    
    public getCollectionByPagination = (state) =>{
        
        if(!this.hideUnfilteredResults || this.searchText || this.configHasFilters(this.collectionConfig) ){
            if(state.type){
                
                //Q: It doesn't make sense Here.
                if(this.collectionId){
                    this.collectionConfig.baseEntityNameType = 'Collection';
                    this.collectionConfig.id = this.collectionId;
                }
                
                switch(state.type){
                    case 'setCurrentPage':
                        this.collectionConfig.currentPage = state.payload;
                            this.refreshListingDisplay();
                        break;
                    case 'setPageShow':
                        this.collectionConfig.currentPage = 1;
                        this.collectionConfig.setPageShow(state.payload);
                            this.refreshListingDisplay();
                        break;
                }
            }
        } 
        else {
            this.setCollectionData(null);
        }
    }

    private setupCollectionPromise=()=>{

    	if(angular.isUndefined(this.getCollection)){
            this.getCollection = this.listingService.setupDefaultGetCollection(this.tableID);
        }

        this.paginator.getCollection = this.getCollection;

        // var getCollectionEventID = this.tableID;
        //this.observerService.attach(this.getCollectionObserver,'getCollection',getCollectionEventID);
        if(!this.hideUnfilteredResults || this.searchText || this.configHasFilters(this.collectionConfig) ){
            this.listingService.getCollection(this.tableID);
        }else{
            this.setCollectionData(null);
        }
    }

    private getCollectionObserver=(param)=> {
        if(angular.isString(param.collectionConfig)){
            this.collectionConfig.loadJson(param.collectionConfig);
        }else{
            this.collectionConfig = param.collectionConfig;
        }
        
        this.collectionData = undefined;
        
        if(!this.hideUnfilteredResults || this.searchText || this.configHasFilters(this.collectionConfig) ){
            this.$timeout(
                ()=>{
                    this.getCollection();
                }
            );
        }else{
            this.setCollectionData(null);
        }
    };

    private initializeState = () =>{
        if(this.name!=null){
            this.tableID = this.name;
        } else {
            this.tableID = 'LD'+this.utilityService.createID();
        }
        
        if (angular.isUndefined(this.collectionConfig)){
            //make it available to swCollectionConfig
            this.collectionConfig = null;
        }
        if(angular.isUndefined(this.multiSlot)){
            this.multiSlot = false;
        }
        if(angular.isDefined(this.administrativeCount)){
            this.administrativeCount = parseInt(this.administrativeCount);
        } else {
	        this.administrativeCount = 0;
        }
        
        //Administractive Action Setup
        this.hasRecordDetailAction = (this.recordDetailAction && this.recordDetailAction.length !== 0) || 
                                     (this.recordDetailEvent && this.recordDetailEvent.length !== 0);
        
        this.hasRecordEditAction = (this.recordEditAction && this.recordEditAction.length !== 0) || 
                                   (this.recordEditEvent && this.recordEditEvent.length !== 0);
        
        
        this.hasRecordDeleteAction = (this.recordDeleteAction && this.recordDeleteAction.length !== 0) || 
                                     (this.recordDeleteEvent && this.recordDeleteEvent.length !== 0);
        
        
        this.hasRecordAddAction = (this.recordAddAction && this.recordAddAction.length !== 0) ||
                                  (this.recordAddEvent && this.recordAddEvent.length !== 0);
        
        
        if( this.hasRecordDetailAction ){
            this.administrativeCount++;
            // this.getAdminAttributesByType('detail');
        }
        
        if( this.hasRecordEditAction ){
            this.administrativeCount++;
            // this.getAdminAttributesByType('edit');
        }
        
        if( this.hasRecordDeleteAction ){
            this.administrativeCount++;
            // this.getAdminAttributesByType('delete');
        }
        
        if( this.hasRecordAddAction ){
            this.administrativeCount++;
            // this.getAdminAttributesByType('add');
        }
        
        if( this.collectionConfig != null &&
            angular.isDefined(this.collection) &&
            angular.isDefined(this.collection.collectionConfig)
        ){
            this.collectionConfig = this.collection.collectionConfig;
        }
        if( angular.isUndefined(this.collectionObject) &&
            angular.isDefined(this.collection) &&
            angular.isDefined(this.collection.collectionObject)
        ){
            this.collectionObject = this.collection.collectionObject;
        }
        //set defaults if value is not specifies
        this.processObjectProperties = this.processObjectProperties || '';
        this.recordProcessButtonDisplayFlag = this.recordProcessButtonDisplayFlag || true;
        this.norecordstext = this.rbkeyService.getRBKey('entity.' + this.collectionObject + '.norecords');
        if(angular.isUndefined(this.defaultSelectEvent)){
            this.defaultSelectEvent = 'swSelectionToggleSelection' + this.tableID;
        }
        if(angular.isUndefined(this.isAngularRoute)){
            this.isAngularRoute = true;
        }
        if(angular.isUndefined(this.customListingControls)){
            this.customListingControls = false;
        }
        if(angular.isUndefined(this.hasSearch)){
            this.hasSearch = true;
            this.showSearch = true;
        }
        if(angular.isUndefined(this.showOrderBy)){
            this.showOrderBy = true;
        }
        if(angular.isUndefined(this.showReport)){
            this.showReport = false;
        }
        if(angular.isUndefined(this.showPrintOptions)){
            this.showPrintOptions = false; 
        }
        if(angular.isUndefined(this.showToggleDisplayOptions)){
            this.showToggleDisplayOptions = true; 
        }
        if(angular.isUndefined(this.expandable)){
            this.expandable = false;
        }
        //setup export action
        if(angular.isUndefined(this.exportAction)){
            this.exportAction = this.$hibachi.buildUrl('main.collectionExport')+'&collectionExportID=';
        }
        //setup print action
        if(angular.isDefined(this.printAction)){
            this.printAction = this.$hibachi.buildUrl('main.collectionPrint')+'&collectionExportID=';
        }
        //setup email action
        if(angular.isDefined(this.emailAction)){
            this.emailAction = this.$hibachi.buildUrl('main.collectionEmail')+'&collectionExportID=';
        }
        this.paginator = this.paginationService.createPagination(this.tableID);
        this.hasCollectionPromise = false;
        if(angular.isUndefined(this.getChildCount)){
            this.getChildCount = false;
        }
        //Setup table class
        this.tableclass = this.tableclass || '';
        this.tableclass = this.utilityService.listPrepend(this.tableclass, 'table table-bordered table-hover', ' ');
        if(this.collectionConfig){
            this.collectionConfig.setEventID(this.tableID);
            if(this.customEndpoint && this.customEndpoint.length){
                this.collectionConfig.setCustomEndpoint(this.customEndpoint);
            }
        }
       
        if(angular.isDefined(this.sortableFieldName)){
            this.sortableFieldName = "sorting" + this.tableID;
        }
    }

    public getListingPageRecordsUpdateEventString = () =>{
        return this.listingService.getListingPageRecordsUpdateEventString(this.tableID);
    }

    public getKeyOfMatchedHideRule = (pageRecord)=>{
        return this.listingService.getKeyOfMatchedHideRule(this.tableID, pageRecord);
    }

    public getPageRecordMatchesHideRule = (pageRecord)=>{
        return this.listingService.getPageRecordMatchesHideRule(this.tableID, pageRecord);
    }

    public getPageRecordValueByColumn = (pageRecord, column)=>{
        return this.listingService.getPageRecordValueByColumn(pageRecord, column);
    }

    public getKeyOfMatchedDisableRule = (pageRecord)=>{
        return this.listingService.getKeyOfMatchedExpandableRule(this.tableID, pageRecord);
    }

    public getPageRecordMatchesDisableRule = (pageRecord)=>{
        return this.listingService.getPageRecordMatchesDisableRule(this.tableID, pageRecord);
    }

    public getKeyOfMatchedExpandableRule = (pageRecord)=>{
        return this.listingService.getKeyOfMatchedExpandableRule(this.tableID, pageRecord);
    }

    public getPageRecordMatchesExpandableRule = (pageRecord)=>{
        return this.listingService.getPageRecordMatchesExpandableRule(this.tableID, pageRecord);
    }

    public getPageRecordChildCollectionConfigForExpandableRule = (pageRecord) => {
        return this.listingService.getPageRecordChildCollectionConfigForExpandableRule(this.tableID, pageRecord);
    }

    public getPageRecordRefreshChildrenEvent = (pageRecord) => {
        if(this.listingService.hasPageRecordRefreshChildrenEvent(this.tableID, pageRecord)){
            return this.listingService.getPageRecordRefreshChildrenEvent(this.tableID, pageRecord);
        } else {
            return "";
        }
    }

    public getExampleEntityForExpandableRecord = (pageRecord) =>{
        return this.listingService.getExampleEntityForExpandableRecord(this.tableID, pageRecord);
    }

    public getNGClassObjectForPageRecordRow = (pageRecord)=>{
        return this.listingService.getNGClassObjectForPageRecordRow(this.tableID, pageRecord);
    };

    public getNGClassObjectForPageRecordCell = (pageRecord,column)=>{
        var classObjectString = "{";
        return classObjectString + "}";
    };

    private getColorFilterConditionString = (colorFilter, pageRecord)=>{
       return this.listingService.getColorFilterConditionString(colorFilter, pageRecord);
    };

    private hasSingleCollectionConfig=()=>{
        return this.collectionConfig && this.collectionConfigs.length == 0;
    }

    public toggleOrderBy = (column) => {
        this.listingService.toggleOrderBy(this.tableID, column);
    };
    public showCalculation=(show = "total")=>{
        // Hide all other calculations
        $(`.sw-${(show == "total" ? "average" : "total")}`).hide();
        
        // Show all of the chosen calculations
        $(`.sw-${show}`).show();
    }
    
    public hasAverageOrTotal(){
        if(this.collectionData){
            for(var key in this.collectionData){
                if(key.indexOf('recordsAvg') > -1 || key.indexOf('recordsTotal') > -1){
                    return true
                }   
            }
        }
        
        return false;
    }
    
    public hasNumerical=()=>{
        
        // Iterate over columns, find out if we have any numericals and return
        if(this.columns != null && this.columns.length){
            
            return this.columns.reduce((totalNumericalCols, col) => {
            
                return totalNumericalCols + (col.ormtype && 'big_decimal,integer,float,double'.indexOf(col.ormtype) >= 0) ? 1 : 0;
            }, 0);    
        }
        return false;
    }
    
    private configHasFilters = (collectionConfig) =>{
        return collectionConfig.filterGroups 
            && collectionConfig.filterGroups.length
            && collectionConfig.filterGroups[0].filterGroup
            && collectionConfig.filterGroups[0].filterGroup.length
    }

    public columnOrderByIndex = (column) =>{
        return this.listingService.columnOrderByIndex(this.tableID, column);
    };

    public updateMultiselectValues = (res)=>{
        this.multiselectValues = this.selectionService.getSelections(this.tableID);

        if(this.selectionService.isAllSelected(this.tableID)){
            this.multiselectCount = this.collectionData.recordsCount - this.selectionService.getSelectionCount(this.tableID);
        }else{
            this.multiselectCount = this.selectionService.getSelectionCount(this.tableID);
        }
        switch (res.action){
            case 'uncheck':
                this.isCurrentPageRecordsSelected = false;
                break;
            case 'selectAll':
                this.allSelected = true;
                this.isCurrentPageRecordsSelected = false;
                break;
            case 'clear':
                this.allSelected = false;
                this.isCurrentPageRecordsSelected = false;
                break;
        }

        //dispatch the update to the store.
        this.listingService.listingDisplayStore.dispatch({
            type: "CURRENT_PAGE_RECORDS_SELECTED",
            payload: {listingID: this.tableID, selectionCount: this.multiselectCount, values: this.multiselectValues }
        });
    };

	public select = (selectValue)=>{
        this.selectValue = selectValue; 
    }

    public getPageRecordKey = (propertyIdentifier)=>{
       return this.listingService.getPageRecordKey(propertyIdentifier);
    };

    //not in use
    private getAdminAttributesByType = (type:string):void =>{
        var recordActionName = 'record' + this.capitalize(type) + 'Action';
        var recordActionPropertyName = recordActionName + 'Property';
        
        var recordActionModalName = 'record' + this.capitalize(type) + 'Modal';
        var recordQueryStringName = 'record' + this.capitalize(type) + 'QueryString';
        
        this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-'+type+'action="'+this[recordActionName]+'"', " ");
        
        if(this[recordActionPropertyName] && this[recordActionPropertyName].length){
            this.adminattributes = this.utilityService.listAppend(this.adminattributes,'data-'+type+'actionproperty="'+this[recordActionPropertyName]+'"', " ");
        }
        
        this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-'+type+'querystring="'+this[recordQueryStringName]+'"', " ");
        this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-'+type+'modal="'+this[recordActionModalName]+'"', " ");
    };
    
    public  makeQueryStringForAction(action:string, pageRecord) {
        let queryString = "";
        action = this.capitalize(action);
        
        let actionProppertyName = `record${action}ActionProperty`;
        let actionPropertyIdentifierName = `record${action}ActionPropertyIdentifier`;
        
        if( this[actionProppertyName] ) {
            queryString += '&' + this[actionProppertyName];
            if( this[actionPropertyIdentifierName] ) {
                queryString += '=' + pageRecord[this[actionPropertyIdentifierName]];
            } else {
                queryString += '=' + pageRecord[this[actionProppertyName]];
            }
        } else {
            queryString += '&' + this.exampleEntity.$$getIDName() + '=' + pageRecord[this.exampleEntity.$$getIDName()];
        }
        
        let actionQueryStringName = `record${action}QueryString`;
        if(this[actionQueryStringName]) {
            queryString += '&' + this[actionQueryStringName];
        } 
        
        return queryString;
    }

    private capitalize = (s) => {
      if (typeof s !== 'string' || s.length === 0) return s;
      
      return s.charAt(0).toUpperCase() + s.slice(1)
    }

    public getExportAction = ():string =>{
        return this.exportAction + this.collectionID;
    };

    public getPrintAction = ():string =>{
        return this.printAction + this.collectionID;
    };

    public getEmailAction = ():string =>{
        return this.emailAction + this.collectionID;
    };

    public exportCurrentList =(selection:boolean=false)=>{
        if(this.collectionId){
            $('body').append('<form action="/?'+this.$hibachi.getConfigValue('action')+'=main.collectionExport" method="post" id="formExport"></form>');
            $('#formExport')
                .append("<input type='hidden' name='collectionExportID' value='" + this.collectionId + "' />")
                .submit()
                .remove();
        }else{
            if(this.collectionConfigs.length == 0){
                var exportCollectionConfig = angular.copy(this.collectionConfig.getCollectionConfig());
                if (selection && !angular.isUndefined(this.selectionService.getSelections(this.tableID))
                    && (this.selectionService.getSelections(this.tableID).length > 0)) {
                    exportCollectionConfig.filterGroups[0].filterGroup = [
                        {
                            "displayPropertyIdentifier": this.rbkeyService.getRBKey("entity."+exportCollectionConfig.baseEntityName.toLowerCase()+"."+this.exampleEntity.$$getIDName().toLowerCase()),
                            "propertyIdentifier": exportCollectionConfig.baseEntityAlias + "."+this.exampleEntity.$$getIDName(),
                            "comparisonOperator": (this.allSelected) ? "not in":"in",
                            "value": this.selectionService.getSelections(this.tableID).join(),
                            "displayValue": this.selectionService.getSelections(this.tableID).join(),
                            "ormtype": "string",
                            "fieldtype": "id",
                            "conditionDisplay": "In List"
                        }
                    ];
                }
            } else {
                //multiCollectionConfig logic
            }
            $('body').append('<form action="/?'+this.$hibachi.getConfigValue('action')+'=main.collectionConfigExport" method="post" id="formExport"></form>');
            $('#formExport')
                .append("<input type='hidden' name='collectionConfig' value='" + angular.toJson(exportCollectionConfig).replace(/'/g,'&#39;') + "' />")
                .submit()
                .remove();
        }
    };
    
    public executeListAction(listAction:any){
        let data = {};
        if(listAction.selectedRecords){
            data[this.multiselectFieldName] = this.selectionService.getSelections(this.tableID).join();
        }
        $('body').append('<form action="/?'+this.$hibachi.getConfigValue('action')+'='+listAction.action+'" method="post" id="executeListAction"></form>');
        if(listAction.selectedRecords){
            $('#executeListAction').append("<input type='hidden' name='"+this.multiselectFieldName+"' value='" + this.selectionService.getSelections(this.tableID).join() + "' />")
        }
        $('#executeListAction').submit().remove();
    }

    public printCurrentList =(printTemplateID)=>{

        var exportCollectionConfig = angular.copy(this.collectionConfig.getCollectionConfig());

        $('body').append('<form action="?s=1" method="post" id="formPrint"></form>');
        
        $('#formPrint')
            .append("<input type='hidden' name='" + this.$hibachi.getConfigValue('action') +"' value='entity.processPrint' />")
            .append("<input type='hidden' name='redirectAction' value='admin:entity.list" + this.baseEntityName.toLowerCase() + "' />")
            .append("<input type='hidden' name='processContext' value='addToQueue' />")
            .append("<input type='hidden' name='printID' value='' />")
            .append("<input type='hidden' name='printTemplateID' value='" + printTemplateID +"' />")
            .append("<input type='hidden' name='collectionConfig' value='" + angular.toJson(exportCollectionConfig).replace(/'/g,'&#39;') + "' />");
        
        $('#formPrint')
            .submit()
            .remove();
    };

    public paginationPageChange=(res)=>{
        this.isCurrentPageRecordsSelected = false;
    };

    public selectCurrentPageRecords=()=>{
        this.listingService.selectCurrentPageRecords(this.tableID);
    };

    //these are no longer going to work
    public clearSelection=()=>{
        this.selectionService.clearSelection(this.tableID);
    };

    public selectAll=()=>{
        this.selectionService.selectAll(this.tableID);
    };
    
    public getPersistedReports = ()=>{
        var persistedReportsCollectionList = this.collectionConfig.newCollectionConfig('Collection');
        persistedReportsCollectionList.setDisplayProperties('collectionID,collectionName,collectionConfig');
        persistedReportsCollectionList.addFilter('reportFlag',1);
        persistedReportsCollectionList.addFilter('collectionObject',this.collectionConfig.baseEntityName);
        persistedReportsCollectionList.addFilter('accountOwner.accountID','${account.accountID}','=','OR',true,true,false,'accountOwner');
        persistedReportsCollectionList.addFilter('accountOwner.accountID','NULL','IS','OR',true,true,false,'accountOwner');
        persistedReportsCollectionList.setAllRecords(true);
        persistedReportsCollectionList.getEntity().then((data)=>{
            
            this.persistedReportCollections = data.records;
        });
    }
}

class SWListingDisplay implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude:any = {
        addAction:"?swListingAddAction",
        detailAction:"?swListingDetailAction",
        deleteAction:"?swListingDeleteAction",
        editAction:"?swListingEditAction",
        saveAction:"?swListingSaveAction",
        columns:"?swListingColumns",
        collectionConfigs:"?swCollectionConfigs",
        disableRules:"?swDisabledRowRules",
        expandableRules:"?swExpandableRowRules",
        customListingControls:"?swCustomListingControls"
    };
    public bindToController={
            usingPersonalCollection:"<?",
            personalCollectionIdentifier:'@?',
            personalCollectionKey:"@?",
            isRadio:"<?",
            angularLinks:"<?",
            isAngularRoute:"<?",
            name:"@?",

            /*required*/
            collection:"<?",
            collectionId:"@?",
            collectionConfig:"<?",
            getCollection:"&?",
            collectionPromise:"<?",
            edit:"<?",

            /*Optional*/
            title:"<?",
            childPropertyName:"@?",
            baseEntity:"<?",
            baseEntityName:"@?",
            baseEntityId:"@?",
            customEndpoint:"@?",

            /*Admin Actions*/
            actions:"<?",
            actionBarActions:"@?",
            administrativeCount:"@?",
            
            recordEditModal:"<?",
            recordEditEvent:"@?",
            recordEditAction:"@?",
            recordEditActionProperty:"@?",
            recordEditActionPropertyIdentifier:"@?",
            recordEditQueryString:"@?",
            recordEditDisabled:"<?",
            recordEditIcon:"@?",
            
            recordDetailModal:"<?",
            recordDetailEvent:"@?",
            recordDetailAction:"@?",
            recordDetailActionProperty:"@?",
            recordDetailActionPropertyIdentifier:"@?",
            recordDetailQueryString:"@?",
            
            recordDeleteModal:"<?",
            recordDeleteEvent:"@?",
            recordDeleteAction:"@?",
            recordDeleteActionProperty:"@?",
            recordDeleteActionPropertyIdentifier:"@?",
            recordDeleteQueryString:"@?",
            
            
            recordAddEvent:"@?",
            recordAddAction:"@?",
            recordAddActionProperty:"@?",
            recordAddQueryString:"@?",
            recordAddModal:"<?",
            recordAddDisabled:"<?",

            recordProcessesConfig:"<?",
            reportAction:"@?",
            /* record processes config is an array of actions. Example:
            [
            {
                recordProcessAction:"@",
                recordProcessActionProperty:"@",
                recordProcessQueryString:"@",
                recordProcessContext:"@",
                recordProcessEntity:"=",
                recordProcessEntityData:"=",
                recordProcessUpdateTableID:"=",
                recordProcessButtonDisplayFlag:"=",
            }
            ]
            */
            listActions:'<?',
            listingColumns:'<?',

            /*Hierachy Expandable*/
            parentPropertyName:"@?",
            //booleans
            expandable:"<?",
            expandableOpenRoot:"<?",

            /*Searching*/
            searchText:"<?",
            defaultSearchColumn:"@?",

            /*Sorting*/
            sortable:"<?",
            sortableFieldName:"@?",
            sortProperty:"@?",
            sortContextIDColumn:"@?",
            sortContextIDValue:"@?",

            /*Single Select*/
            selectFieldName:"@?",
            selectValue:"@?",
            selectTitle:"@?",

            /*Multiselect*/
            multiselectFieldName:"@?",
            multiselectPropertyIdentifier:"@?",
            multiselectIdPaths:"@?",
            multiselectValues:"@?",

            /*Helper / Additional / Custom*/
            tableattributes:"@?",
            tableclass:"@?",
            typeaheadDataKey:"@?",
            adminattributes:"@?",

            /* Settings */
            showheader:"<?",
            showExport:"<?",
            showOrderBy:"<?",
            showTopPagination:"<?",
            showToggleDisplayOptions:"<?",
            showSearch:"<?",
            showSearchFilters:"<?",
            showFilters:"<?",
            showSimpleListingControls:"<?",
            showPrintOptions:"<?",
            showReport:"<?",

            /* Basic Action Caller Overrides*/
            createModal:"<?",
            createAction:"@?",
            createQueryString:"@?",
            exportAction:"@?",
            
            currencyCode:"@?",
            getChildCount:"<?",
            hasSearch:"<?",
            hasActionBar:"<?",
            multiSlot:"=?",
            customListingControls:"<?",
            hideUnfilteredResults:"<?",
            refreshEvent:"@?"
    };
    public controller:any=SWListingDisplayController;
    public controllerAs="swListingDisplay";
    public templateUrl;
    
    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            listingPartialPath,
            hibachiPathBuilder
        ) => new SWListingDisplay(
            listingPartialPath,
            hibachiPathBuilder
        );
        directive.$inject =[
            'listingPartialPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        public listingPartialPath,
        public hibachiPathBuilder
    ){
        this.listingPartialPath = listingPartialPath;
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.listingPartialPath)+'listingdisplay.html';
    }

    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes, transclude) => {
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }
    
    // packaginh the template makes it load too fast, and causes issues with Workflow-detail and content-listing pages
    // public template= require('./listingdisplay.html');
    
    // public static Factory(){
    //     return /** @ngInject */ () => new this();
    // }
}
export{
    SWListingDisplay
}
