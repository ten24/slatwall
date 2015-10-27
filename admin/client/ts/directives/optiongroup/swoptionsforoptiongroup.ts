/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';
	
	export class SWOptionsForOptionGroupController {
		
		public optionGroupId; 
		public optionCollectionConfig;
		public optionGroupCollectionConfig; 
		
		public optionGroup; 
		public options; 
		public usedOptions; 
		
		public selectedOption; 
			
		public static $inject=["$slatwall", "$timeout", "collectionConfigService", "observerService"];
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, 
					private collectionConfigService:slatwalladmin.CollectionConfig, 
					private observerService:slatwalladmin.ObserverService
		){
			
			this.optionGroupCollectionConfig = collectionConfigService.newCollectionConfig("OptionGroup");
			this.optionGroupCollectionConfig.getEntity(this.optionGroupId).then((response)=>{
				this.optionGroup = response;
			});
			
			this.optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
			this.optionCollectionConfig.setDisplayProperties("optionID, optionName, optionGroup.optionGroupID");
			this.optionCollectionConfig.addFilter("optionGroup.optionGroupID", this.optionGroupId); 
			this.optionCollectionConfig.setAllRecords(true); 
			
			this.optionCollectionConfig.getEntity().then((response)=>{
				this.options = response.records; 
			});	
		}
		
		public validateChoice = () => {
			this.observerService.notify("validateOptions", [this.selectedOption, this.optionGroup]);
		}
	}
    
    export class SWOptionsForOptionGroup implements ng.IDirective{
        
		public static $inject=["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			optionGroupId:"@",
			usedOptions:"="
		}
		public controller=SWOptionsForOptionGroupController;
        public controllerAs="swOptionsForOptionGroup";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, 
					private collectionConfigService:slatwalladmin.CollectionConfig, 
					private observerService:slatwalladmin.ObserverService, private partialsPath
		){
			this.templateUrl = partialsPath + "entity/OptionGroup/optionsforoptiongroup.html";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
    }
    
    angular.module('slatwalladmin').directive('swOptionsForOptionGroup',
		["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath", 
			($slatwall, $timeout, collectionConfigService, observerService, partialsPath) => 
				new SWOptionsForOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath)]); 

}