/// <reference path='../../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../../client/typings/tsd.d.ts' />


module slatwalladmin {
    'use strict';
    
    export class SWListingDisplayController{
        /* local state variables */
        private columns = [];
        private allpropertyidentifiers:string = "";
        private allprocessobjectproperties:string = "false";
        private selectable:boolean = false;
        private multiselectable:boolean = false;
        private expandable:boolean = false;
        private sortable:boolean = false;
        private exampleEntity:any = "";
        private buttonGroup = [];
        private collectionPromise;
        private collectionObject;
        public static $inject = ['$scope','$element','$transclude','$slatwall','partialsPath','utilityService','collectionConfigService','paginationService','selectionService','observerService'];
        constructor(
            public $scope,
            public $element,
            public $transclude,
            public $slatwall:ngSlatwall.SlatwallService, 
            public partialsPath:slatwalladmin.partialsPath, 
            public utilityService:slatwalladmin.UtilityService,
            public collectionConfigService:slatwalladmin.CollectionConfig,
            public paginationService:slatwadmin.paginationService,
            public selectionService:slatwalladmin.SelectionService,
            public observerService:slatwalladmin.ObserverService
        ){
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$scope = $scope;
            this.$element = $element;
            this.collectionConfigService = collectionConfigService;
            this.paginationService = paginationService;
            this.selectionService = selectionService;
            this.observerService = observerService;
            //this is performed early to populate columns with swlistingcolumn info
            this.$transclude = $transclude;
            this.$transclude(this.$scope,()=>{});
             
            this.paginator = paginationService.createPagination();
            this.paginator.getCollection = this.getCollection;
            this.tableID = 'LD'+this.utilityService.createID();
             //if collection Value is string instead of an object then create a collection
            if(angular.isString(this.collection)){
                this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collection);
                
                if(!this.collectionConfig.columns){
                    this.collectionConfig.columns = [];    
                }
                
                angular.forEach(this.columns, (column)=>{
                    var lastEntity = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.collection,column.propertyIdentifier);
                    column.title = this.$slatwall.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
                    column.isVisible = column.isVisible || true;
                    this.collectionConfig.columns.push(column);
                });
                this.collectionConfig.setPageShow(this.paginator.pageShow);
                this.collectionConfig.setCurrentPage(this.paginator.currentPage);
                this.exampleEntity = this.$slatwall.newEntity(this.collection);
                var primarycolumn = {
                    propertyIdentifier:this.exampleEntity.$$getIDName(),
                    isVisible:false    
                }
                this.collectionConfig.columns.push(primarycolumn);
            }
            
            //setup export action
            if(angular.isDefined(this.exportAction)){
                this.exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
            }
            
            //Setup table class
            this.tableclass = this.tableclass || '';
            this.tableclass = this.utilityService.listPrepend(this.tableclass, 'table table-bordered table-hover', ' ');
            
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
                //add column so we can get child count
                var column = { 
                    propertyIdentifier:'_content_childContents',
                    aggregate:{
                        aggregateFunction:'count',
                        aggregateAlias:'childContentsPageCount'
                    }
                }; 
                
                this.collectionConfig.columns.push(column);
                var joins = [
                    {
                        "associationName":"childContents",
                        "alias":"_content_childContents"
                    },
                    {
                        "associationName":"site",
                        "alias":"_content_site"  
                    }
                ];
                this.collectionConfig.joins = joins;
                this.collectionConfig.groupBys = '_content';
                
                
                //attach observer so we know when a selection occurs
                this.observerService.attach(this.updateMultiselectValues,'swSelectionToggleSelection',this.collection);
            }
            if(this.multiselectable && !this.columns.length){
                //check if it has an active flag and if so then add the active flag
                if(this.exampleEntity.metaData.activeProperty){
                    this.collectionConfig.addFilter('activeFlag',1);
                }
                
            }
            
            //Look for Hierarchy in example entity
            if(!this.parentPropertyName || (this.parentPropertyName && !this.parentProopertyName.length) ){
                if(this.exampleEntity.metaData.hb_parentPropertyName){
                    this.parentPropertyName = this.exampleEntity.metaData.hb_parentPropertyName;
                }
            }
             //Setup Hierachy Expandable
            if(this.parentPropertyName && this.parentPropertyName.length){
                this.expandable = true;
                this.tableclass = this.utilityService.listAppend(this.tableclass,'table-expandable',' ');
                this.collectionConfig.addFilter(this.parentPropertyName+'.'+this.exampleEntity.$$getIDName(),'NULL','IS');
                this.allpropertyidentifiers = this.utilityService.listAppend(this.allpropertyidentifiers,this.exampleEntity.$$getIDName()+'Path');
                this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-parentidproperty='+this.parentPropertyname+'.'+this.exampleEntity.$$getIDName(),' ');
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
            if(this.multiselectValues && this.multiselectValues.length){
                //select all owned ids
                angular.forEach(this.multiselectValues.split(','),(value)=>{
                    this.selectionService.addSelection('ListingDisplay',value);
                });
                
                
            }
            
            
            this.getCollection();
            
        }
        
        public updateMultiselectValues = ()=>{
            console.log('updateMultiselect');
            this.multiselectValues = this.selectionService.getSelections('ListingDisplay');   
            console.log('msv');
            console.log(this.multiselectValues); 
        }
        
        public getCollection = ()=>{
            this.collectionConfig.setPageShow(this.paginator.getPageShow());
            this.collectionConfig.setCurrentPage(this.paginator.getCurrentPage());
            this.collectionConfig.setKeywords(this.paginator.keywords);
            this.collectionPromise = this.collectionConfig.getEntity();
            
            this.collectionPromise.then((data)=>{
                this.collectionData = data;
                this.collectionData.pageRecords = this.collectionData.pageRecords || this.collectionData.records
                this.paginator.setPageRecordsInfo(this.collectionData);
                //prepare an exampleEntity for use
                this.init();
                
            });    
            return this.collectionPromise;
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
        
        public init = () =>{
            
            //set defaults if value is not specified
            //this.edit = this.edit || $location.edit
            this.processObjectProperties = this.processObjectProperties || '';
            this.recordProcessButtonDisplayFlag = this.recordProcessButtonDisplayFlag || true;
            this.collectionConfig = this.collectionConfig || this.collectionData.collectionConfig;
            this.collectionID = this.collectionData.collectionID;
            this.collectionObject = this.collectionData.collectionObject;
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
            
            //Process
            if(this.recordProcessAction && this.recordProcessAction.length && this.recordProcessButtonDisplayFlag){
                this.administrativeCount++;
                this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");
                this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentity="'+this.recordProcessEntity.getClassName()+'"', " ");
                this.tableattributes = this.utilityService.listAppend(this.tableattributes, 'data-processentityid="'+this.recordProcessEntity.getPrimaryIDValue()+'"', " ");
    
                this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processaction="'+this.recordProcessAction+'"', " ");
                this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processcontext="'+this.recordProcessContext+'"', " ");
                this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processquerystring="'+this.recordProcessQueryString+'"', " ");
                this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-processupdatetableid="'+this.recordProcessUpdateTableID+'"', " ");
            }
            
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
        }
        
        private getAdminAttributesByType = (type:string):string =>{
            var recordActionName = 'record'+type.toUpperCase()+'Action';
            var recordActionPropertyName = recordActionName + 'Property';
            var recordActionQueryStringName = recordActionName + 'QueryString';
            var recordActionModalName = recordActionName + 'Modal';
            this.adminattributes = this.utilityService.listAppend(this.adminattributes, 'data-'+type+'action="'+this[recordActionName]+'"', " ");
            if(this[recordActionPropertyName] && this[recordActionPropertyName].length){
                this.adminattributes = this.utiltyService.listAppend(this.adminattribtues,'data-'+type+'actionproperty="'+this[recordActionPropertyName]+'"', " ");
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
             edit:"=",
            
             /*Optional*/
             title:"@",
            
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
             recordProcessAction:"@",
             recordProcessActionProperty:"@",
             recordProcessQueryString:"@",
             recordProcessContext:"@",
             recordProcessEntity:"=",
             recordProcessUpdateTableID:"=",
             recordProcessButtonDisplayFlag:"=",
            
             /*Hierachy Expandable*/
             parentPropertyName:"@",
            
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
             exportAction:"@"
        };
        public controller=SWListingDisplayController;
        public controllerAs="swListingDisplay";
		public templateUrl;
        public static $inject = ['partialsPath'];
		constructor(
            public partialsPath:hibachi.partialsPath 
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

