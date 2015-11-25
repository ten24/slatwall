/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';
	
	export class SWTypeaheadSearchController {
		
		public static $inject=["$slatwall", "$timeout", "collectionConfigService"];
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
		public modelBind; 
		public clickOutsideArgs; 
		
		private _timeoutPromise; 
		private displayList;
		private entityList;  
		private typeaheadCollectionConfig; 
		private typeaheadCollectionConfigs; 
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, private collectionConfigService:slatwalladmin.CollectionConfig){
			
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
			
			if(angular.isDefined(this.modelBind)){
				this.modelBind = search;
			}
			
			if(search.length > 2){			
				
				if(this._timeoutPromise){
					this.$timeout.cancel(this._timeoutPromise); 
				}
				
				this._timeoutPromise = this.$timeout(()=>{
					
					if(this.hideSearch){
						this.hideSearch = false; 
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
						
					promise.then( (response) =>{
					
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
				}, 500); 
			} else { 
				this.results = [];
				this.hideSearch = true; 
			}
		}
		
		public addItem = (item)=>{
			
			if(!this.hideSearch){
				this.hideSearch = true; 
			}
			
			if(angular.isDefined(this.displayList)){
				this.searchText = item[this.displayList[0]]; 
			}
			
			if(angular.isDefined(this.addFunction)){
				this.addFunction({item: item}); 
			}
		}
		
		public addButtonItem = ()=>{
			
			if(!this.hideSearch){
				this.hideSearch = true; 
			}
			
			if(angular.isDefined(this.modelBind)){
				this.searchText = this.modelBind; 
			} else { 
				this.searchText = "";
			}
			
			if(angular.isDefined(this.addButtonFunction)){
				this.addButtonFunction({searchString: this.searchText});
			}
		}
		
		public closeThis = (clickOutsideArgs) =>{

			this.hideSearch = true; 
						
			if(angular.isDefined(clickOutsideArgs)){ 
				for(var callBackAction in clickOutsideArgs.callBackActions){
					clickOutsideArgs.callBackActions[callBackAction]();
				}
			}

		};
		
	}
    
    export class SWTypeaheadSearch implements ng.IDirective{
        
		public static $inject=["$slatwall", "$timeout", "collectionConfigService", "partialsPath"];
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
			hideSearch:"=", 
			modelBind:"=?",
			clickOutsideArgs:"@"
		}
		public controller=SWTypeaheadSearchController;
        public controllerAs="swTypeaheadSearch";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, private collectionConfigService:slatwalladmin.CollectionConfig, private partialsPath:slatwalladmin.partialsPath){
			this.templateUrl = partialsPath + "typeaheadsearch.html";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
    }
    
    angular.module('slatwalladmin').directive('swTypeaheadSearch',
		["$slatwall", "$timeout", "collectionConfigService", "partialsPath", 
			($slatwall, $timeout, collectionConfigService, partialsPath) => 
				new SWTypeaheadSearch($slatwall, $timeout, collectionConfigService, partialsPath)]); 

}