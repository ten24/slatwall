'use strict';
angular.module('slatwalladmin')
.directive('swProductBundleGroup', 
['$http',
 '$log',
 '$slatwall',
'productBundlePartialsPath',
'productBundleService',
function($http,
$log,
$slatwall,
productBundlePartialsPath,
productBundleService){
	return {
		require:"^swProductBundleGroups",
		restrict: 'A',
		templateUrl:productBundlePartialsPath+"productbundlegroup.html",
		scope:{
			productBundleGroup:"=",
			index:"="
		},
		link: function(scope, element,attrs,productBundleGroupsController){
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
		        	name:"Product Type",
		        	value:"productType"
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
				$slatwall.getEntity(filterTerm, {keywords:keyword})
				.then(function(value){
					$log.debug('getFiltersByTerm');
					$log.debug(value);
					scope.productBundleGroupFilters.value = productBundleService.formatProductBundleGroupFilters(value.pageRecords,filterTerm) || [];
					
					$log.debug('productBundleGroupFilters');
					$log.debug(scope.productBundleGroupFilters);
					
				});
			};
			
			scope.addFilterToProductBundle = function(filterItem){
				scope.productBundleGroup.productBundleGroupFilters.push(filterItem);
			};
			
			scope.removeProductBundleGroupFilter = function(index){
				scope.productBundleGroup.productBundleGroupFilters.splice(index,1);
			};
		}
	};
}]);
	
