module slatwalladmin {
	'use strict';
	
	export class SWTypeaheadSearchController {
		
		public static $inject=["$slatwall", "collectionConfigService"];
		public entity:string;
		public properties:string;
		public propertiesToDisplay:string; 
		public filterGroupsConfig:any; 
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
			
			this.typeaheadCollectionConfig = collectionConfigService.newCollectionConfig(this.entity); 
			this.typeaheadCollectionConfig.setDisplayProperties(this.properties);
			
			if(angular.isDefined(this.propertiesToDisplay)){
				this.displayList = this.propertiesToDisplay.split(",");
			}
			
			if(angular.isDefined(this.allRecords)){			
				this.typeaheadCollectionConfig.setAllRecords(this.allRecords);				
			} else {
				this.typeaheadCollectionConfig.setAllRecords(true);		
			}
		}
		
		public search = (search:string)=>{
			
			if(this.hideSearch){
				this.hideSearch = false; 
			} else if(this.search.length == 0){
				this.hideSearch = true; 
			}
			
			this.results = new Array(); 
			this.typeaheadCollectionConfig.setKeywords(search);

			if(angular.isDefined(this.filterGroupsConfig)){		
				//allows for filtering on search text
				var filterConfig = this.filterGroupsConfig.replace("replaceWithSearchString", search); 
				filterConfig = filterConfig.trim();
				this.typeaheadCollectionConfig.loadFilterGroups(JSON.parse(filterConfig)); 
			}
			
			var promise = this.typeaheadCollectionConfig.getEntity();
				
			promise.then((response)=>{
				
				if(angular.isDefined(this.allRecords) && this.allRecords == false){
					this.results = response.pageRecords;
				} else {
					this.results = response.records;
				}	 

				//Custom method for gravatar on accounts (non-persistant-property)
				if(angular.isDefined(this.results) && this.entity == "Account"){
					angular.forEach(this.results,(account)=>{
						account.gravatar = "http://www.gravatar.com/avatar/" + md5(account.primaryEmailAddress_emailAddress.toLowerCase().trim());
					});
				}
			});
		}
		
		public addItem = (item)=>{
			if(angular.isDefined(this.addFunction)){
				this.addFunction({item: item}); 
			}
		}
		
		public addButtonItem = ()=>{
			if(angular.isDefined(this.addButtonFunction)){
				this.addButtonFunction({searchString: this.searchText});
			}
		}
		
	}
    
    export class SWTypeaheadSearch implements ng.IDirective{
        
		public static $inject=["$slatwall", "collectionConfigService"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			entity:"@",
			properties:"@",
			propertiesToDisplay:"@?",
			filterGroupsConfig:"@?", 
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