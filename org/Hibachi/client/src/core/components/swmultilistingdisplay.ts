/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWMultiListingDisplayController{
    /* local state variables */
    public  actions = [];
    public adminattributes;
    public administrativeCount;
    public allpropertyidentifiers:string = "";
    public allprocessobjectproperties:string = "false";
    public aggregates = [];
    public buttonGroup = [];
    public childCollectionConfigs = {}; 
    public collectionID;
    public collectionPromise;
    public collectionData;
    public collectionObject;
    public collectionConfig;
    public collectionConfigs = [];
    public collectionObjects = [];
    public collection;
    public childPropertyName;
    public colorFilters = [];
    public columns = [];
    public columnCount;
    public commonProperties;
    public defaultSelectEvent;
    public disableRules = [];
    public expandable:boolean;
    public expandableRules = []; 
    public exampleEntity:any = "";
    public exportAction;
    public filters = [];
    public filterGroups = [];
    public isAngularRoute:boolean;
    public getCollection;
    public getChildCount;
    public hasCollectionPromise;
    public hideRules = []; 
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
    public paginator;
    public parentPropertyName;
    public processObjectProperties;
    public recordAddAction;
    public recordDetailAction;
    public recordDetailActionProperty;
    public recordEditAction;
    public recordDeleteAction;
    public recordProcessButtonDisplayFlag;
    public searching:boolean = false;
    public searchText;

    public selectFieldName;
    public selectable:boolean = false;
    public showSearch;
    public showTopPagination;
    public showSearchFilters = false; 
    public sortable:boolean = false;
    public sortProperty;
    public tableID:string;
    public tableclass:string;
    public tableattributes:string;
    public hasSearch:boolean;
    public baseEntity:any; 
    public baseEntityName:string; 
    public baseEntityID:string;

    public selections;
    public multiselectCount;
    public isCurrentPageRecordsSelected;
    public allSelected;
    public name;
    //@ngInject
    constructor(
        public $scope,
        public $transclude,
        public $q,
        public $hibachi,
        public utilityService,
        public collectionConfigService,
        public listingService, 
        public paginationService,
        public selectionService,
        public observerService,
        public rbkeyService
    ){
        this.tableID = 'LD'+this.utilityService.createID();
        
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

        if(angular.isUndefined(this.hasSearch)){
            this.hasSearch = true;
        }

        if(angular.isString(this.showSearch)){
            this.showSearch = (this.showSearch.toLowerCase() === 'true');
        }

        if(angular.isString(this.showTopPagination)){
            this.showTopPagination = (this.showTopPagination.toLowerCase() === 'true');
        }

        if(angular.isUndefined(this.name)){
            this.name = 'ListingDisplay';
        }

        if(angular.isUndefined(this.expandable)){
            this.expandable = false; 
        }

        //setup export action
        if(angular.isDefined(this.exportAction)){
            this.exportAction = this.$hibachi.buildUrl('main.collectionExport')+'&collectionExportID=';
        }

        this.paginator = this.paginationService.createPagination();

        this.hasCollectionPromise = false;
        if(angular.isUndefined(this.getChildCount)){
            this.getChildCount = false;
        }
        //This multiple collection logic could probably be in link too
        this.multipleCollectionDeffered = $q.defer();
        this.multipleCollectionPromise = this.multipleCollectionDeffered.promise;
        //Helps force single collection config mode 
        this.singleCollectionDeferred = $q.defer();
        this.singleCollectionPromise = this.singleCollectionDeferred.promise;
        this.singleCollectionPromise.then(()=>{
            this.multipleCollectionDeffered.reject(); 
        }); 

        if(!this.collection || !angular.isString(this.collection)){
            //I don't know if we want to make this assumption
            this.hasCollectionPromise = true;//maybe
            //this.multipleCollectionDeffered.reject();
        } else if(angular.isDefined(this.collection) && angular.isString(this.collection)){
            this.collectionObject = this.collection;
            this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);
            this.multipleCollectionDeffered.reject();
        }
        if( angular.isDefined(this.collectionConfig) 
            && angular.isUndefined(this.collectionConfig.columns)
        ){
            this.collectionConfig.columns = [];
        } else if (angular.isUndefined(this.collectionConfig)){
            //make it available to swCollectionConfig
            this.collectionConfig = null; 
        }
        this.listingService.setListingState(this.tableID, this);
        this.setupTranscludedData(); 
        this.multipleCollectionPromise.then(()=>{
            //now do the intial setup
            this.setupInMultiCollectionConfigMode(); 
        }).catch(()=>{
            //do the initial setup for single collection mode
            this.listingService.setupInSingleCollectionConfigMode(this.tableID,this.$scope); 
        }).finally(()=>{
            //if getCollection doesn't exist then create it
            if(angular.isUndefined(this.getCollection)){
                this.getCollection = this.listingService.setupDefaultGetCollection(this.tableID);
            }
            this.paginator.getCollection = this.getCollection;
            this.getCollection();
        });
        this.$scope.$on('$destroy',()=>{
            this.observerService.detachById(this.$scope.collection);
        });
    }
    
    private setupTranscludedData = () => {
        //this is performed early to populate columns and multiple collectionConfigs if present
        this.$transclude(this.$scope,()=>{});
    }
    
    private setupInMultiCollectionConfigMode = () => {
        angular.forEach(this.collectionConfigs,(value,key)=>{
            this.collectionObjects[key] = value.baseEntityName;
        }); 
    };

    private setupDefaultCollectionInfo = () =>{
        if(this.hasCollectionPromise 
            && angular.isDefined(this.collection) 
            && angular.isUndefined(this.collectionConfig)
        ){
            this.collectionObject = this.collection.collectionObject;
            this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);
            this.collectionConfig.loadJson(this.collection.collectionConfig);
        }
        this.collectionConfig.setPageShow(this.paginator.getPageShow());
        this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
        //this.collectionConfig.setKeywords(this.paginator.keywords);
    };

    public getKeyOfMatchedHideRule = (pageRecord)=>{
        return this.listingService.getKeyOfMatchedHideRule(this.tableID, pageRecord);
    }

    public getPageRecordMatchesHideRule = (pageRecord)=>{
        return this.listingService.getPageRecordMatchesHideRule(this.tableID, pageRecord); 
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
    
    //move this to the service
    public getExampleEntityForExpandableRecord = (pageRecord) =>{
        var childCollectionConfig = this.getPageRecordChildCollectionConfigForExpandableRule(pageRecord);
        if(angular.isDefined(childCollectionConfig)){
            return this.$hibachi.getEntityExample(this.getPageRecordChildCollectionConfigForExpandableRule(pageRecord).baseEntityName);
        }
        return this.exampleEntity; 
    }
    
    //move this to the service
    public getNGClassObjectForPageRecordRow = (pageRecord)=>{
        return this.listingService.getNGClassObjectForPageRecordRow(this.tableID, pageRecord);
    };
    
    //This is  basically td class
    public getNGClassObjectForPageRecordCell = (pageRecord,column)=>{
        var classObjectString = "{"; 
        return classObjectString + "}"; 
    };
    
    //move this to the service
    private getColorFilterConditionString = (colorFilter, pageRecord)=>{
       return this.listingService.getColorFilterConditionString(colorFilter, pageRecord);
    };

    private hasSingleCollectionConfig=()=>{
        return this.collectionConfig && this.collectionConfigs.length == 0;
    }
    
    public toggleOrderBy = (column) => {
        if(this.hasSingleCollectionConfig()){
            this.collectionConfig.toggleOrderBy(column.propertyIdentifier, true);
        } 
        this.getCollection();
    };
    
    public columnOrderByIndex = (column) =>{
        var isfound = false;
        if(this.hasSingleCollectionConfig()){
            angular.forEach(this.collectionConfig.orderBy, (orderBy, index)=>{
                if(column.propertyIdentifier == orderBy.propertyIdentifier){
                    isfound = true;
                    this.orderByIndices[column.propertyIdentifier] = index + 1;
                }
            });
        } 
        if(!isfound){
            this.orderByIndices[column.propertyIdentifier] = '';
        }
        return this.orderByIndices[column.propertyIdentifier];
    };

    public updateMultiselectValues = (res)=>{
        this.multiselectValues = this.selectionService.getSelections(this.name);
        if(this.selectionService.isAllSelected(this.name)){
            this.multiselectCount = this.collectionData.recordsCount - this.selectionService.getSelectionCount(this.name);
        }else{
            this.multiselectCount = this.selectionService.getSelectionCount(this.name);
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
    };


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

    public exportCurrentList =(selection:boolean=false)=>{
        if(this.collectionConfigs.length == 0){
            var exportCollectionConfig = angular.copy(this.collectionConfig.getCollectionConfig());
            if (selection && !angular.isUndefined(this.selectionService.getSelections(this.name))
                && (this.selectionService.getSelections(this.name).length > 0)) {
                exportCollectionConfig.filterGroups[0].filterGroup = [
                    {
                        "displayPropertyIdentifier": this.rbkeyService.getRBKey("entity."+exportCollectionConfig.baseEntityName.toLowerCase()+"."+this.exampleEntity.$$getIDName().toLowerCase()),
                        "propertyIdentifier": exportCollectionConfig.baseEntityAlias + "."+this.exampleEntity.$$getIDName(),
                        "comparisonOperator": (this.allSelected) ? "not in":"in",
                        "value": this.selectionService.getSelections(this.name).join(),
                        "displayValue": this.selectionService.getSelections(this.name).join(),
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
            .append("<input type='hidden' name='collectionConfig' value='" + angular.toJson(exportCollectionConfig) + "' />")
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
        this.selectionService.clearSelection(this.name);
    };

    public selectAll=()=>{
        this.selectionService.selectAll(this.name);
    };
}

class SWMultiListingDisplay implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude={
        addAction:"?swListingAddAction", 
        detailAction:"?swListingDetailAction", 
        deleteAction:"?swListingDeleteAction",
        editAction:"?swListingEditAction", 
        saveAction:"?swListingSaveAction",
        columns:"swListingColumns", 
        collectionConfigs:"?swCollectionConfigs",
        disableRules:"?swDisabledRowRules",
        expandableRules:"?swExpandableRowRules"
    };
    public bindToController={

            isRadio:"=?",
            angularLinks:"=?",
            isAngularRoute:"=?",
            name:"@?",

            /*required*/
            collection:"=?",
            collectionConfig:"=?",
            getCollection:"&?",
            collectionPromise:"=?",
            edit:"=?",

            /*Optional*/
            title:"@?",
            childPropertyName:"@?",
            baseEntity:"=?",
            baseEntityName:"@?",
            baseEntityId:"@?",

            /*Admin Actions*/
            actions:"=?",
            administrativeCount:"@?",
            recordEditAction:"@?",
            recordEditActionProperty:"@?",
            recordEditQueryString:"@?",
            recordEditModal:"=?",
            recordEditDisabled:"=?",
            recordDetailAction:"@?",
            recordDetailActionProperty:"@?",
            recordDetailQueryString:"@?",
            recordDetailModal:"=?",
            recordDeleteAction:"@?",
            recordDeleteActionProperty:"@?",
            recordDeleteQueryString:"@?",
            recordAddAction:"@?",
            recordAddActionProperty:"@?",
            recordAddQueryString:"@?",
            recordAddModal:"=?",
            recordAddDisabled:"=?",

            recordProcessesConfig:"=?",
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
            expandable:"=?",
            expandableOpenRoot:"=?",

            /*Searching*/
            searchText:"=?",

            /*Sorting*/
            sortProperty:"@?",
            sortContextIDColumn:"@?",
            sortContextIDValue:"@?",

            /*Single Select*/
            selectFiledName:"@?",
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
            adminattributes:"@?",

            /* Settings */
            showheader:"=?",
            showSearch:"=?",
            showTopPagination:"=?",
            showSearchFilters:"=?",

            /* Basic Action Caller Overrides*/
            createModal:"=?",
            createAction:"@?",
            createQueryString:"@?",
            exportAction:"@?",

            getChildCount:"=?",
            hasSearch:"=?",
            hasActionBar:"=?"
    };
    public controller=SWMultiListingDisplayController;
    public controllerAs="swMultiListingDisplay";
    public templateUrl;
    
    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,
            hibachiPathBuilder
        ) => new SWMultiListingDisplay(
            corePartialsPath,
            hibachiPathBuilder
        );
        directive.$inject =[
            'corePartialsPath',
            'hibachiPathBuilder'
        ];
        return directive;
    }
    //@ngInject
    constructor(
        public corePartialsPath,
        public hibachiPathBuilder
    ){
        this.corePartialsPath = corePartialsPath;
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+'multilistingdisplay.html';
    }

}
export{
    SWMultiListingDisplay
}


