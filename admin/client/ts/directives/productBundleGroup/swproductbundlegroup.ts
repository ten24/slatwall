/// <reference path="../../../../../client/typings/tsd.d.ts" />
/// <reference path="../../../../../client/typings/slatwallTypeScript.d.ts" />
module slatwalladmin {
	'use strict';

	export class CollectionFilterItem{
		constructor(
			public name:string,
			public type:string,
			public displayPropertyIdentifier:string,
			public propertyIdentifier:string, 
			public displayValue:string,
			public value:string,
			public comparisonOperator?:string, 
			public logicalOperator?:string){
			
		}
	}
	
	export class SWProductBundleGroupController {
		
		public static $inject=["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath"];
		public $id;
		public showAdvanced; 
		public productBundleGroup; 
		public productBundleGroups;
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
		public keyword; 
		public filterTerm; 
		public loading; 
		public searchOptions; 
		public value;
		public collection; 
		public collectionConfig; 
		public selected; 
		public searchCollectionConfig; 
		public searchAllCollectionConfigs;
		public formName;
		public filterPropertiesList;
		public totalPages;
		public skuCollectionConfig;
		public removeProductBundleGroup; 
		

		constructor(private $log:ng.ILogService, private $timeout:ng.ITimeoutService, 
					private collectionConfigService:slatwalladmin.CollectionConfig, 
					private productBundleService,  private metadataservice, private utilityservice, 
					private $slatwall, private partialsPath){
						
			this.$id = 'productBundleGroup';
			this.maxRecords = 10;
			this.recordsCount = 0;  
			this.pageRecordsStart = 0;
			this.pageRecordsEnd = 0;
			this.showAll = false;
			this.showAdvanced = false;
			this.currentPage = 1;
			this.pageShow = 10;
			this.searchAllCollectionConfigs = [];
			
			/*this.skuCollectionConfig = { 
				baseEntityName:"Sku",
				baseEntityAlias:"_sku",
				collectionConfig:this.productBundleGroup.data.skuCollectionConfig,
				collectionObject:'Sku'
			};*/
			
			this.searchOptions = {
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
				setSelected:(searchOption)=>{
					this.searchOptions.selected = searchOption;
					this.getFiltersByTerm(this.productBundleGroupFilters.keyword,searchOption);
				}
			};
					
			this.navigation = {
				value:'Basic',
				setValue:(value)=>{
					this.value = value;
				}
			};
			
			this.filterTemplatePath = this.partialsPath +"productBundle/productbundlefilter.html";
			this.productBundleGroupFilters = {};
			this.productBundleGroupFilters.value = [];
			
			if(angular.isUndefined(this.productBundleGroup.productBundleGroupFilters)){
				this.productBundleGroup.productBundleGroupFilters = [];
			}
			
			if(!angular.isDefined(this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index])){
				this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index] = {};
				this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup = [];
			}
			
			var options = {
					filterGroupsConfig:this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup,
					columnsConfig:this.productBundleGroup.data.skuCollectionConfig.columns,
			};
			
			this.collectionConfig = collectionConfigService.newCollectionConfig('Sku');
			this.collectionConfig.loadFilterGroups(options.filterGroupsConfig);
			this.collectionConfig.loadColumns(options.columnsConfig);  
			this.collectionConfig.setAllRecords(true);
			
			this.getCollection();
		}	
		
		public openCloseAndRefresh = () => {    
			this.showAdvanced = !this.showAdvanced;
			if(this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.length){
				this.getCollection();
			}
			
		}
				
		public deleteEntity = (type?) =>{
			if (angular.isNumber(type)){
				this.removeProductBundleGroupFilter(type);
			}else{
				this.removeProductBundleGroup()(this.index);				
			}
		};			

		public getCollection = () =>{
			this.collectionConfig.getEntity().then((response)=>{
				this.collection = response;
			});
		}
				
		public increaseCurrentCount = () =>{
				if(angular.isDefined(this.totalPages) && this.totalPages != this.currentPage){
						this.currentPage++;
				} else { 
					this.currentPage = 1;
				}	
		};

		public resetCurrentCount = () =>{
				this.currentPage = 1;
		};
		
	    public getFiltersByTerm = (keyword,filterTerm) =>{
			//save search 
			this.keyword = keyword; 
			this.filterTerm = filterTerm; 
			this.loading = true;
			this.showAll = true;
			var _loadingCount;
			if(this.timeoutPromise) {
				this.$timeout.cancel(this.timeoutPromise);
			}
			
			this.timeoutPromise = this.$timeout(()=>{
				if(filterTerm.value === 'All'){
					this.showAll = true; 
					this.productBundleGroupFilters.value = [];
					_loadingCount = this.searchOptions.options.length - 1;
					for(var i in this.searchOptions.options){
						this.$log.debug("INT");
						this.$log.debug(i);
						if(i > 0){
							var option = this.searchOptions.options[i];
							((keyword,option) =>{
								if(this.searchAllCollectionConfigs.length < 4){
									this.searchAllCollectionConfigs.push(this.collectionConfigService.newCollectionConfig(this.searchOptions.options[i].value)); 
								}
								
								this.searchAllCollectionConfigs[i-1].setKeywords(keyword); 
								this.searchAllCollectionConfigs[i-1].setCurrentPage(this.currentPage); 
								this.searchAllCollectionConfigs[i-1].setPageShow(this.pageShow); 
								//searchAllCollectionConfig.setAllRecords(true);
								
								
								this.searchAllCollectionConfigs[i-1].getEntity().then((value)=>{
									
									this.recordsCount = value.recordsCount;
									this.pageRecordsStart = value.pageRecordsStart;
									this.pageRecordsEnd = value.pageRecordsEnd;
									this.totalPages = value.totalPages;
									
									var formattedProductBundleGroupFilters = this.productBundleService.formatProductBundleGroupFilters(value.pageRecords,option,this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup);
									
									for(var j in formattedProductBundleGroupFilters){
										if(this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.indexOf(formattedProductBundleGroupFilters[j]) == -1){
											this.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
											this.$log.debug(formattedProductBundleGroupFilters[j]);
										}   
									}
									
									// Increment Down The Loading Count
									_loadingCount--;
									// If the loadingCount drops to 0, then we can update scope
									if(_loadingCount == 0){
										//This sorts the array of objects by the objects' "type" property alphabetically
										this.productBundleGroupFilters.value = this.utilityservice.arraySorter(this.productBundleGroupFilters.value, ["type","name"]);
										this.$log.debug(this.productBundleGroupFilters.value);
										if(this.productBundleGroupFilters.value.length == 0){
											this.currentPage = 0;
										}
										
									}
									this.loading = false;
								});
							})(keyword, option);
						} 
					}
				}else{
					this.showAll = false; 
					
					if(angular.isUndefined(this.searchCollectionConfig) || filterTerm.value != this.searchCollectionConfig.baseEntityName){
						this.searchCollectionConfig = this.collectionConfigService.newCollectionConfig(filterTerm.value); 
					}		
					this.searchCollectionConfig.setKeywords(keyword); 
					this.searchCollectionConfig.setCurrentPage(this.currentPage); 
					this.searchCollectionConfig.setPageShow(this.pageShow); 
						
					this.searchCollectionConfig.getEntity().then((value)=>{
						
						this.recordsCount = value.recordsCount;			
						this.pageRecordsStart = value.pageRecordsStart;
						this.pageRecordsEnd = value.pageRecordsEnd;
						this.totalPages = value.totalPages;
						this.$log.debug('getFiltersByTerm');
						this.$log.debug(value);
						this.productBundleGroupFilters.value = this.productBundleService.formatProductBundleGroupFilters(value.pageRecords,filterTerm,this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup) || [];
						this.loading = false;
					});
				}
			}, 500);			
		}	
		
		
		public addFilterToProductBundle = (filterItem,include,index) =>{

			var collectionFilterItem = new CollectionFilterItem(
					filterItem.name, filterItem.type, 
					filterItem.type, filterItem.propertyIdentifier,  
					filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1)+'ID'], 
					filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1)+'ID']
				);
			if(include === false){
				collectionFilterItem.comparisonOperator = '!=';
			}else{
				collectionFilterItem.comparisonOperator = '=';
			}
			
			if(this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.length > 0){
				collectionFilterItem.logicalOperator = 'OR';
			}
			
			if(angular.isDefined(this.searchCollectionConfig)){
				this.searchCollectionConfig.addFilter(this.searchCollectionConfig.baseEntityName+"ID", collectionFilterItem.value, "!=");
			} 
			if(this.showAll){
				switch(collectionFilterItem.type){
					case 'Product Type':
						this.searchAllCollectionConfigs[0].addFilter("productTypeID", collectionFilterItem.value, "!=");
						break;
					case 'Brand':
						this.searchAllCollectionConfigs[1].addFilter("brandID", collectionFilterItem.value, "!=");
						break;
					case 'Products':
						this.searchAllCollectionConfigs[2].addFilter("productID", collectionFilterItem.value, "!=");
						break;
					case 'Skus':
						this.searchAllCollectionConfigs[3].addFilter("skuID", collectionFilterItem.value, "!=");
						break;
				}
			}
			
			//Adds filter item to designated filtergroup
			this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.push(collectionFilterItem);
			
			//Removes the filter item from the left hand search result
			//this.productBundleGroupFilters.value.splice(index,1);
			this.productBundleGroup.forms[this.formName].skuCollectionConfig.$setDirty();
			
			this.getFiltersByTerm(this.keyword, this.filterTerm);
		}
				
		public removeProductBundleGroupFilter = (index) =>{
			//Pushes item back into array
			this.productBundleGroupFilters.value.push(this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup[index]);
			//Sorts Array
			this.productBundleGroupFilters.value = this.utilityservice.arraySorter(this.productBundleGroupFilters.value, ["type","name"]);
			//Removes the filter item from the filtergroup
			var collectionFilterItem = this.productBundleGroup.data.skuCollectionConfig.filterGroups[this.index].filterGroup.splice(index,1)[0];
			
			if(angular.isDefined(this.searchCollectionConfig)){
				this.searchCollectionConfig.removeFilter(this.searchCollectionConfig.baseEntityAlias + '.' + this.searchCollectionConfig.baseEntityName+"ID", collectionFilterItem.value, "!=");
			} 
			if(this.showAll){
				switch(collectionFilterItem.type){
					case 'Product Type':
						this.searchAllCollectionConfigs[0].removeFilter("_productType.productTypeID", collectionFilterItem.value, "!=");
						break;
					case 'Brand':
						this.searchAllCollectionConfigs[1].removeFilter("_brand.brandID", collectionFilterItem.value, "!=");
						break;
					case 'Products':
						this.searchAllCollectionConfigs[2].removeFilter("_product.productID", collectionFilterItem.value, "!=");
						break;
					case 'Skus':
						this.searchAllCollectionConfigs[3].removeFilter("_sku.skuID", collectionFilterItem.value, "!=");
						break;
				}
			}
			
			this.productBundleGroup.forms[this.formName].skuCollectionConfig.$setDirty();
			
			this.getFiltersByTerm(this.keyword, this.filterTerm);
		};		
	}
	
	export class SWProductBundleGroup implements ng.IDirective{
        
		public static $inject=["$http", "$slatwall", "$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath"];
		public templateUrl; 
		public restrict = "EA"; 
		public scope = {}	
		
		public bindToController = {
			productBundleGroups:"=",
			productBundleGroup:"=",
			index:"=",
			addProductBundleGroup:"&",
			removeProductBundleGroup:"&",
			formName:"@"
		}
		public controller=SWProductBundleGroupController;
        public controllerAs="swProductBundleGroup";
		
		
		constructor(private $log:ng.ILogService, private $timeout:ng.ITimeoutService, 
					private collectionConfigService:slatwalladmin.CollectionConfig, 
					private productBundleService,  private metadataservice, private utilityservice,
					private $slatwall, private partialsPath){
			this.templateUrl = partialsPath + "productbundle/productbundlegroup.html";	
		}

        public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
			
		}
    }
	
	angular.module('slatwalladmin')
	.directive('swProductBundleGroup',
		["$log", "$timeout", "collectionConfigService", "productBundleService", "metadataService", "utilityService", "$slatwall", "partialsPath", 
			($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, $slatwall, partialsPath) => 
				new SWProductBundleGroup($log, $timeout, collectionConfigService, productBundleService, metadataService, utilityService, $slatwall, partialsPath)
			]);
}