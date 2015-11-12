/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingDisplayController{
        /* local state variables */
       
        private adminattributes;
        private administrativeCount;
        private allpropertyidentifiers:string = "";
        private allprocessobjectproperties:string = "false";
        private buttonGroup = [];
        private collectionID;
        private collectionPromise;
        private collectionData;
        private collectionObject;
        private collectionConfig:slatwalladmin.CollectionConfig;
        private collection;
        private childPropertyName;
        private columns = [];
        private columnCount; 
        private entity:string; 
        private expandable:boolean;
        private exampleEntity:any = ""; 
        private exportAction;  
        private getCollection;
        private getChildCount;
        private hasCollectionPromise;
        private multiselectable:boolean = false;
        private multiselectFieldName;
        private multiselectIdPaths;
        private multiselectPropertyIdentifier;
        private multiselectValues;
        private norecordstext;
        private paginator;
        private parentPropertyName; 
        private processObjectProperties;
        private recordAddAction;
        private recordDetailAction;
        private recordEditAction;
        private recordDeleteAction
        private recordProcessButtonDisplayFlag;
        private searching:boolean = false;
        private searchText;
        private savedSearchText;
        private selectFieldName;
        private selectable:boolean = false;
        private sortable:boolean = false;
        private sortProperty;
        private tableID;
        private tableclass;
        private tableattributes;
        
        private _timeoutPromise;
        
        public static $inject = ['$scope','$element','$transclude','$timeout','$q','$slatwall','partialsPath','utilityService','collectionConfigService','paginationService','selectionService','observerService'];
        constructor(
            public $scope,
            public $element,
            public $transclude,
            public $timeout,
            public $q,
            public $slatwall:ngSlatwall.SlatwallService, 
            public partialsPath, 
            public utilityService:slatwalladmin.UtilityService,
            public collectionConfigService:slatwalladmin.CollectionConfig,
            public paginationService:slatwalladmin.PaginationService,
            public selectionService:slatwalladmin.SelectionService,
            public observerService:slatwalladmin.ObserverService
        ){
            this.$q = $q;
            this.$timeout = $timeout;
            this.$slatwall = $slatwall;
            this.$transclude = $transclude;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$scope = $scope;
            this.$element = $element;
            this.collectionConfigService = collectionConfigService;
            this.paginationService = paginationService;
            this.selectionService = selectionService;
            this.observerService = observerService;       
            this.intialSetup();
            
        }
        
        private intialSetup = () => {
             this.paginator = this.paginationService.createPagination();
            
            this.hasCollectionPromise = false;
            if(angular.isUndefined(this.getChildCount)){
                this.getChildCount = false;
            }
            
            
            if(this.collection){
                this.hasCollectionPromise = true;
            }else{
                this.collectionObject = this.entity;
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
            
            this.setupColumns();
            
            this.exampleEntity = this.$slatwall.newEntity(this.collectionObject);
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
            this.collectionConfig.setKeywords(this.paginator.keywords);
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
                this.exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
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
            this.norecordstext = this.$slatwall.getRBKey('entity.'+this.collectionObject+'.norecords');
            
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
                        var thisEntityName = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.exampleEntity.metaData.className, column.propertyIdentifier);
                        var thisPropertyName = this.utilityService.listLast(column.propertyIdentifier,'.');
                        var thisPropertyMeta = this.$slatwall.getPropertyByEntityNameAndPropertyName(thisEntityName,thisPropertyName);
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
                var lastEntity = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.collectionObject,column.propertyIdentifier);
                var title = this.$slatwall.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
                if(angular.isUndefined(column.isVisible)){
                    column.isVisible = true;
                }
                this.collectionConfig.addDisplayProperty(column.propertyIdentifier,title,column);
            });
            //if the passed in collection has columns perform some formatting
            if(this.hasCollectionPromise){
                //assumes alias formatting from collectionConfig
                angular.forEach(this.collectionConfig.columns, (column)=>{
                  var lastEntity = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.collectionObject,this.utilityService.listRest(column.propertyIdentifier,'.'));
                  column.title = column.title || this.$slatwall.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
                  if(angular.isUndefined(column.isVisible)){
                      column.isVisible = true;
                  }
                });
            }
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
	
	export class SWListingDisplay implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
        public transclude=true;
        public bindToController={
            
             isRadio:"=",
             //angularLink:true || false
             angularLinks:"=",
            
             /*required*/
             collection:"=",
             collectionConfig:"=",
             getCollection:"&?",
             collectionPromise:"=",
             edit:"=",
            
             /*Optional*/
             title:"@",
             entity:"@",
            
             /*Admin Actions*/
             recordEditAction:"@",
             recordEditActionProperty:"@",
             recordEditQueryString:"@",
             recordEditModal:"=",
             recordEditDisabled:"=",
             recordDetailAction:"@",
             recordDetailActionProperty:"@",
             recordDetailQueryString:"@",
             recordDetailModal:"=",
             recordDeleteAction:"@",
             recordDeleteActionProperty:"@",
             recordDeleteQueryString:"@",
             recordAddAction:"@",
             recordAddActionProperty:"@",
             recordAddQueryString:"@",
             recordAddModal:"=",
             recordAddDisabled:"=",
             
             recordProcessesConfig:"=",
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
             parentPropertyName:"@",
             //booleans
             expandable:"=",
             expandableOpenRoot:"=",
             
             /*Searching*/
             searchText:"=",
            
             /*Sorting*/
             sortProperty:"@",
             sortContextIDColumn:"@",
             sortContextIDValue:"@",
            
             /*Single Select*/
             selectFiledName:"@",
             selectValue:"@",
             selectTitle:"@",
            
             /*Multiselect*/
             multiselectFieldName:"@",
             multiselectPropertyIdentifier:"@",
             multiselectIdPaths:"@",
             multiselectValues:"@",
            
             /*Helper / Additional / Custom*/
             tableattributes:"@",
             tableclass:"@",
             adminattributes:"@",
            
             /* Settings */
             showheader:"=",
             
             /* Basic Action Caller Overrides*/
             createModal:"=",
             createAction:"@",
             createQueryString:"@",
             exportAction:"@",
             
             getChildCount:"="
        };
        public controller=SWListingDisplayController;
        public controllerAs="swListingDisplay";
		public templateUrl;
        public static $inject = ['partialsPath'];
		constructor(
            public partialsPath 
        ){
            this.partialsPath = partialsPath;
			this.templateUrl = this.partialsPath+'listingdisplay.html';
		} 
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes,controller, transclude) =>{
			scope.$on('$destroy',()=>{
               observerService.detachByID(scope.collection); 
            });
            
		}
	}
    
	angular.module('slatwalladmin').directive('swListingDisplay',['partialsPath',(partialsPath) => new SWListingDisplay(partialsPath)]);
}

