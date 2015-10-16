'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroup', [
	'$http',
	'$log',
	'$timeout',
	'$slatwall',
	'productBundlePartialsPath',
	'productBundleService',
	'collectionService',
	'metadataService',
	'utilityService',
	function(
		$http,
		$log,
		$timeout,
		$slatwall,
		productBundlePartialsPath,
		productBundleService,
		collectionService,
		metadataService,
		utilityService
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
				scope.maxRecords = 10;
                scope.recordsCount = 0;  
                scope.pageRecordsStart = 0;
                scope.pageRecordsEnd = 0;
                scope.showAll = false;
                scope.showAdvanced = false;
                scope.currentPage = 1;
                scope.pageShow = 10;
                /**
                 * Opens or closes the advanced dialog.
                 */
                scope.openCloseAndRefresh = function(){    
                   scope.showAdvanced = !scope.showAdvanced;
                   $log.debug("OpenAndCloseAndRefresh");
                   $log.debug(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup);
                   $log.debug("Length:" + scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length);
                   if(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length){
                       scope.getCollection();
                   }
                   
                }
				scope.removeProductBundleGroup = function(){
					productBundleGroupsController.removeProductBundleGroup(scope.index);
					scope.productBundleGroup.$$delete();
				};
				
				scope.deleteEntity = function(type){
					if (angular.isNumber(type)){
						$log.debug("Deleting filter");
						this.removeProductBundleGroupFilter(type);
					}else{
						$log.debug("Removing bundle group");
						this.removeProductBundleGroup();
						
					}
				};
				
				scope.collection = { 
					baseEntityName:"Sku",
					baseEntityAlias:"_sku",
					collectionConfig:scope.productBundleGroup.data.skuCollectionConfig,
					collectionObject:'Sku'
				};
                
				/**
				 * Adds a collection to scope
				 */
				scope.getCollection = function(){
                
					var options = {
							filterGroupsConfig:angular.toJson(scope.productBundleGroup.data.skuCollectionConfig.filterGroups),
							columnsConfig:angular.toJson(scope.productBundleGroup.data.skuCollectionConfig.columns),
							currentPage:1, 
							pageShow:10
						};
					var collectionPromise = $slatwall.getEntity('Sku',options);
					collectionPromise.then(function(response){
						scope.collection = response;
                        $log.debug("Collection Response");
                        $log.debug(scope.collection);
					});
				};
				
				scope.getCollection();
				
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
				};
				
				scope.filterTemplatePath = productBundlePartialsPath+"productbundlefilter.html";
				scope.productBundleGroupFilters = {};
				scope.productBundleGroupFilters.value = [];
				if(angular.isUndefined(scope.productBundleGroup.productBundleGroupFilters)){
					scope.productBundleGroup.productBundleGroupFilters = [];
				}
				
				//Checks if a value has a match in an array
				function arrayContains(array, item){
					var iterator = array.length;
				    while (iterator--) {
				       if (array[iterator].name === item.name){
				           return true;
				       }
				    }
				    return false;
				}
				 /** Increases the current page count by one */
                scope.increaseCurrentCount = function(){
                      scope.currentPage++;
                };
                /** resets the current page to zero when the searchbox is changed */
                scope.resetCurrentCount = function(){
                      scope.currentPage = 1;
                };
                
				scope.productBundleGroupFilters.getFiltersByTerm = function(keyword,filterTerm){
					scope.loading = true;
                    scope.showAll = true;
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
                                        
										$slatwall.getEntity(scope.searchOptions.options[i].value, {keywords:keyword,deferKey:'getProductBundleGroupFilterByTerm'+option.value, currentPage:scope.currentPage, pageShow:scope.pageShow})
                                            .then(function(value){
                                            $log.debug(value);    
                                            $log.debug("Total: " + value.recordsCount);
                                            $log.debug("Records Start: " + value.pageRecordsStart);
                                            $log.debug("Records End: " + value.pageRecordsEnd);
                                            
											 var formattedProductBundleGroupFilters = productBundleService.formatProductBundleGroupFilters(value.pageRecords,option);
											     for(var j in formattedProductBundleGroupFilters){
												    if(!arrayContains(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup, formattedProductBundleGroupFilters[j])){
													   //Only get the correct amount for each iteration
                                                        
                                                        $log.debug(scope.productBundleGroupFilters.value.length);
                                                        scope.productBundleGroupFilters.value.push(formattedProductBundleGroupFilters[j]);
												       
                                                    
                                                    }   
											     }
											
											// Increment Down The Loading Count
											_loadingCount--;
											// If the loadingCount drops to 0, then we can update scope
											if(_loadingCount == 0){
												//This sorts the array of objects by the objects' "type" property alphabetically
												scope.productBundleGroupFilters.value = utilityService.arraySorter(scope.productBundleGroupFilters.value, ["type","name"]);
												$log.debug(scope.productBundleGroupFilters.value);
												
											}
                                            scope.loading = false;
										});
									})(keyword,option);
								} 
							}
						}else{
                            
                             scope.showAll = false; //We want to display a count when using specific filter type so, set to false.
							$slatwall.getEntity(filterTerm.value, { keywords: keyword, deferKey:'getProductBundleGroupFilterByTerm' + filterTerm.value, currentPage:scope.currentPage, pageShow:scope.pageShow})
							.then(function(value){
                                
                                scope.recordsCount = value.recordsCount;
                                scope.pageRecordsStart = value.pageRecordsStart;
                                scope.pageRecordsEnd = value.pageRecordsEnd;
								$log.debug('getFiltersByTerm');
								$log.debug(value);
								scope.productBundleGroupFilters.value = productBundleService.formatProductBundleGroupFilters(value.pageRecords,filterTerm) || [];
								scope.loading = false;
								$log.debug('productBundleGroupFilters');
								$log.debug(scope.productBundleGroupFilters);
								scope.loading = false;
							});
						}
					}, 500);
				};
 
				scope.addFilterToProductBundle = function(filterItem,include,index){
					$log.debug('addFilterToProductBundle');
					$log.debug(filterItem);
					var collectionFilterItem = {};
                    collectionFilterItem.name = filterItem.name;
                    collectionFilterItem.type = filterItem.type;
					collectionFilterItem.displayPropertyIdentifier = filterItem.type; 
					collectionFilterItem.propertyIdentifier = filterItem.propertyIdentifier; 
					collectionFilterItem.displayValue = filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1)+'ID']; 
					collectionFilterItem.value = filterItem[filterItem.entityType.charAt(0).toLowerCase() + filterItem.entityType.slice(1)+'ID']; 
					
					if(include === false){
						collectionFilterItem.comparisonOperator = '!=';
					}else{
						collectionFilterItem.comparisonOperator = '=';
					}
					
					if(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.length > 0){
						collectionFilterItem.logicalOperator = 'OR';
					}
					//Adds filter item to designated filtergroup
					scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.push(collectionFilterItem);
					//Removes the filter item from the left hand search result
					scope.productBundleGroupFilters.value.splice(index,1);
                    scope.productBundleGroup.forms[scope.formName].skuCollectionConfig.$setDirty();
				};
				
				if(angular.isUndefined(scope.filterPropertiesList)){
					scope.filterPropertiesList = {};
					var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName('_sku');
					filterPropertiesPromise.then(function(value){
						metadataService.setPropertiesList(value,'_sku');
						scope.filterPropertiesList['_sku'] = metadataService.getPropertiesListByBaseEntityAlias('_sku');
						metadataService.formatPropertiesList(scope.filterPropertiesList['_sku'],'_sku');
					});
				}
				
				scope.removeProductBundleGroupFilter = function(index){
					//Pushes item back into array
					scope.productBundleGroupFilters.value.push(scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup[index]);
					//Sorts Array
					scope.productBundleGroupFilters.value = utilityService.arraySorter(scope.productBundleGroupFilters.value, ["type","name"]);
					//Removes the filter item from the filtergroup
					scope.productBundleGroup.data.skuCollectionConfig.filterGroups[0].filterGroup.splice(index,1);
                    scope.productBundleGroup.forms[scope.formName].skuCollectionConfig.$setDirty();
				};
				
				
			}
		};
	}
]);
	
