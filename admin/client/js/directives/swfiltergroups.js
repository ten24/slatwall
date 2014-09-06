'use strict';
angular.module('slatwalladmin')
.directive('swFilterGroups', 
['$http',
'$compile',
'$templateCache',
'collectionService',
'partialsPath',
'$log',
function($http,
$compile,
$templateCache,
collectionService,
partialsPath,
$log){
	return {
		restrict: 'A',
		scope:{
			filterGroupItem: "=",
			filterPropertiesList:"=",
			saveCollection:"&"
		},
		templateUrl:partialsPath+"filtergroups.html",
		controller: function($scope, $element,$attrs){
			$scope.itemInUse = false;
			
			this.getFilterGroupItem = function(){
				return $scope.filterGroupItem;
			};
			
			this.setItemInUse = function(booleanValue){
				$scope.itemInUse = booleanValue;
			};
			
			this.getItemInUse = function(){
				return $scope.itemInUse;
			};
			
			this.saveCollection = function(){
				$scope.saveCollection();
			};
			
			$scope.deselectItems = function(filterItem){
				for(i in filterItem.$$siblingItems){
					filterItem.$$siblingItems[i].$$disabled = false;
				}
			};
			
			this.removeFilterItem = function(filterItemIndex){
				console.log('remove');
				console.log($scope.filterGroupItem);
				if(angular.isDefined(filterItemIndex)){
					
					$scope.deselectItems($scope.filterGroupItem[filterItemIndex]);
					$scope.filterGroupItem[filterItemIndex].setItemInUse(false);
					//remove item
					$log.debug('removeFilterItem');
					$log.debug(filterItemIndex);
					//$scope.incrementFilterCount({number:-1});
					
					$scope.filterGroupItem.splice(filterItemIndex,1);
					//make sure first item has no logical operator if it exists
					if($scope.filterGroupItem.length){
						delete $scope.filterGroupItem[0].logicalOperator;
					}
					
					$log.debug('removeFilterItem');
					$log.debug(filterItemIndex);
					
					$scope.saveCollection();
				}
			};
			
			this.removeFilterGroupItem = function(filterGroupItemIndex){
				//remove Item
				console.log($scope.filterGroupItem[filterGroupItemIndex]);
				$scope.deselectItems($scope.filterGroupItem[filterGroupItemIndex]);
				$scope.filterGroupItem[filterGroupItemIndex].setItemInUse(false);
				
				$scope.filterGroupItem.splice(filterGroupItemIndex,1);
				//make sure first item has no logical operator if it exists
				if($scope.filterGroupItem.length){
					delete $scope.filterGroupItem[0].logicalOperator;
				}
				$log.debug('removeFilterGroupItem');
				$log.debug(filterGroupItemIndex);
				$scope.saveCollection();
			};
		}
	};
}]);
	
