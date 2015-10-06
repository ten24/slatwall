module slatwalladmin {
	'use strict';
	
	export class SWTypeaheadSearchController {
		
		public static $inject=["$slatwall", "collectionConfigService"];
		public entity:string;
		public properties:string;
		public placeholderText:string;  
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private collectionConfigService:slatwalladmin.collectionConfigService){
			collectionConfigService.newCollectionConfig(this.entity, this.properties); 
		}
		
	}
    
    export class SWTypeaheadSearch implements ng.IDirective{
        
		public static $inject=["$slatwall", "collectionConfigService"];
		
		public restrict = "E"; 
		public scope = {}	
		
		public bindToController = {
			entity:"=",
			properties:"=",
			placeholderText:"=?"
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
    
    angular.module('slatwalladmin').directive('swTypeaheadSearch',[() => new SWTypeaheadSearch()]); 

}