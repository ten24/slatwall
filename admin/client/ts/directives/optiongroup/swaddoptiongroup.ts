/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';
	
	export class SWAddOptionGroupController {
		
		public productId; 
		public product; 
		public productTypeID; 
		public optionGroups; 
		public optionGroupCollectionConfig;
		public productCollectionConfig; 
		
		public static $inject=["$slatwall", "$timeout", "collectionConfigService"];
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, private collectionConfigService:slatwalladmin.collectionConfigService){
			console.log("constructing");
			
			this.optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("OptionGroup");
			this.optionGroupCollectionConfig.setDisplayProperties("optionGroupID, optionGroupName, productTypes.productTypeID");
			
			this.productCollectionConfig = collectionConfigService.newCollectionConfig("Product");
			this.productCollectionConfig.setDisplayProperties("productID, productName, productType.productTypeID");
			this.productCollectionConfig.getEntity(this.productId).then((response)=>{
				this.product = response; 
				this.productTypeID = response.productType_productTypeID;
				this.updateOptionGroup(response.productType_productTypeID);
			}); 
			
			
		}
		
		public updateOptionGroup = (relatedProductTypeID?) =>{
			if(angular.isDefined(relatedProductTypeID)){
				this.optionGroupCollectionConfig.addFilter("productTypes.productTypeID", relatedProductTypeID); 
			} else { 
				this.optionGroupCollectionConfig.addFilter("productTypes.productTypeID", this.productTypeID);
			}
			this.optionGroupCollectionConfig.getEntity().then((response)=>{
				this.optionGroups = response.pageRecords; 
				console.log(this.optionGroups);
			});
		}
	
		
	}
    
    export class SWAddOptionGroup implements ng.IDirective{
        
		public static $inject=["$slatwall", "$timeout", "collectionConfigService", "partialsPath"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			productId:"@"
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