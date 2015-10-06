module slatwalladmin {
	'use strict';
	
	export class SWTypeaheadSearchController {
		
		public static $inject=["$slatwall", "collectionConfigService"];
		public entity:string;
		public properties:string;
		public allRecords:boolean; 
		public placeholderText:string;  
		public searchText:string; 
		public results; 
		private typeaheadCollectionConfig; 
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private collectionConfigService:slatwalladmin.collectionConfigService){
			this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entity, this.properties);
			
			if(angular.isDefined(this.allRecords)){
				this.typeaheadCollectionConfig.setAllRecords(this.allRecords)
			} else {
				this.typeaheadCollectionConfig.setAllRecords(true); 
			}
		}
		
		public search = (search:string)=>{
			
			this.typeaheadCollectionConfig.setKeywords(search); 
			var promise = this.typeaheadCollectionConfig.getEntity();
			
			promise.then((response)=>{
				if(angular.isDefined(this.allRecords) && this.allRecords == false){
					this.results = response.pageRecords;
				} else {
					this.results = response;
				}	 
			});
		}
		
	}
    
    export class SWTypeaheadSearch implements ng.IDirective{
        
		public static $inject=["$slatwall", "collectionConfigService"];
		
		public restrict = "E"; 
		public scope = {}	
		
		public bindToController = {
			entity:"=",
			properties:"=",
			placeholderText:"=?",
			searchText:"=?",
			results:"=?"
		}
		public controller=SWTypeaheadSearchController;
        public controllerAs="swTypeaheadSearch";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private collectionConfigService:slatwalladmin.collectionConfigService, private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath + "typeaheadsearch.html";
			this.restrict = "EA";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

		}
    }
    
    angular.module('slatwalladmin').directive('swTypeaheadSearch',
		["$slatwall", "collectionConfigService", "partialsPath", 
			($slatwall, collectionConfigService, partialsPath) => 
				new SWTypeaheadSearch($slatwall, collectionConfigService, partialsPath)]); 

}