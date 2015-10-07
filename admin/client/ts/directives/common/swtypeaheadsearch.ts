module slatwalladmin {
	'use strict';
	
	export class SWTypeaheadSearchController {
		
		public static $inject=["$slatwall", "collectionConfigService"];
		public entities:string;
		public properties:string;
		public propertiesToDisplay:string; 
		public allRecords:boolean; 
		public placeholderText:string;  
		public searchText:string; 
		public results; 
		public addFunction; 
		public addButtonFunction;
		public hideSearch;  
		
		private displayList;
		private entityList;  
		private typeaheadCollectionConfig; 
		private typeaheadCollectionConfigs; 
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private collectionConfigService:slatwalladmin.collectionConfigService){
			
			if(angular.isDefined(this.entities)){
				this.entityList = this.entities.split(",");
				this.typeaheadCollectionConfigs = new Array(); 
				angular.forEach(this.entityList, function(entity){
					this.typeaheadCollectionConfigs.push(collectionConfigService.newCollectionConfig(entity)); 
				});
			}	
			
			if(angular.isDefined(this.propertiesToDisplay)){
				this.displayList = this.propertiesToDisplay.split(",");
			}
			
			if(angular.isDefined(this.allRecords)){
				angular.forEach(this.typeaheadCollectionConfigs, function(config){
					config.setAllRecords(this.allRecords);
				}); 
			} else {
				angular.forEach(this.typeaheadCollectionConfigs, function(config){
					config.setAllRecords(true);
				}); 
			}
		}
		
		public search = (search:string)=>{
			
			if(this.hideSearch){
				this.hideSearch = false; 
			} else if(this.search.length == 0){
				this.hideSearch = true; 
			}
			
			this.results = new Array(); 
			
			angular.forEach(this.typeaheadCollectionConfigs, function(config){
				
				config.setKeywords(search);
				var promise = config.getEntity();
				
				promise.then((response)=>{
					if(angular.isDefined(this.allRecords) && this.allRecords == false){
						this.results.concat(response.pageRecords);
					} else {
						this.results.concat(response.records);
					}	 
	
					//Custom method for gravatar on accounts (non-persistant-property)
					if(angular.isDefined(this.results) && this.entity == "Account"){
						angular.forEach(this.results,(account)=>{
								account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
						});
					}
				});
			});
		}
		
		public addItem = (item)=>{
			this.addFunction({item: item}); 
		}
		
		public addButtonItem = ()=>{
			this.addButtonFunction({searchString: this.searchText});
		}
		
	}
    
    export class SWTypeaheadSearch implements ng.IDirective{
        
		public static $inject=["$slatwall", "collectionConfigService"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			entities:"@",
			properties:"@",
			propertiesToDisplay:"@",
			placeholderText:"@?",
			searchText:"=?",
			results:"=?",
			addFunction:"&?",
			addButtonFunction:"&?", 
			hideSearch:"="
		}
		public controller=SWTypeaheadSearchController;
        public controllerAs="swTypeaheadSearch";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private collectionConfigService:slatwalladmin.collectionConfigService, private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath + "typeaheadsearch.html";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{

		}
    }
    
    angular.module('slatwalladmin').directive('swTypeaheadSearch',
		["$slatwall", "collectionConfigService", "partialsPath", 
			($slatwall, collectionConfigService, partialsPath) => 
				new SWTypeaheadSearch($slatwall, collectionConfigService, partialsPath)]); 

}