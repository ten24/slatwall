'use strict';
angular.module('slatwalladmin')
.directive('swFilterItem', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'collectionPartialsPath',
'$log',
function($http,
$compile,
$templateCache,
collectionService,
collectionPartialsPath,
$log){
	return {
		restrict: 'A',
		require:'^swFilterGroups',
		scope:{
			filterItem: "=",
			siblingItems: "=",
			filterPropertiesList:"=",
			filterItemIndex:"=",
			saveCollection:"&"
		},
		templateUrl:collectionPartialsPath+"filteritem.html",
		link: function(scope, element,attrs,filterGroupsController){
			console.log(scope.filterPropertiesList);
			scope.baseEntityAlias = collectionService.getBaseEntityAlias();
			console.log(scope.baseEntityName);
			collectionService.incrementFilterCount(1);
			
			if(angular.isUndefined(scope.filterItem.$$isClosed)){
				scope.filterItem.$$isClosed = true;
			}
			if(angular.isUndefined(scope.filterItem.$$disabled)){
				scope.filterItem.$$disabled = false;
			}
			if(angular.isUndefined(scope.filterItem.siblingItems)){
				scope.filterItem.$$siblingItems = scope.siblingItems;
			}
			scope.filterItem.setItemInUse = filterGroupsController.setItemInUse;
			
			scope.selectFilterItem = function(filterItem){
				collectionService.selectFilterItem(filterItem);
			};
			
			scope.removeFilterItem = function(){
				filterGroupsController.removeFilterItem(scope.filterItemIndex,filterGroupsController.getFilterGroupItem());
			};
			
			scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
			
			scope.logicalOperatorChanged = function(logicalOperatorValue){
				$log.debug('logicalOperatorChanged');
				$log.debug(logicalOperatorValue);
				scope.filterItem.logicalOperator = logicalOperatorValue;
				filterGroupsController.saveCollection();
			};
			
			scope.$on(
                "$destroy",
                function() {
                	$log.debug('destroy filterItem');
                	collectionService.incrementFilterCount(-1);
                }
            );
			
		}
	};
}]);
	
