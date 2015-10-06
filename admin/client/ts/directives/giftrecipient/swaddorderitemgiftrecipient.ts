module slatwalladmin {
	'use strict';
	
	export class SWAddOrderItemRecipientController {
		
		public static $inject=["$slatwall", "collectionConfigService"];

		private typeaheadCollectionConfig; 
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private collectionConfigService:slatwalladmin.collectionConfigService){

		}
		
	}
    
    export class SWAddOrderItemRecipient implements ng.IDirective{
        
		public static $inject=["$slatwall", "collectionConfigService"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {

		}
		public controller=SWAddOrderItemRecipientController;
        public controllerAs="swAddOrderItemRecipient";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private collectionConfigService:slatwalladmin.collectionConfigService, private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath + "typeaheadsearch.html";
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

		}
    }
    
    angular.module('slatwalladmin').directive('swAddOrderItemRecipient',
		["$slatwall", "collectionConfigService", "partialsPath", 
			($slatwall, collectionConfigService, partialsPath) => 
				new SWAddOrderItemRecipient($slatwall, collectionConfigService, partialsPath)]); 

}