/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';
	
	export class SWProductBundleGroupController {
		
		public static $inject=["$http", "$slatwall", "$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "partialsPath"];
		public $id;
		public showAdvanced; 
		public productBundleGroup; 
		public maxRecords;
		public recordsCount;
		public pageRecordsStart; 
		public pageRecordsEnd; 
		public showAll; 
		public currentPage;
		public pageShow; 
		public timeoutPromise;	
		public navigation; 
		public filterTemplatePath;  
		public productBundleGroupFilters; 
		public index; 
		public loading; 
		public searchOptions; 
		public value;
		public collection; 
		public collectionConfig; 
		
		/*
				
		scope.collection = { 
			baseEntityName:"Sku",
			baseEntityAlias:"_sku",
			collectionConfig:scope.productBundleGroup.data.skuCollectionConfig,
			collectionObject:'Sku'
		};
		
		
		scope.searchOptions = {
			options:[
					{
						name:"All",
						value:"All"
					},
					{
					name:"Product Type",
					value:"productType"
					},
					{
					name:"Brand",
					value:"brand"
					},
					{
					name:"Products",
					value:"product"
					},
					{
					name:"Skus",
					value:"sku"
					}
			],
			selected:{
				name:"All",
				value:"All"
			},
			setSelected:function(searchOption){
				this.selected = searchOption;
				scope.productBundleGroupFilters.getFiltersByTerm(scope.productBundleGroupFilters.keyword,searchOption);
			}
		};*/
		
		constructor(protected $log:ng.ILogService, protected $timeout:ng.ITimeoutService, protected $slatwall, protected collectionConfigService, protected partialsPath){
			this.init(); 
		}
		
		public init = () =>{
			this.$id = 'productBundleGroup';
			this.maxRecords = 10;
			this.recordsCount = 0;  
			this.pageRecordsStart = 0;
			this.pageRecordsEnd = 0;
			this.showAll = false;
			this.showAdvanced = false;
			this.currentPage = 1;
			this.pageShow = 10;
			
			this.getCollection();
				
			this.navigation = {
				value:'Basic',
				setValue:(value)=>{
					this.value = value;
				}
			};
			
			this.filterTemplatePath = this.partialsPath +"productBund/productbundlefilter.html";
			this.productBundleGroupFilters = {};
			this.productBundleGroupFilters.value = [];
			
			if(angular.isUndefined(this.productBundleGroup.productBundleGroupFilters)){
				this.productBundleGroup.productBundleGroupFilters = [];
			}
			
			var options = {
					filterGroupsConfig:angular.toJson(this.productBundleGroup.data.skuCollectionConfig.filterGroups),
					columnsConfig:angular.toJson(this.productBundleGroup.data.skuCollectionConfig.columns),
					currentPage:1, 
					pageShow:10
			};
			
			this.collectionConfig = this.collectionConfigService.newCollectionConfig('Sku');
			this.collectionConfig.setOptions(options); 
		}
		
		public openCloseAndRefresh = () => {    
			this.showAdvanced = !this.showAdvanced;
			this.$log.debug("OpenAndCloseAndRefresh");
			this.$log.debug(this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup);
			this.$log.debug("Length:" + this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length);
			if(this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length){
				this.getCollection();
			}
			
		}
				
				
		public removeProductBundleGroup = () =>{
			//productBundleGroupsController.removeProductBundleGroup(this.index);
			this.productBundleGroup.$$delete();
		}
				
		public deleteEntity = (type) =>{
			if (angular.isNumber(type)){
				this.$log.debug("Deleting filter");
				//this.removeProductBundleGroupFilter(type);
			}else{
				this.$log.debug("Removing bundle group");
				this.removeProductBundleGroup();
				
			}
		};
				
				

		 public getCollection = () =>{
			this.collectionConfig.getEntity().then((response)=>{
				this.collection = response;
				this.$log.debug("Collection Response");
				this.$log.debug(this.collection);
			});
		}
				
		public increaseCurrentCount = () =>{
				this.currentPage++;
		};

		public resetCurrentCount = () =>{
				this.currentPage = 1;
		};
		
	    public getFiltersByTerm = (keyword,filterTerm) =>{
			this.loading = true;
			this.showAll = true;
			var _loadingCount;
			if(this.timeoutPromise) {
				this.$timeout.cancel(this.timeoutPromise);
			}
			
			this.timeoutPromise = this.$timeout(()=>{
				if(filterTerm.value === 'All'){
					this.productBundleGroupFilters.value = [];
					_loadingCount = this.searchOptions.options.length - 1;
					for(var i in this.searchOptions.options){
						if(i > 0){
							var option = this.searchOptions.options[i];
							((keyword,option)=>{
								
								this.$slatwall.getEntity(this.searchOptions.options[i].value, {keywords:keyword,deferKey:'getProductBundleGroupFilterByTerm'+option.value, currentPage:this.currentPage, pageShow:this.pageShow})
									.then((value)=>{
									this.$log.debug(value);    
									this.$log.debug("Total: " + value.recordsCount);
									this.$log.debug("Records Start: " + value.pageRecordsStart);
									this.$log.debug("Records End: " + value.pageRecordsEnd);
									
										var formattedProductBundleGroupFilters = this.productBundleService.formatProductBundleGroupFilters(value.pageRecords,option);
											for(var j in formattedProductBundleGroupFilters){
												if(this.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.indexOf(formattedProductBundleGroupFilters[j]) == -1){
													//Only get the correct amount for each iteration
													this.$log.debug(this.productBundleGroupFilters.value.length);
													this.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
												}   
											}
									
									// Increment Down The Loading Count
									_loadingCount--;
									// If the loadingCount drops to 0, then we can update scope
									if(_loadingCount == 0){
										//This sorts the array of objects by the objects' "type" property alphabetically
										this.productBundleGroupFilters.value = this.utilityService.arraySorter(this.productBundleGroupFilters.value, ["type","name"]);
										this.$log.debug(this.productBundleGroupFilters.value);
										
									}
									this.loading = false;
								});
							})(keyword,option);
						} 
					}
				}else{
					
						this.showAll = false; //We want to display a count when using specific filter type so, set to false.
					this.$slatwall.getEntity(filterTerm.value, { keywords: keyword, deferKey:'getProductBundleGroupFilterByTerm' + filterTerm.value, currentPage:this.currentPage, pageShow:this.pageShow})
					.then((value)=>{
						
						this.recordsCount = value.recordsCount;
						this.pageRecordsStart = value.pageRecordsStart;
						this.pageRecordsEnd = value.pageRecordsEnd;
						this.$log.debug('getFiltersByTerm');
						this.$log.debug(value);
						this.productBundleGroupFilters.value = this.productBundleService.formatProductBundleGroupFilters(value.pageRecords,filterTerm) || [];
						this.loading = false;
						this.$log.debug('productBundleGroupFilters');
						this.$log.debug(this.productBundleGroupFilters);
						this.loading = false;
					});
				}
			}, 500);			
		}			
	}
	
	export class SWProductBundleGroup implements ng.IDirective{
        
		public static $inject=["$http", "$slatwall", "$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "partialsPath"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			productBundleGroup:"=",
			index:"=",
			addProductBundleGroup:"&",
			formName:"@"
		}
		public controller=SWProductBundleGroupController;
        public controllerAs="swProductBundleGroup";
		
		
		constructor(private $slatwall:ngSlatwall.$Slatwall, private $timeout:ng.ITimeoutService, private $log:ng.ILogService, private collectionConfigService:slatwalladmin.CollectionConfig, private productBundleService:slatwalladmin.ProductBundleService, private partialsPath){
			this.templateUrl = partialsPath + "productbundle/productbundlegroup.html";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
    }
	
	angular.module('slatwalladmin')
	.directive('swProductBundleGroup',
		["$timeout", "$log", "collectionConfigService", "productBundleService", "$slatwall", "partialsPath", 
			($timeout, $log, collectionConfigService, productBundleService, $slatwall, partialsPath) => 
				new SWProductBundleGroup($slatwall, $log, $timeout, collectionConfigService, productBundleService, partialsPath)
			]);
}
