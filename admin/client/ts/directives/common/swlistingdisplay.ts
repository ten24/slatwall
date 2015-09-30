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
        public static $inject = ['$scope','$element','$transclude','$slatwall','partialsPath','utilityService','collectionConfigService'];
        constructor(
            public $scope,
            public $element,
            public $transclude,
            public $slatwall:ngSlatwall.SlatwallService, 
            public partialsPath:slatwalladmin.partialsPath, 
            public utilityService:slatwalladmin.UtilityService,
            public collectionConfigService:slatwalladmin.CollectionConfig
        ){
            this.$slatwall = $slatwall;
            this.partialsPath = partialsPath;
            this.utilityService = utilityService;
            this.$scope = $scope;
            this.$element = $element;
            this.collectionConfigService = collectionConfigService;
            //this is performed early to populate columns with swlistingcolumn info
            this.$transclude = $transclude;
            this.$transclude(this.$scope,()=>{});
            
             //if collection Value is string instead of an object then create a collection
            if(angular.isString(this.collection)){
                this.collectionConfig = this.collectionConfigService.newCollectionConfig(this.collection);
                /*
                propertyIdentifier:"@",
                processObjectProperty:"@",
                title:"@",
                tdclass:"@",
                search:"=",
                sort:"=",
                filter:"=",
                range:"=",
                editable:"=",
                buttonGroup:"="
                */
                angular.forEach(this.columns, (column)=>{
                    var columnOptions = {};
                    this.collectionConfig.setDisplayProperties(
                        column.propertyIdentifier,
                        column.title,
                        columnOptions
                        /*
                        ,*/
                    );
                });
                this.collectionPromise = this.collectionConfig.getEntity();
            }
            this.collectionPromise.then((data)=>{
                this.collectionData = data;
                //prepare an exampleEntity for use
                this.init();
            });
            
        }
        
        public init = () =>{
            
            //set defaults if value is not specified
            //this.edit = this.edit || $location.edit
            this.exampleEntity = this.$slatwall.newEntity(this.collectionData.collectionObject);
            this.recordProcessButtonDisplayFlag = this.recordProcessButtonDisplayFlag || true;
            this.collectionConfig = this.collectionConfig || this.collectionData.collectionConfig;
            this.collectionID = this.collectionData.collectionID;
            this.collectionObject = this.collectionData.collectionObject;
            this.norecordstext = this.$slatwall.getRBKey('entity.'+this.collectionObject+'.norecords');
            
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
                this.tableattributes = this.utiltiyService.listAppend(this.tableattributes,'data-multiselectpropertyidentifier="'+this.multiselectPropertyIdentifier+'"',' ');    
            }
            if(this.multiselectable && !this.columns.length){
                //check if it has an active flag and if so then add the active flag
                /*<cfif thistag.exampleEntity.hasProperty('activeFlag')>
                    <cfset attributes.smartList.addFilter("activeFlag", 1) />
                </cfif>*/ 
            }
            
            //Look for Hierarchy in example entity
            /*
            <cfif not len(attributes.parentPropertyName)>
                <cfset thistag.entityMetaData = getMetaData(thisTag.exampleEntity) />
                <cfif structKeyExists(thisTag.entityMetaData, "hb_parentPropertyName")>
                    <cfset attributes.parentPropertyName = thisTag.entityMetaData.hb_parentPropertyName />
                </cfif>
            </cfif>
            */
            
            //Setup Hierachy Expandable
            /*
            <cfif len(attributes.parentPropertyName) && attributes.parentPropertyName neq 'false'>
                <cfset thistag.expandable = true />
    
                <cfset attributes.tableclass = listAppend(attributes.tableclass, 'table-expandable', ' ') />
    
                <cfset attributes.smartList.joinRelatedProperty( attributes.smartList.getBaseEntityName() , attributes.parentPropertyName, "LEFT") />
                <cfset attributes.smartList.addFilter("#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#", "NULL") />
    
                <cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, "#thisTag.exampleEntity.getPrimaryIDPropertyName()#Path") />
    
                <cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-parentidproperty="#attributes.parentPropertyName#.#thistag.exampleEntity.getPrimaryIDPropertyName()#"', " ") />
    
                <cfset attributes.smartList.setPageRecordsShow(1000000) />
            </cfif>
            */
            
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
                    tdClass="primary",
                    search = true,
                    sort = true,
                    filter = false,
                    range = false,
                    editable = false,
                    buttonGroup = true
                }) />
            </cfif>
            */
            
            /*
            <!--- Setup the list of all property identifiers to be used later --->
            <cfloop array="#thistag.columns#" index="column">
    
                <!--- If this is a standard propertyIdentifier --->
                <cfif len(column.propertyIdentifier)>
    
                    <!--- Add to the all property identifiers --->
                    <cfset thistag.allpropertyidentifiers = listAppend(thistag.allpropertyidentifiers, column.propertyIdentifier) />
    
                    <!--- Check to see if we need to setup the dynamic filters, ect --->
                    <cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
    
                        <!--- Get the entity object to get property metaData --->
                        <cfset thisEntityName = attributes.hibachiScope.getService("hibachiService").getLastEntityNameInPropertyIdentifier( attributes.smartList.getBaseEntityName(), column.propertyIdentifier ) />
                        <cfset thisPropertyName = listLast( column.propertyIdentifier, "." ) />
                        <cfset thisPropertyMeta = attributes.hibachiScope.getService("hibachiService").getPropertyByEntityNameAndPropertyName( thisEntityName, thisPropertyName ) />
    
                        <!--- Setup automatic search, sort, filter & range --->
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
                        </cfif>
                    </cfif>
                <!--- Otherwise this is a processObject property --->
                <cfelseif len(column.processObjectProperty)>
                    <cfset column.search = false />
                    <cfset column.sort = false />
                    <cfset column.filter = false />
                    <cfset column.range = false />
    
                    <cfset thistag.allprocessobjectproperties = listAppend(thistag.allprocessobjectproperties, column.processObjectProperty) />
                </cfif>
                <cfif findNoCase("primary", column.tdClass) and thistag.expandable>
                    <cfset attributes.tableattributes = listAppend(attributes.tableattributes, 'data-expandsortproperty="#column.propertyIdentifier#"', " ") />
                    <cfset column.sort = false />
                </cfif>
            </cfloop>
            */
            
            /*
            <!--- Setup a variable for the number of columns so that the none can have a proper colspan --->
            <cfset thistag.columnCount = arrayLen(thisTag.columns) />
            <cfif thistag.selectable>
                <cfset thistag.columnCount += 1 />
            </cfif>
            <cfif thistag.multiselectable>
                <cfset thistag.columnCount += 1 />
            </cfif>
            <cfif thistag.sortable>
                <cfset thistag.columnCount += 1 />
            </cfif>
            <cfif attributes.administativeCount>
                <cfset thistag.columnCount += 1 />
            </cfif>
            <cfif attributes.administativeCount>
            </cfif>
            */
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
            public partialsPath:slatwalladmin.partialsPath 
        ){
            this.partialsPath = partialsPath;
            console.log('partialsPath');
            console.log(this.partialsPath);
			this.templateUrl = this.partialsPath+'listingdisplay.html';
		} 
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes,controller, transclude) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swListingDisplay',['partialsPath',(partialsPath) => new SWListingDisplay(partialsPath)]);
}

