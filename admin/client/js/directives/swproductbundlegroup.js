'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroup', [
	'$http',
	'$log',
	'$timeout',
	'$slatwall',
	'productBundlePartialsPath',
	'productBundleService',
	function(
	$http,
		$log,
		$timeout,
		$slatwall,
		productBundlePartialsPath,
		productBundleService
	){
		return {
			require:"^swProductBundleGroups",
			restrict: 'E',
			templateUrl:productBundlePartialsPath+"productbundlegroup.html",
			scope:{
				productBundleGroup:"=",
				index:"=",
				addProductBundleGroup:"&",
				formName:"@"
			},
			link: function(scope, element,attrs,productBundleGroupsController){
				var timeoutPromise;
				
				scope.$id = 'productBundleGroup';
				$log.debug('productBundleGroup');
				$log.debug(scope.productBundleGroup);
				
				scope.removeProductBundleGroup = function(){
					productBundleGroupsController.removeProductBundleGroup(scope.index);
				};
				
				scope.navigation = {
					value:'Basic',
					setValue:function(value){
						this.value = value;
					}
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
				        	name:"Collections",
				        	value:"collection"
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
					}
				};
				
				scope.filterTemplatePath = productBundlePartialsPath+"productbundlefilter.html";
				scope.productBundleGroupFilters = {};
				scope.productBundleGroupFilters.value = [];
				if(angular.isUndefined(scope.productBundleGroup.productBundleGroupFilters)){
					scope.productBundleGroup.productBundleGroupFilters = [];
				}
				
				scope.productBundleGroupFilters.getFiltersByTerm = function(keyword,filterTerm){
					scope.loading = true;
					var _loadingCount;
					if(timeoutPromise) {
						$timeout.cancel(timeoutPromise);
					}
					
					timeoutPromise = $timeout(function(){
						if(filterTerm.value === 'All'){
							scope.productBundleGroupFilters.value = [];
							_loadingCount = scope.searchOptions.options.length - 1;
							for(var i in scope.searchOptions.options){
								if(i > 0){
									var option = scope.searchOptions.options[i];
									(function(keyword,option) {
										$slatwall.getEntity(scope.searchOptions.options[i].value, {keywords:keyword,deferKey:'getProductBundleGroupFilterByTerm'+option.value}).then(function(value){
											var formattedProductBundleGroupFilters = productBundleService.formatProductBundleGroupFilters(value.pageRecords,option);
											
											for(var j in formattedProductBundleGroupFilters){
												scope.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
											}
											
											// Increment Down The Loading Count
											_loadingCount--;
											
											// If the loadingCount drops to 0, then we can update scope
											if(_loadingCount == 0){
												scope.loading = false;	
											}
										});
									})(keyword,option);
								} 
							}
						}else{
							
							$slatwall.getEntity(filterTerm.value, {keywords:keyword,deferKey:'getProductBundleGroupFilterByTerm'+filterTerm.value})
							.then(function(value){
								$log.debug('getFiltersByTerm');
								$log.debug(value);
								scope.productBundleGroupFilters.value = productBundleService.formatProductBundleGroupFilters(value.pageRecords,filterTerm) || [];
								scope.loading = false;
								$log.debug('productBundleGroupFilters');
								$log.debug(scope.productBundleGroupFilters);
								
							});
						}
					}, 500);
				};
				
				scope.addFilterToProductBundle = function(filterItem,include){
					$log.debug('addFilterToProductBundle');
					$log.debug(filterItem);
					if(include === false){
						filterItem.comparisonOperator = '!=';
					}else{
						filterItem.comparisonOperator = '=';
					}
					scope.productBundleGroup.data.skuCollectionConfig.filterGroups.push(filterItem);
				};
				
				scope.removeProductBundleGroupFilter = function(index){
					scope.productBundleGroup.data.skuCollectionConfig.filterGroups.splice(index,1);
				};
				
				
			}
		};
	}
]);
	
