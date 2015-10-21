/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';
	
	export class optionWithGroup {
		constructor(
			public optionID:string,
			public optionGroupID:string,
			public match:boolean
		){
			
		}
		
		public toString = () => {
			return this.optionID;
		}
	}
	
	export class SWAddOptionGroupController {
		
		public optionGroups;
		public optionGroupIds; 
		public productId; 
		public product; 
		public productTypeID; 
		public productCollectionConfig;
		public skuCollectionConfig;
		public skus; 
		public usedOptions; 
		public selection; 
		public selectedOptionList;
		public showValidFlag; 
		public showInvalidFlag; 
		
		public static $inject=["$slatwall", "$timeout", "collectionConfigService", "observerService", "utilityService"];
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, 
				    private collectionConfigService:slatwalladmin.CollectionConfig, 
					private observerService:slatwalladmin.ObserverService,
					private utilityService:slatwalladmin.UtilityService
		){

			this.optionGroupIds = this.optionGroups.split(",");
			this.selection = [];
			
			this.showValidFlag = false; 
			this.showInvalidFlag = false;
			
			//this is done descending so that the option groups will line up when we compare them 
			for(var i=this.optionGroupIds.length-1; i>=0; i--){
				this.selection.push(new optionWithGroup("", this.optionGroupIds[i], false)); 
			} 
			
			
			this.productCollectionConfig = collectionConfigService.newCollectionConfig("Product");
			this.productCollectionConfig.setDisplayProperties("productID, productName, productType.productTypeID");
			
			this.productCollectionConfig.getEntity(this.productId).then((response)=>{
				
				this.product = response; 				
				this.productTypeID = response.productType_productTypeID;
				
				this.skuCollectionConfig = collectionConfigService.newCollectionConfig("Sku");
				this.skuCollectionConfig.setDisplayProperties("skuID, skuCode, product.productID"); 
				this.skuCollectionConfig.addFilter("product.productID", this.productId);
				this.skuCollectionConfig.setAllRecords(true);
				
				this.usedOptions = [];
				
				this.skuCollectionConfig.getEntity().then((response)=>{
					this.skus = response.records; 	
					angular.forEach(this.skus, (sku)=>{
						
						var optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
						
						optionCollectionConfig.setDisplayProperties("optionID, optionName, optionCode, optionGroup.optionGroupID");
						optionCollectionConfig.setAllRecords(true);
						optionCollectionConfig.addFilter("skus.skuID", sku.skuID);
						
						optionCollectionConfig.getEntity().then((response)=>{
							this.usedOptions.push(response.records);
						});
					});
				}); 
			}); 
			
			this.observerService.attach(this.validateOptions, "validateOptions");			
		}
		
		public getOptionList = () => {
			return this.utilityService.arrayToList(this.selection);  
		}
		
		public validateOptions = (args:Array<any>) => {

			this.addToSelection(args[0], args[1].optionGroupID); 		
			
			if( this.hasCompleteSelection() ){
				console.log("validating:   " + this.validateSelection());
				if(this.validateSelection()){
					this.selectedOptionList = this.getOptionList();
					console.log(this.selectedOptionList);
					this.showValidFlag = true; 
					this.showInvalidFlag = false; 
				} else { 
					this.showValidFlag = false; 
					this.showInvalidFlag = true; 
				}
			}
		}
		
		private validateSelection = () => {
			var valid = true; 
			angular.forEach(this.usedOptions, (combination) => {
				if(valid){
					var counter = 0;
					angular.forEach(combination, (usedOption) => {
						if(this.selection[counter].optionGroupID === usedOption.optionGroup_optionGroupID
						   && this.selection[counter].optionID != usedOption.optionID
						){
							this.selection[counter].match = true; 
						}
						counter++; 
					});
					if(!this.allSelectionFieldsValidForThisCombination()){
						valid = false; 
					} 
				}
			}); 
			
			return valid; 
		}	
		
		private allSelectionFieldsValidForThisCombination = () =>{
			var matches = 0; 
			angular.forEach(this.selection, (pair)=>{
				if(!pair.match){
					matches++; 
				}
				//reset 
				pair.match = false; 
			}); 
			return matches != this.selection.length; 
		}
			
		private hasCompleteSelection = () =>{ 
			var answer = true; 
			angular.forEach(this.selection, (pair)=>{
				console.log("length" + pair.optionID.length);
				if(pair.optionID.length === 0){
					answer = false; 
				}
			});
			return answer;
		}
		
		private addToSelection = (optionId:string, optionGroupId:string) => { 
			console.log("adding to selection");
			console.log(optionId);
			console.log(optionGroupId);
			angular.forEach(this.selection, (pair)=>{
				if(pair.optionGroupID === optionGroupId){
					pair.optionID = optionId; 
					return true; 
				}
			});
			return false; 
		}
		
	}
    
    export class SWAddOptionGroup implements ng.IDirective{
        
		public static $inject=["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			productId:"@", 
			optionGroups:"="
		}
		public controller=SWAddOptionGroupController;
        public controllerAs="swAddOptionGroup";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, 
					private collectionConfigService:slatwalladmin.CollectionConfig, 
					private observerService:slatwalladmin.ObserverService, private partialsPath
		){
			this.templateUrl = partialsPath + "entity/OptionGroup/addoptiongroup.html";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
    }
    
    angular.module('slatwalladmin').directive('swAddOptionGroup',
		["$slatwall", "$timeout", "collectionConfigService", "observerService", "partialsPath", 
			($slatwall, $timeout, collectionConfigService, observerService, partialsPath) => 
				new SWAddOptionGroup($slatwall, $timeout, collectionConfigService, observerService, partialsPath)]); 

}