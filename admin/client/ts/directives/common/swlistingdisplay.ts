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
        
        constructor(public $slatwall:ngSlatwall.SlatwallService){
            console.log('listingDisplayTest');
            console.log(this);
            //if collection Value is string instead of an object then create a collection
            if(angular.isString(this.collection)){
                this.collectionPromise = this.$slatwall.getEntity(this.collection);
                this.collectionPromise.then((data)=>{
                    this.collectionConfig = data.collectionConfig;
                    this.collection = data.pageRecords;
                    this.collectionID = data.collectionID;
                    this.collectionObject = data.collectionObject;
                    //prepare an exampleEntity for use
                    this.exampleEntity = this.$slatwall.newEntity(this.collectionObject);
                });
            }else{
                
            }
            
            if(angular.isDefined(this.exportAction)){
                exportAction = "/?slatAction=main.collectionExport&collectionExportID=";
            }
        }
        
        public getExportAction(){
            return this.exportAction+this.collectionID;    
        }
    }
	
	export class SWListingDisplay implements ng.IDirective{
		
		public restrict:string = 'E';
		public scope = {};
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
            recordEditAction:"=",
            recordEditActionProperty:"=",
            recordEditQueryString:"=",
            recordEditModal:"=",
            recordEditDisabled:"=",
            recordDetailAction:"=",
            recordDetailActionProperty:"=",
            recordDetailModal:"=",
            recordDeleteAction:"=",
            recordDeleteActionProperty:"=",
            recordDeleteQueryString:"=",
            recordProcessAction:"=",
            recordProcessActionProperty:"=",
            recordProcessQueryString:"=",
            recordProcessContext:"=",
            recordProcessEntity:"=",
            recordProcessUpdateTableID:"=",
            recordProcessButtonDisplayFlag:"=",
            
            /*Hierachy Expandable*/
            parentPropertyName:"=",
            
            /*Sorting*/
            sortProperty:"=",
            sortContextIDColumn:"=",
            sortContextIDValue:"=",
            
            /*Single Select*/
            selectFiledName:"=",
            selectValue:"=",
            selectTitle:"=",
            
            /*Multiselect*/
            multiselectFieldName:"=",
            multiselectPropertyIdentifier:"=",
            multiselectValues:"=",
            
            /*Helper / Additional / Custom*/
            tableattributes:"=",
            tableclass:"=",
            adminattributes:"=",
            
            /* Settings */
            showheader:"=",
            
            /* Basic Action Caller Overrides*/
            createModal:"=",
            createAction:"=",
            createQueryString:"=",
            exportAction:"="
        };
        public controller=SWListingDisplayController
        public controllerAs="swListingDisplay";
		public templateUrl;
		
		constructor(private $slatwall:ngSlatwall.SlatwallService,private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath+'listingdisplay.html';
		}
		
		public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
	}
    
	angular.module('slatwalladmin').directive('swListingDisplay',['$slatwall','partialsPath',($slatwall,partialsPath) => new SWListingDisplay($slatwall,partialsPath)]);
}

