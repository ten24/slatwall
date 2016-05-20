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
    public recordEditAction;
    public recordDeleteAction;
    public recordProcessButtonDisplayFlag;
    public searching:boolean = false;
    public searchText;

    public selectFieldName;
    public selectable:boolean = false;
    public showSearch;
    public showTopPagination;
    public sortable:boolean = false;
    public sortProperty;
    public tableID:string;
    public tableclass:string;
    public tableattributes:string;
    public hasSearch:boolean;

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
        public paginationService,
        public selectionService,
        public observerService,
        public rbkeyService
    ){
        //Common Setup
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
        this.setupTranscludedData(); 
        this.multipleCollectionPromise.then(()=>{
            //now do the intial setup
            this.setupInMultiCollectionConfigMode(); 
        }).catch(()=>{
            //do the initial setup for single collection mode
            this.setupInSingleCollectionConfigMode(); 
        }).finally(()=>{
            //if getCollection doesn't exist then create it
            if(angular.isUndefined(this.getCollection)){
                this.getCollection = this.setupDefaultGetCollection();
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
    
    private setupInSingleCollectionConfigMode = () => {
        
        if (angular.isUndefined(this.collectionObject) && angular.isDefined(this.collectionConfig)){
            this.collectionObject = this.collectionConfig.baseEntityName; 
        }
        
         //add filterGroups
        angular.forEach(this.filterGroups, (filterGroup)=>{
            this.collectionConfig.addFilterGroup(filterGroup);
        });

         //add filters
        this.setupColumns(this.collectionConfig, this.collectionObject);
        angular.forEach(this.filters, (filter)=>{
                this.collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        }); 
        
        //add order bys
        angular.forEach(this.orderBys, (orderBy)=>{
            this.collectionConfig.addOrderBy(orderBy.orderBy);
        });
        
        angular.forEach(this.aggregates, (aggregate)=>{
            this.collectionConfig.addDisplayAggregate(aggregate.propertyIdentifier, aggregate.aggregateFunction, aggregate.aggregateAlias);
        });
        
        //make sure we have necessary properties to make the actions 
        angular.forEach(this.actions, (action)=>{
            if(angular.isDefined(action.queryString)){
                var parsedProperties = this.utilityService.getPropertiesFromString(action.queryString);
                if(parsedProperties && parsedProperties.length){
                    this.collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
                }
            }
        });
        
        //also make sure we have necessary color filter properties
        angular.forEach(this.colorFilters,(colorFilter)=>{
            if(angular.isDefined(colorFilter.propertyToCompare)){
                this.collectionConfig.addDisplayProperty(colorFilter.propertyToCompare, "", {isVisible:false});
            }
        });
        
        this.exampleEntity = this.$hibachi.getEntityExample(this.collectionObject);
        if(this.collectionConfig.hasColumns()){
            this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName(),undefined,{isVisible:false});
        }
        
        this.initCollectionConfigData(this.collectionConfig);
        
        this.tableID = 'LD'+this.utilityService.createID();
        
        
        
        //this.getCollection();
        
        this.$scope.$watch('swMultiListingDisplay.collectionPromise',(newValue,oldValue)=>{
            if(newValue){
                this.$q.when(this.collectionPromise).then((data)=>{
                    this.collectionData = data;
                    this.setupDefaultCollectionInfo();
                    if(this.collectionConfig.hasColumns()){
                        this.setupColumns(this.collectionConfig, this.collectionObject);
                    }else{
                        this.collectionConfig.loadJson(data.collectionConfig);
                    }
                    this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records;
                    this.paginator.setPageRecordsInfo(this.collectionData);
                    this.searching = false;
                });
            }
        });
    };
    
    private setupInMultiCollectionConfigMode = () => {
        angular.forEach(this.collectionConfigs,(value,key)=>{
            this.collectionObjects[key] = value.baseEntityName;
        }); 
        this.buildCommonPropertiesList();
    };
    
    private buildCommonPropertiesList = () => {
        if(this.collectionObjects.length > 1){
            this.commonProperties = {}; 

            angular.forEach(this.collectionObjects,(objValue,objKey)=>{
                if(objKey == 0){
                    //first iteration only populate the commonProperties list with all properties we will then remove those that don't exists
                    angular.forEach(objValue.metaData,(propertyMetaData,propertyName)=>{
                        if(propertyName.charAt(0) != "$"){
                            this.commonProperties[propertyName] = propertyMetaData; 
                        }
                    }); 
                } else { 
                    //subsequent iterations we narrow down the list
                    angular.forEach(this.commonProperties,(propertyMetaData,propertyName)=>{
                        if(!(propertyName in objValue.metaData)){
                            delete this.commonProperties[propertyName];
                        }
                    });                  
                }
            }); 
        }
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

    private setupDefaultGetCollection = () =>{
        if(this.collectionConfigs.length == 0){
            this.collectionPromise = this.collectionConfig.getEntity();

            return ()=>{
                this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
                this.collectionConfig.setPageShow(this.paginator.getPageShow());
                this.collectionConfig.getEntity().then((data)=>{
                    this.collectionData = data;
                    this.setupDefaultCollectionInfo();
                    //this.setupColumns();
                    this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records;
                    this.paginator.setPageRecordsInfo(this.collectionData);
                });
            };
        } else { 
            //Multi Collection Config Info Here
            return ()=>{
                this.collectionData = {}; 
                this.collectionData.pageRecords = [];
                var allGetEntityPromises = [];
                angular.forEach(this.collectionConfigs,(collectionConfig,key)=>{
                    allGetEntityPromises.push(collectionConfig.getEntity());
                });      
                if(allGetEntityPromises.length){
                    this.$q.all(allGetEntityPromises).then(
                        (results)=>{
                            angular.forEach(results,(result,key)=>{
                                this.setupColumns(this.collectionConfigs[key], this.collectionObjects[key]);
                                this.collectionData.pageRecords = this.collectionData.pageRecords.concat(result.records); 
                            });
                        },
                        (reason)=>{
                           //error callback to be implemented
                        }
                    ); 
                } 
                //todo pagination logic
            }
        }
    };

    public initCollectionConfigData = (collectionConfig) =>{

        collectionConfig.setPageShow(this.paginator.pageShow);
        collectionConfig.setCurrentPage(this.paginator.currentPage);

        //setup export action
        if(angular.isDefined(this.exportAction)){
            this.exportAction = this.$hibachi.buildUrl('main.collectionExport')+'&collectionExportID=';
        }

        //Setup Select
        if(this.selectFieldName && this.selectFieldName.length){
            this.selectable = true;
            this.tableclass = this.utilityService.listAppend(this.tableclass,'table-select',' ');
            this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-selectfield="'+this.selectFieldName+'"', ' ');
        }

        //Setup MultiSelect
        if(this.multiselectFieldName && this.multiselectFieldName.length){
            this.multiselectable = true;
            this.tableclass = this.utilityService.listAppend(this.tableclass, 'table-multiselect',' ');
            this.tableattributes = this.utilityService.listAppend(this.tableattributes,'data-multiselectpropertyidentifier="'+this.multiselectPropertyIdentifier+'"',' ');


            //attach observer so we know when a selection occurs
            this.observerService.attach(this.updateMultiselectValues,'swSelectionToggleSelection',this.collectionObject);

            //attach observer so we know when a pagination change occurs
            this.observerService.attach(this.paginationPageChange,'swPaginationAction');
        }
        if(this.multiselectable && (!this.columns || !this.columns.length)){
            //check if it has an active flag and if so then add the active flag
            if(this.exampleEntity.metaData.activeProperty && !this.hasCollectionPromise){
                collectionConfig.addFilter('activeFlag',1,'=',undefined,true);
            }
        }

        //Look for Hierarchy in example entity
        if(!this.parentPropertyName || (this.parentPropertyName && !this.parentPropertyName.length) ){
            if(this.exampleEntity.metaData.hb_parentPropertyName){
                this.parentPropertyName = this.exampleEntity.metaData.hb_parentPropertyName;
            }
        }
        if(!this.childPropertyName || (this.childPropertyName && !this.childPropertyName.length) ){
            if(this.exampleEntity.metaData.hb_childPropertyName){
                this.childPropertyName = this.exampleEntity.metaData.hb_childPropertyName;
            }
        }
            //Setup Hierachy Expandable
        if(this.parentPropertyName && this.parentPropertyName.length && this.expandable !=false){
            if(angular.isUndefined(this.expandable)){
                this.expandable = true;
            }

            this.tableclass = this.utilityService.listAppend(this.tableclass,'table-expandable',' ');

            //add parent property root filter
            if(!this.hasCollectionPromise){
                collectionConfig.addFilter(this.parentPropertyName+'.'+this.exampleEntity.$$getIDName(),'NULL','IS', undefined, true);
            }
            //this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName()+'Path',undefined,{isVisible:false});
            //add children column
            if(this.childPropertyName && this.childPropertyName.length) {
                if(this.getChildCount || !this.hasCollectionPromise){
                    collectionConfig.addDisplayAggregate(
                        this.childPropertyName,
                        'COUNT',
                        this.childPropertyName+'Count'
                    );
                }
            }

            this.allpropertyidentifiers = this.utilityService.listAppend(this.allpropertyidentifiers,this.exampleEntity.$$getIDName()+'Path');
            this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-parentidproperty='+this.parentPropertyName+'.'+this.exampleEntity.$$getIDName(),' ');
        }

//            if(
//                !this.edit
//                && this.multiselectable
//                && (!this.parentPropertyName || !!this.parentPropertyName.length)
//                && (this.multiselectPropertyIdentifier && this.multiselectPropertyIdentifier.length)
//            ){
//                if(this.multiselectValues && this.multiselectValues.length){
//                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier,this.multiselectValues,'IN');
//                }else{
//                    this.collectionConfig.addFilter(this.multiselectPropertyIdentifier,'_','IN');
//                }
//            }

        if(this.multiselectIdPaths && this.multiselectIdPaths.length){
            angular.forEach(this.multiselectIdPaths.split(','),(value)=>{
                var id = this.utilityService.listLast(value,'/');
                this.selectionService.addSelection(this.name,id);
            });
        }

        if(this.multiselectValues && this.multiselectValues.length){
            //select all owned ids
            angular.forEach(this.multiselectValues,(value)=>{
                this.selectionService.addSelection(this.name,value);
            });
        }


        //set defaults if value is not specified
        //this.edit = this.edit || $location.edit
        this.processObjectProperties = this.processObjectProperties || '';
        this.recordProcessButtonDisplayFlag = this.recordProcessButtonDisplayFlag || true;
        //this.collectionConfig = this.collectionConfig || this.collectionData.collectionConfig;
        this.norecordstext = this.rbkeyService.getRBKey('entity.'+this.collectionObject+'.norecords');

        //Setup Sortability
        if(this.sortProperty && this.sortProperty.length){
            /*
            <cfif not arrayLen(attributes.smartList.getOrders())>
                <cfset thistag.sortable = true />

                <cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-sortable', ' ') />

                <cfset attributes.smartList.addOrder("#attributes.sortProperty#|ASC") />

                <cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, "#attributes.sortProperty#") />

                <cfif len(attributes.sortContextIDColumn) and len(attributes.sortContextIDValue)>
                    <cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-sortcontextidcolumn="#attributes.sortContextIDColumn#"', " ") />
                    <cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-sortcontextidvalue="#attributes.sortContextIDValue#"', " ") />
                </cfif>
            </cfif>
            */
        }

        //Setup the admin meta info
        this.administrativeCount = 0;

        //Detail
        if(this.recordDetailAction && this.recordDetailAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('detail');
        }

        //Edit
        if(this.recordEditAction && this.recordEditAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('edit');
        }

        //Delete
        if(this.recordDeleteAction && this.recordDeleteAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('delete');
        }

        //Add
        if(this.recordAddAction && this.recordAddAction.length){
            this.administrativeCount++;
            this.adminattributes = this.getAdminAttributesByType('add');
        }

        //Process
        // if(this.recordProcessAction && this.recordProcessAction.length && this.recordProcessButtonDisplayFlag){
        //     this.administrativeCount++;
        //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");

        //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentity="'+this.recordProcessEntity.metaData.className+'"', " ");
        //     this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentityid="'+this.recordProcessEntity.$$getID+'"', " ");

        //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processaction="'+this.recordProcessAction+'"', " ");
        //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");
        //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processquerystring="'+this.recordProcessQueryString+'"', " ");
        //     this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processupdatetableid="'+this.recordProcessUpdateTableID+'"', " ");
        // }

        //Setup the primary representation column if no columns were passed in
        /*
        <cfif not arrayLen(thistag.columns)>
            <cfset arrayAppend(thistag.columns, {
                propertyIdentifier = thistag.exampleentity.getSimpleRepresentationPropertyName(),
                title = "",
                tdclass="primary",
                search = true,
                sort = true,
                filter = false,
                range = false,
                editable = false,
                buttonGroup = true
            }) />
        </cfif>
        */

        //Setup the list of all property identifiers to be used later
        angular.forEach(this.columns,(column:any)=>{
            //If this is a standard propertyIdentifier
            if(column.propertyIdentifier){
                //Add to the all property identifiers
                this.allpropertyidentifiers = this.utilityService.listAppend(this.allpropertyidentifiers,column.propertyIdentifier);
                //Check to see if we need to setup the dynamic filters, etc
                //<cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
                if(
                    !column.searchable || !!column.searchable.length || !column.sort || !column.sort.length
                    ){
                    //Get the entity object to get property metaData

                    var thisEntityName = this.$hibachi.getLastEntityNameInPropertyIdentifier(this.exampleEntity.metaData.className, column.propertyIdentifier);
                    var thisPropertyName = this.utilityService.listLast(column.propertyIdentifier,'.');
                    var thisPropertyMeta = this.$hibachi.getPropertyByEntityNameAndPropertyName(thisEntityName,thisPropertyName);
                    /* <!--- Setup automatic search, sort, filter & range --->
                    <cfif not len(column.search) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent) && (!structKeyExists(thisPropertyMeta, "ormType") || thisPropertyMeta.ormType eq 'string')>
                        <cfset column.search = true />
                    <cfelseif !isBoolean(column.search)>
                        <cfset column.search = false />
                    </cfif>
                    <cfif not len(column.sort) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent)>
                        <cfset column.sort = true />
                    <cfelseif !isBoolean(column.sort)>
                        <cfset column.sort = false />
                    </cfif>
                    <cfif not len(column.filter) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent)>
                        <cfset column.filter = false />

                        <cfif structKeyExists(thisPropertyMeta, "ormtype") && thisPropertyMeta.ormtype eq 'boolean'>
                            <cfset column.filter = true />
                        </cfif>
                        <!---
                        <cfif !column.filter && listLen(column.propertyIdentifier, '._') gt 1>

                            <cfset oneUpPropertyIdentifier = column.propertyIdentifier />
                            <cfset oneUpPropertyIdentifier = listDeleteAt(oneUpPropertyIdentifier, listLen(oneUpPropertyIdentifier, '._'), '._') />
                            <cfset oneUpPropertyName = listLast(oneUpPropertyIdentifier, '.') />
                            <cfset twoUpEntityName = attributes.hibachiScope.getService("hibachiService").getLastEntityNameInPropertyIdentifier( attributes.smartList.getBaseEntityName(), oneUpPropertyIdentifier ) />
                            <cfset oneUpPropertyMeta = attributes.hibachiScope.getService("hibachiService").getPropertyByEntityNameAndPropertyName( twoUpEntityName, oneUpPropertyName ) />
                            <cfif structKeyExists(oneUpPropertyMeta, "fieldtype") && oneUpPropertyMeta.fieldtype eq 'many-to-one' && (!structKeyExists(thisPropertyMeta, "ormtype") || listFindNoCase("boolean,string", thisPropertyMeta.ormtype))>
                                <cfset column.filter = true />
                            </cfif>
                        </cfif>
                        --->
                    <cfelseif !isBoolean(column.filter)>
                        <cfset column.filter = false />
                    </cfif>
                    <cfif not len(column.range) && (!structKeyExists(thisPropertyMeta, "persistent") || thisPropertyMeta.persistent) && structKeyExists(thisPropertyMeta, "ormType") && (thisPropertyMeta.ormType eq 'integer' || thisPropertyMeta.ormType eq 'big_decimal' || thisPropertyMeta.ormType eq 'timestamp')>
                        <cfset column.range = true />
                    <cfelseif !isBoolean(column.range)>
                        <cfset column.range = false />
                    </cfif>*/
                }
            //Otherwise this is a processObject property
            }else if(column.processObjectProperty){
                column.searchable = false;
                column.sort = false;
                /*
                <cfset column.filter = false />
                <cfset column.range = false />
                */
                this.allprocessobjectproperties = this.utilityService.listAppend(this.allprocessobjectproperties, column.processObjectProperty);

            }
            if(column.tdclass){
                var tdclassArray = column.tdclass.split(' ');
                if(tdclassArray.indexOf("primary") >= 0 && this.expandable){
                    this.tableattributes = this.utilityService.listAppend(this.tableattributes,'data-expandsortproperty='+column.propertyIdentifier, " ")
                    column.sort = false;
                }
            }

        });
        //Setup a variable for the number of columns so that the none can have a proper colspan
        this.columnCount = (this.columns) ? this.columns.length : 0;

        if(this.selectable){
            this.columnCount++;
        }
        if(this.multiselectable){
            this.columnCount++;
        }
        if(this.sortable){
            this.columnCount++;
        }
        if(this.administrativeCount){
            this.administrativeCount++;
        }

        //Setup table class
        this.tableclass = this.tableclass || '';
        this.tableclass = this.utilityService.listPrepend(this.tableclass, 'table table-bordered table-hover', ' ');
    };
    //end initCollectionConfigData

    public setupColumns = (collectionConfig, collectionObject)=>{
        //assumes no alias formatting
        for(var i=0; i < this.columns.length; i++){
            var column = this.columns[i];
            var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(collectionConfig.baseEntityName,column.propertyIdentifier);

                if(angular.isUndefined(column.title)){
                    column.title = this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
                }
                
                if(angular.isUndefined(column.isVisible)){
                    column.isVisible = true;
                }
                var metadata = this.$hibachi.getPropertyByEntityNameAndPropertyName(lastEntity, this.utilityService.listLast(column.propertyIdentifier,'.'));
                if(angular.isDefined(metadata) && angular.isDefined(metadata.hb_formattype)){
                    column.type = metadata.hb_formatType;
                } else { 
                    column.type = "none";
                }
                if(angular.isDefined(column.tooltip)){
                
                    var parsedProperties = this.utilityService.getPropertiesFromString(column.tooltip);
                    
                    if(parsedProperties && parsedProperties.length){
                        collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
                    }
                } else { 
                    column.tooltip = '';
                }
                if(angular.isDefined(column.queryString)){
                    var parsedProperties = this.utilityService.getPropertiesFromString(column.queryString);
                    if(parsedProperties && parsedProperties.length){
                        collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
                    }
                }
                this.columnOrderBy(column);
                
                //only want to do this if it's a singleCollectionConfig
                //collectionConfig.addDisplayProperty(column.propertyIdentifier,column.title,column);
        }
        //if the passed in collection has columns perform some formatting
        if(this.hasCollectionPromise){
            //assumes alias formatting from collectionConfig
            angular.forEach(collectionConfig.columns, (column)=>{

                var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(collectionObject,this.utilityService.listRest(column.propertyIdentifier,'.'));
                column.title = column.title || this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
                if(angular.isUndefined(column.isVisible)){
                    column.isVisible = true;
                }
            });
        }
    };
    
    //this is going to be moved into a service
    public getKeyOfMatchedExpandableRule = (pageRecord)=>{
        var expandableRuleMatchedKey = -1; 
        if(angular.isDefined(this.expandableRules)){
            angular.forEach(this.expandableRules, (rule, key)=>{
                if(angular.isDefined(pageRecord[rule.filterPropertyIdentifier])){
                    if(angular.isString(pageRecord[rule.filterPropertyIdentifier])){
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier].trim(); 
                    } else {
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier]; 
                    }
                    switch (rule.filterComparisonOperator){
                        case "!=":
                            if(pageRecordValue != rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                        default: 
                            //= case
                            if(pageRecordValue == rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                    }
                    if(expandableRuleMatchedKey != -1){
                        return expandableRuleMatchedKey;
                    }
                }
            }); 
        }  
        return expandableRuleMatchedKey;
    }
    
    //this is going to be moved into a service
    public getPageRecordMatchesExpandableRule = (pageRecord)=>{
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(pageRecord); 
        return keyOfExpandableRuleMet != -1;  
    }
    
    //this is going to be moved into a service
    public getPageRecordChildCollectionConfigForExpandableRule = (pageRecord) => {
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(pageRecord); 
        if(angular.isDefined(pageRecord[this.exampleEntity.$$getIDName()]) 
            && angular.isDefined(this.childCollectionConfigs[pageRecord[this.exampleEntity.$$getIDName()]])
        ){
            return this.childCollectionConfigs[pageRecord[this.exampleEntity.$$getIDName()]];
        }
        if(keyOfExpandableRuleMet != -1){
           var childCollectionConfig = this.expandableRules[keyOfExpandableRuleMet].childrenCollectionConfig.clone();
           angular.forEach(childCollectionConfig.filterGroups[0], (filterGroup, key)=>{ 
                angular.forEach(filterGroup, (filter,key)=>{
                    if(angular.isString(filter.value) 
                        && filter.value.length 
                        && filter.value.charAt(0) == '$'
                    ){
                        filter.value = this.utilityService.replaceStringWithProperties(filter.value, pageRecord); 
                    }    
                });
           }); 
           this.childCollectionConfigs[pageRecord[this.exampleEntity.$$getIDName()]] = childCollectionConfig; 
           return this.childCollectionConfigs[pageRecord[this.exampleEntity.$$getIDName()]];
        } 
    }
    
    public getExampleEntityForExpandableRecord = (pageRecord) =>{
        var childCollectionConfig = this.getPageRecordChildCollectionConfigForExpandableRule(pageRecord);
        if(angular.isDefined(childCollectionConfig)){
            return this.$hibachi.getEntityExample(this.getPageRecordChildCollectionConfigForExpandableRule(pageRecord).baseEntityName);
        }
        return this.exampleEntity; 
    }
    
    public getColorFilterNGClassObject = (pageRecord)=>{
        var classObjectString = "{"; 
        angular.forEach(this.colorFilters, (colorFilter, index)=>{
            classObjectString = classObjectString.concat("'" + colorFilter.colorClass + "':" + this.getColorFilterConditionString(colorFilter, pageRecord));
            if(index<this.colorFilters.length-1){
                classObjectString = classObjectString.concat(",");
            }
        }); 
        return classObjectString + "}"; 
    };
    
    private getColorFilterConditionString = (colorFilter, pageRecord)=>{
       if(angular.isDefined(colorFilter.comparisonProperty)){
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + pageRecord[colorFilter.comparisonProperty.replace('.','_')];
       } else { 
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + colorFilter.comparisonValue;
       }
    };
    
    public toggleOrderBy = (column) => {
        if(this.collectionConfigs.length == 0){
            this.collectionConfig.toggleOrderBy(column.propertyIdentifier, true);
        } else {
            //multicollection logic here
        }
        this.getCollection();
    };
    
    public columnOrderBy = (column) => {
        var isfound = false;
        if(this.collectionConfigs.length == 0){
            angular.forEach(this.collectionConfig.orderBy, (orderBy, index)=>{
                if(column.propertyIdentifier == orderBy.propertyIdentifier){
                    isfound = true;
                    this.orderByStates[column.propertyIdentifier] = orderBy.direction;
                }
            });
        } else { 
            //multicollection logic here
        }
        if(!isfound){
            this.orderByStates[column.propertyIdentifier] = '';
        }
        return this.orderByStates[column.propertyIdentifier];
    };
    
    public columnOrderByIndex = (column) =>{
        var isfound = false;
        if(this.collectionConfigs.length == 0){
            angular.forEach(this.collectionConfig.orderBy, (orderBy, index)=>{
                if(column.propertyIdentifier == orderBy.propertyIdentifier){
                    isfound = true;
                    this.orderByIndices[column.propertyIdentifier] = index + 1;
                }
            });
        } else {
            //multicollection logic here
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
        if(propertyIdentifier){
            var propertyIdentifierWithoutAlias = '';
            if(propertyIdentifier.indexOf('_') === 0){
                propertyIdentifierWithoutAlias = propertyIdentifier.substring(propertyIdentifier.indexOf('.')+1,propertyIdentifier.length);
            }else{
                propertyIdentifierWithoutAlias = propertyIdentifier;
            }
            return this.utilityService.replaceAll(propertyIdentifierWithoutAlias,'.','_')
        }
        return '';
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
        return this.exportAction+this.collectionID;
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
        if(!this.collectionData.pageRecords) return;

        for(var i = 0; i < this.collectionData.pageRecords.length; i++){
            if(this.isCurrentPageRecordsSelected == true){
                this.selectionService.addSelection(this.name, this.collectionData.pageRecords[i][this.exampleEntity.$$getIDName()]);
            }else{
                this.selectionService.removeSelection(this.name, this.collectionData.pageRecords[i][this.exampleEntity.$$getIDName()]);
            }
        }
    };

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
        columns:"swListingColumns", 
        collectionConfigs:"?swCollectionConfigs",
        expandableRules:"?swExpandableRules"
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

            /*Admin Actions*/
            actions:"=?",
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


