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
    public collectionID;
    public collectionPromise;
    public collectionData;
    public collectionObject;
    public collectionConfig;
    public collection;
    public childPropertyName;
    public colorFilters = [];
    public columns = [];
    public columnCount;
    public expandable:boolean;
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
    public showFilters:boolean; 
    public showSearch;
    public showTopPagination;
    public sortable:boolean = false;
    public sortProperty;
    public tableID;
    public tableclass;
    public tableattributes;
    public hasSearch:boolean;

    public selections;
    public multiselectCount;
    public isCurrentPageRecordsSelected;
    public allSelected;
    public name;
    public pageShow;

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
        
        this.initialSetup();
    }

    private initialSetup = () => {
        if(angular.isUndefined(this.isAngularRoute)){
            this.isAngularRoute = true;    
        }
        //default search is available
        if(angular.isUndefined(this.hasSearch)){
            this.hasSearch = true;
        }

        if(angular.isUndefined(this.showFilters)){
            this.showFilters = false; 
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

        this.paginator = this.paginationService.createPagination();

        this.hasCollectionPromise = false;
        if(angular.isUndefined(this.getChildCount)){
            this.getChildCount = false;
        }


        if(!this.collection || !angular.isString(this.collection)){
            this.hasCollectionPromise = true;
        } else {
            this.collectionObject = this.collection;
            this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);
        }

        if(angular.isDefined(this.pageShow)){
            this.collectionConfig.setPageShow(this.pageShow);
        }

        this.setupDefaultCollectionInfo();

            //if columns doesn't exist then make it
        if(!this.collectionConfig.columns){
            this.collectionConfig.columns = [];
        }

        //if a collectionConfig was not passed in then we can run run swListingColumns
        //this is performed early to populate columns with swlistingcolumn info
        this.$transclude(this.$scope,()=>{});
        
        //add filterGroups
        angular.forEach(this.filterGroups, (filterGroup)=>{
            this.collectionConfig.addFilterGroup(filterGroup);
        });

         //add filters
        this.setupColumns();
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


        this.initData();
        this.$scope.$watch('swListingDisplay.collectionPromise',(newValue,oldValue)=>{
            if(newValue){
                this.collectionData = undefined;
                this.$q.when(this.collectionPromise).then((data)=>{
                    this.collectionData = data;
                    this.setupDefaultCollectionInfo();
                    if(this.collectionConfig.hasColumns()){
                        this.setupColumns();
                    }else{
                        this.collectionConfig.loadJson(data.collectionConfig);
                    }
                    this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records;
                    this.paginator.setPageRecordsInfo(this.collectionData);
                    this.searching = false;
                });
            }
        });
        this.tableID = 'LD'+this.utilityService.createID();
        //if getCollection doesn't exist then create it
        if(angular.isUndefined(this.getCollection)){
            this.getCollection = this.setupDefaultGetCollection();
        }
        this.paginator.getCollection = this.getCollection;
        //this.getCollection();
        var getCollectioneventID= (this.name || 'ListingDisplay');
        this.observerService.attach(this.getCollectionObserver,'getCollection',getCollectioneventID);
        this.$scope.$on('$destroy',()=>{
            this.observerService.detachById(getCollectioneventID);
        });
    };

    private getCollectionObserver=(param)=> {
        console.warn("getCollectionObserver", param)
        this.collectionConfig.loadJson(param.collectionConfig);
        this.collectionData = undefined;
        this.getCollection();
    };

    private setupDefaultCollectionInfo = () =>{
        if(this.hasCollectionPromise){
            this.collectionObject = this.collection.collectionObject;
            this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);
            this.collectionConfig.loadJson(this.collection.collectionConfig);
        }
        //this.collectionConfig.setPageShow(this.paginator.getPageShow());
        this.paginator.setPageShow(this.collectionConfig.getPageShow());
        this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
        //this.collectionConfig.setKeywords(this.paginator.keywords);
    };

    private setupDefaultGetCollection = () =>{
        this.collectionPromise = this.collectionConfig.getEntity();

        return ()=>{
            this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
            this.collectionConfig.setPageShow(this.paginator.getPageShow());
            this.collectionData = undefined;
            this.collectionConfig.getEntity().then((data)=>{
                this.collectionData = data;
                this.setupDefaultCollectionInfo();
                //this.setupColumns();
                this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records;
                this.paginator.setPageRecordsInfo(this.collectionData);
            });
        };
    };

    public initData = () =>{
        this.collectionConfig.setPageShow(this.paginator.pageShow);
        this.collectionConfig.setCurrentPage(this.paginator.currentPage);

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
            var selectionToggleEventName = 'swSelectionToggleSelection'+this.collectionObject;
            this.observerService.attach(this.updateMultiselectValues,'swSelectionToggleSelection',selectionToggleEventName);
            this.$scope.$on('$destroy',()=>{
                this.observerService.detachById(selectionToggleEventName);
            });

            //attach observer so we know when a pagination change occurs
            this.observerService.attach(this.paginationPageChange,'swPaginationAction');
            this.$scope.$on('$destroy',()=>{
                this.observerService.detachByEvent('swPaginationAction');
            });
        }
        if(this.multiselectable && (!this.columns || !this.columns.length)){
            //check if it has an active flag and if so then add the active flag
            if(this.exampleEntity.metaData.activeProperty && !this.hasCollectionPromise){
                this.collectionConfig.addFilter('activeFlag',1,'=',undefined,true);
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
                this.collectionConfig.addFilter(this.parentPropertyName+'.'+this.exampleEntity.$$getIDName(),'NULL','IS', undefined, true);
            }
            //this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName()+'Path',undefined,{isVisible:false});
            //add children column
            if(this.childPropertyName && this.childPropertyName.length) {
                if(this.getChildCount || !this.hasCollectionPromise){
                    this.collectionConfig.addDisplayAggregate(
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
            if(angular.isString(this.multiselectValues)){
                this.multiselectValues = this.multiselectValues.split(',');    
            }
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

    public setupColumns = ()=>{
        //assumes no alias formatting
        angular.forEach(this.columns, (column:any)=>{

            var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(this.collectionObject,column.propertyIdentifier);
            if(angular.isUndefined(column.title)){
                column.title = this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
            }
            if(angular.isUndefined(column.isVisible)){
                column.isVisible = true;
            }
            var metadata = this.$hibachi.getPropertyByEntityNameAndPropertyName(lastEntity, this.utilityService.listLast(column.propertyIdentifier,'.'));
            if(angular.isDefined(metadata) && angular.isDefined(metadata.hb_formattype)){
                column.type = metadata.hb_formattype;
            } else { 
                column.type = "none";
            }
            /* render flat until we have formatting*/
            if(
                column.type === 'email'
                || column.type === 'numeric'
                
            ){
                column.type='none';
            }
            
            if(angular.isDefined(column.tooltip)){
               
                var parsedProperties = this.utilityService.getPropertiesFromString(column.tooltip);
                
                if(parsedProperties && parsedProperties.length){
              
                    this.collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
                }
            } else { 
                column.tooltip = '';
            }
            if(angular.isDefined(column.queryString)){
                var parsedProperties = this.utilityService.getPropertiesFromString(column.queryString);
                if(parsedProperties && parsedProperties.length){
                    this.collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
                }
            }
            this.columnOrderBy(column);
            
            
            this.collectionConfig.addDisplayProperty(column.propertyIdentifier,column.title,column);
        });
        //if the passed in collection has columns perform some formatting
        if(this.hasCollectionPromise){
            //assumes alias formatting from collectionConfig
            angular.forEach(this.collectionConfig.columns, (column)=>{

                var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(this.collectionObject,this.utilityService.listRest(column.propertyIdentifier,'.'));
                column.title = column.title || this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
                if(angular.isUndefined(column.isVisible)){
                    column.isVisible = true;
                }
            });
        }
    };
    
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
        this.collectionConfig.toggleOrderBy(column.propertyIdentifier, true);
        this.getCollection();
    };
    
    public columnOrderBy = (column) => {
        var isfound = false;
        
        angular.forEach(this.collectionConfig.orderBy, (orderBy, index)=>{
             if(column.propertyIdentifier == orderBy.propertyIdentifier){
                 isfound = true;
                   this.orderByStates[column.propertyIdentifier] = orderBy.direction;
             }
        });
        if(!isfound){
            this.orderByStates[column.propertyIdentifier] = '';
        }
        return this.orderByStates[column.propertyIdentifier];
    };
    
    public columnOrderByIndex = (column) =>{
        var isfound = false;
        
        angular.forEach(this.collectionConfig.orderBy, (orderBy, index)=>{
             if(column.propertyIdentifier == orderBy.propertyIdentifier){
                 isfound = true;
                   this.orderByIndices[column.propertyIdentifier] = index + 1;
             }
        });
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
            return this.utilityService.replaceAll(propertyIdentifierWithoutAlias,'.','_');
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

        $('body').append('<form action="/?'+this.$hibachi.getConfigValue('action')+'=admin:main.collectionConfigExport" method="post" id="formExport"></form>');
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

class SWListingDisplay implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude=true;
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
            showFilters:"=?",
            showSearch:"=?",
            showTopPagination:"=?",

            /* Basic Action Caller Overrides*/
            createModal:"=?",
            createAction:"@?",
            createQueryString:"@?",
            exportAction:"@?",

            getChildCount:"=?",
            hasSearch:"=?",
            hasActionBar:"=?",

            showPagination:"@?",
            pageShow:"@?",

    };
    public controller=SWListingDisplayController;
    public controllerAs="swListingDisplay";
    public templateUrl;
    
    public static Factory(){
        var directive:ng.IDirectiveFactory=(
            corePartialsPath,
            hibachiPathBuilder
        ) => new SWListingDisplay(
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
        this.templateUrl = hibachiPathBuilder.buildPartialsPath(this.corePartialsPath)+'listingdisplay.html';
    }

}
export{
    SWListingDisplay
}


