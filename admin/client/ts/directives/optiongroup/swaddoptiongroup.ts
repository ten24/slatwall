/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';
	
	export class SWAddOptionGroupController {
		
		public productID;
		public product; 
		public optionGroups; 
		public optionGroupCollectionConfig;
		public productCollectionConfig; 
		
		public static $inject=["$slatwall", "$timeout", "collectionConfigService"];
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, private collectionConfigService:slatwalladmin.collectionConfigService){
			this.optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("OptionGroup");
			this.optionGroupCollectionConfig.addDisplayProperty("productTypes.productTypeID");
			
			this.productCollectionConfig = collectionConfigService.newCollectionConfig("Product");
			
			this.productCollectionConfig.getEntity(this.productID).then((response)=>{
				this.product = response; 
			}); 
		}
		
		public updateOptionGroup = (productTypeID) =>{
			this.optionGroupCollectionConfig.addFilter("productTypes_productTypeID", productTypeID); 
			this.optionGroupCollectionConfig.getEntity().then((response)=>{
				this.optionGroups = response.pageRecords; 
			});
		}
	
		
	}
    
    export class SWAddOptionGroup implements ng.IDirective{
        
		public static $inject=["$slatwall", "$timeout", "collectionConfigService", "partialsPath"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			productID:"@"
		}
		public controller=SWAddOptionGroupController;
        public controllerAs="swAddOptionGroup";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, private collectionConfigService:slatwalladmin.collectionConfigService, private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath + "entity/OptionGroup/addoptiongroup.html";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
    }
    
    angular.module('slatwalladmin').directive('swAddOptionGroup',
		["$slatwall", "$timeout", "collectionConfigService", "partialsPath", 
			($slatwall, $timeout, collectionConfigService, partialsPath) => 
				new SWAddOptionGroup($slatwall, $timeout, collectionConfigService, partialsPath)]); 

}