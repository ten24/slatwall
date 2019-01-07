/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWListingDisplayController{
    /* local state variables */
    public  actions = [];
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
    public columns = [];
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
    public recordAddAction:string;
    public recordDetailAction:string;
    public recordDetailActionIdProperty:string;
    public recordDetailActionIdKey:string;
    public recordDetailActionProperty:string;
    public recordEditAction:string;
    public recordDeleteAction:string;
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

    public selections;
    public multiselectCount;
    public isCurrentPageRecordsSelected;
    public allSelected;
    public name;
    public usingPersonalCollection:boolean;
    public personalCollectionIdentifier:string;
    public persistedReportCollections:any;
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
        //Invariant - We must have some way to instantiate. Everything can't be optional. --commented out due to breaking sku listing on product detail page
        // if (!(this.collectionConfig) && !this.collectionConfigs.length && !this.collection){
        //     return;
        // }
        if(angular.isUndefined(this.usingPersonalCollection)){
            this.usingPersonalCollection=false;
        }
        
        if(angular.isUndefined(this.showExport)){
            this.showExport = true;
        }
        
        if(angular.isUndefined(this.showFilters)){
           this.showFilters = true;
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
                 && this.listingService.hasPersonalCollectionSelected(this.baseEntityName)
             )
             && (
                angular.isUndefined(this.personalCollectionIdentifier) 
                || (
                    angular.isDefined(this.localStorageService.getItem('selectedPersonalCollection')[this.baseEntityName.toLowerCase()]['collectionDescription']) 
                    && this.localStorageService.getItem('selectedPersonalCollection')[this.baseEntityName.toLowerCase()]['collectionDescription'] == this.personalCollectionIdentifier
                )
            )
        ){
            var personalCollection = this.listingService.getPersonalCollectionByBaseEntityName(this.baseEntityName);
           
           // personalCollection.addFilter('collectionDescription',this.personalCollectionIdentifier);
            var originalMultiSlotValue = angular.copy(this.multiSlot);
            this.multiSlot = false;
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
            });

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

        if(angular.isDefined(this.collectionPromise)){
                this.hasCollectionPromise = true;
                this.multipleCollectionDeffered.reject();
        }

        if(this.collectionConfig != null){
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
        if(state.type){
            switch(state.type){
                case 'setCurrentPage':
                    this.collectionConfig.currentPage = state.payload;
                    break;
                case 'nextPage':
                    this.collectionConfig.currentPage = state.payload;
                    break;
                case 'prevPage':
                    this.collectionConfig.currentPage = state.payload;
                    break;
                case 'setPageShow':
                    this.collectionConfig.currentPage = 1;
                    this.collectionConfig.setPageShow(state.payload);
                    break;
            }
            if(this.collectionId){
            
                this.collectionConfig.baseEntityNameType = 'Collection';
                this.collectionConfig.id = this.collectionId;
            }
            this.getCollection = this.collectionConfig.getEntity().then((data)=>{
                this.collectionData = data;
                this.observerService.notifyById('swPaginationUpdate',this.tableID, this.collectionData);
            });

        }

    }

    private setupCollectionPromise=()=>{

    	if(angular.isUndefined(this.getCollection)){
            this.getCollection = this.listingService.setupDefaultGetCollection(this.tableID);
        }

        this.paginator.getCollection = this.getCollection;

        var getCollectionEventID = this.tableID;

        //this.observerService.attach(this.getCollectionObserver,'getCollection',getCollectionEventID);

        this.listingService.getCollection(this.tableID);
    }

    private getCollectionObserver=(param)=> {
        if(angular.isString(param.collectionConfig)){
            this.collectionConfig.loadJson(param.collectionConfig);
        }else{
            this.collectionConfig = param.collectionConfig;
        }
        
        this.collectionData = undefined;
        this.$timeout(
            ()=>{
                this.getCollection();
            }
        );
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
        if(this.recordDetailAction && this.recordDetailAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('detail');
        }
        if(this.recordEditAction && this.recordEditAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('edit');
        }
        if(this.recordDeleteAction && this.recordDeleteAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('delete');
        }
        if(this.recordAddAction && this.recordAddAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('add');
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
    public hasNumerical=()=>{
        
        // Iterate over columns, find out if we have any numericals and return
        if(this.columns.length){
            return this.columns.reduce((totalNumericalCols, col) => {
                return totalNumericalCols + (col.ormtype && 'big_decimal,integer,float,double'.indexOf(col.ormtype) >= 0) ? 1 : 0;
            });    
        }
        return false;
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

    private getAdminAttributesByType = (type:string):void =>{
        var recordActionName = 'record'+type.toUpperCase()+'Action';
        var recordActionPropertyName = recordActionName + 'Property';
        var recordActionQueryStringName = recordActionName + 'QueryString';
        var recordActionModalName = recordActionName + 'Modal';
        this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-'+type+'action="'+this[recordActionName]+'"', " ");
        if(this[recordActionPropertyName] && this[recordActionPropertyName].length){
            this.adminattributes = this.utilityService.listAppend(this.adminattributes,'data-'+type+'actionproperty="'+this[recordActionPropertyName]+'"', " ");
        }
        this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-'+type+'querystring="'+this[recordActionQueryStringName]+'"', " ");
        this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-'+type+'modal="'+this[recordActionModalName]+'"', " ");
    };

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
        persistedReportsCollectionList.addFilter('accountOwner.accountID',this.$rootScope.slatwall.account.accountID,'=','OR',true,true,false,'accountOwner');
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

            /*Admin Actions*/
            actions:"<?",
            administrativeCount:"@?",
            recordEditAction:"@?",
            recordEditActionProperty:"@?",
            recordEditQueryString:"@?",
            recordEditModal:"<?",
            recordEditDisabled:"<?",
            recordDetailAction:"@?",
            recordDetailActionProperty:"@?",
            recordDetailActionIdProperty:"@?",
            recordDetailActionIdKey:"@?",
            recordDetailQueryString:"@?",
            recordDetailModal:"<?",
            recordDeleteAction:"@?",
            recordDeleteActionProperty:"@?",
            recordDeleteQueryString:"@?",
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

            /*Hierachy Expandable*/
            parentPropertyName:"@?",
            //booleans
            expandable:"<?",
            expandableOpenRoot:"<?",

            /*Searching*/
            searchText:"<?",

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

            getChildCount:"<?",
            hasSearch:"<?",
            hasActionBar:"<?",
            multiSlot:"=?",
            customListingControls:"<?"
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
}
export{
    SWListingDisplay
}
