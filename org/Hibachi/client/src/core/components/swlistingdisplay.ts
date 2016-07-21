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
    public  orderByStates = {}; 
    public  orderByIndices = {};
    public paginator;
    public parentPropertyName;
    public processObjectProperties;
    public recordAddAction;
    public recordDetailAction;
    public recordEditAction;
    public recordDeleteAction
    public recordProcessButtonDisplayFlag;
    public searching:boolean = false;
    public searchText;
    public savedSearchText;
    public selectFieldName;
    public selectable:boolean = false;
    private showSearch;
    private showTopPagination;
    public sortable:boolean = false;
    public sortProperty;
    public tableID;
    public tableclass;
    public tableattributes;
    public hasSearch:boolean;



    private _timeoutPromise;
    //@ngInject
    constructor(
        public $scope,
        public $element,
        public $transclude,
        public $timeout,
        public $q,
        public $hibachi,
        public utilityService,
        public collectionConfigService,
        public paginationService,
        public selectionService,
        public observerService,
        public rbkeyService
    ){
        console.log('here');
        console.log(this);
        this.$q = $q;
        this.$timeout = $timeout;
        this.$hibachi = $hibachi;
        this.$transclude = $transclude;
        this.utilityService = utilityService;
        this.$scope = $scope;
        this.$element = $element;
        this.collectionConfigService = collectionConfigService;
        this.paginationService = paginationService;
        this.selectionService = selectionService;
        this.observerService = observerService;
        this.rbkeyService = rbkeyService;
        this.initialSetup();
        this.$scope.$on('$destroy',()=>{
            this.observerService.detachById(this.$scope.collection);
        });
    }

    private initialSetup = () => {
        //default search is available
        if(angular.isUndefined(this.hasSearch)){
            this.hasSearch = true;
        }
        
        if(angular.isString(this.showSearch)){
            this.showSearch = (this.showSearch.toLowerCase() === 'true');
        }
        
        if(angular.isString(this.showTopPagination)){
            this.showTopPagination = (this.showTopPagination.toLowerCase() === 'true');
        };

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

        this.setupDefaultCollectionInfo();


            //if columns doesn't exist then make it
        if(!this.collectionConfig.columns){
            this.collectionConfig.columns = [];
        }

        //if a collectionConfig was not passed in then we can run run swListingColumns
        //this is performed early to populate columns with swlistingcolumn info
        this.$transclude(this.$scope,()=>{});
        
         //add filters
        this.setupColumns();
        angular.forEach(this.filters, (filter)=>{
            this.collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator);
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

        this.exampleEntity = this.$hibachi.newEntity(this.collectionObject);
        this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName(),undefined,{isVisible:false});


        this.initData();
        this.$scope.$watch('swListingDisplay.collectionPromise',(newValue,oldValue)=>{
            if(newValue){
                this.$q.when(this.collectionPromise).then((data)=>{
                    this.collectionData = data;
                    this.setupDefaultCollectionInfo();
                    this.setupColumns();
                    this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records
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
    }

    private setupDefaultCollectionInfo = () =>{
        if(this.hasCollectionPromise){
            this.collectionObject = this.collection.collectionObject;
            this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collectionObject);
            this.collectionConfig.loadJson(this.collection.collectionConfig);
        }
        this.collectionConfig.setPageShow(this.paginator.getPageShow());
        this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
        //this.collectionConfig.setKeywords(this.paginator.keywords);
    }

    private setupDefaultGetCollection = () =>{
        this.collectionPromise = this.collectionConfig.getEntity();
        return ()=>{
            this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
            this.collectionConfig.setPageShow(this.paginator.getPageShow());
            this.collectionConfig.getEntity().then((data)=>{
                this.collectionData = data;
                this.setupDefaultCollectionInfo();
                this.setupColumns();
                this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records
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
            this.observerService.attach(this.updateMultiselectValues,'swSelectionToggleSelection',this.collectionObject);
        }
        if(this.multiselectable && !this.columns.length){
            //check if it has an active flag and if so then add the active flag
            if(this.exampleEntity.metaData.activeProperty && !this.hasCollectionPromise){
                this.collectionConfig.addFilter('activeFlag',1);
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
        if(this.parentPropertyName && this.parentPropertyName.length){
            if(angular.isUndefined(this.expandable)){
                this.expandable = true;
            }

            this.tableclass = this.utilityService.listAppend(this.tableclass,'table-expandable',' ');
            //add parent property root filter
            if(!this.hasCollectionPromise){
                this.collectionConfig.addFilter(this.parentPropertyName+'.'+this.exampleEntity.$$getIDName(),'NULL','IS');
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
            this.collectionConfig.setAllRecords(true);
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
                this.selectionService.addSelection('ListingDisplay',id);
            });
        }

        if(this.multiselectValues && this.multiselectValues.length){
            //select all owned ids
            angular.forEach(this.multiselectValues.split(','),(value)=>{
                this.selectionService.addSelection('ListingDisplay',value);
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
        angular.forEach(this.columns,(column)=>{
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
        this.columnCount = this.columns.length;
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
    }

    public setupColumns = ()=>{
        //assumes no alias formatting
        angular.forEach(this.columns.reverse(), (column)=>{

            var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(this.collectionObject,column.propertyIdentifier);

            var title = this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
            if(angular.isUndefined(column.isVisible)){
                column.isVisible = true;
            }
            var metadata = this.$hibachi.getPropertyByEntityNameAndPropertyName(lastEntity, this.utilityService.listLast(column.propertyIdentifier,'.'));
            if(angular.isDefined(metadata) && angular.isDefined(metadata.hb_formattype)){
                column.type = metadata.hb_formattype;
            } else { 
                column.type = "none";
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
            
            
            this.collectionConfig.addDisplayProperty(column.propertyIdentifier,title,column);
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
    }
    
    private getColorFilterConditionString = (colorFilter, pageRecord)=>{
       if(angular.isDefined(colorFilter.comparisonProperty)){
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + pageRecord[colorFilter.comparisonProperty.replace('.','_')];
       } else { 
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + colorFilter.comparisonValue;
       }
    }
    
    public toggleOrderBy = (column) => {
        this.collectionConfig.toggleOrderBy(column.propertyIdentifier);
        this.getCollection();
    }
    
    public columnOrderBy = (column) => {
        var found = false; 
        
        angular.forEach(this.collectionConfig.orderBy, (orderBy, index)=>{
             if(column.propertyIdentifier == orderBy.propertyIdentifier){
                   found = true; 
                   this.orderByStates[column.propertyIdentifier] = orderBy.direction;
             }
        });
        if(!found){
            this.orderByStates[column.propertyIdentifier] = '';
        }
        return this.orderByStates[column.propertyIdentifier];
    }
    
    public columnOrderByIndex = (column) =>{
        var found = false; 
        
        angular.forEach(this.collectionConfig.orderBy, (orderBy, index)=>{
             if(column.propertyIdentifier == orderBy.propertyIdentifier){
                   found = true; 
                   this.orderByIndices[column.propertyIdentifier] = index + 1;
             }
        });
        if(!found){
            this.orderByIndices[column.propertyIdentifier] = '';
        }
        return this.orderByIndices[column.propertyIdentifier];
    }

    public updateMultiselectValues = ()=>{
        this.multiselectValues = this.selectionService.getSelections('ListingDisplay');
    }

    public escapeRegExp = (str)=> {
        return str.replace(/([.*+?^=!:${}()|\[\]\/\\])/g, "\\$1");
    }

    public replaceAll = (str, find, replace)=> {
        return str.replace(new RegExp(this.escapeRegExp(find), 'g'), replace);
    }

    public getPageRecordKey = (propertyIdentifier)=>{
        if(propertyIdentifier){
            var propertyIdentifierWithoutAlias = '';
            if(propertyIdentifier.indexOf('_') === 0){
                propertyIdentifierWithoutAlias = propertyIdentifier.substring(propertyIdentifier.indexOf('.')+1,propertyIdentifier.length);
            }else{
                propertyIdentifierWithoutAlias = propertyIdentifier;
            }
            return this.replaceAll(propertyIdentifierWithoutAlias,'.','_')
        }
        return '';
    }

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
    }

    public getExportAction = ():string =>{
        return this.exportAction+this.collectionID;
    }
}

class SWListingDisplay implements ng.IDirective{

    public restrict:string = 'E';
    public scope = {};
    public transclude=true;
    public bindToController={

            isRadio:"=?",
            //angularLink:true || false
            angularLinks:"=?",
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
            showSearch:"=?",
            showTopPagination:"=?",

            /* Basic Action Caller Overrides*/
            createModal:"=?",
            createAction:"@?",
            createQueryString:"@?",
            exportAction:"@?",

            getChildCount:"=?",
            hasSearch:"=?"
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


