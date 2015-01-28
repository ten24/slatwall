'use strict';
angular.module('slatwalladmin')
.directive('swFilterGroups', [
	'$http',
'$compile',
'$templateCache',
'$log',
'collectionPartialsPath',
	function(
	$http,
	$compile,
	$templateCache,
	$log,
	collectionPartialsPath
		){
		return {
			restrict: 'EA',
			scope:{
				collectionConfig:"=",
				filterGroupItem: "=",
				filterPropertiesList:"=",
				saveCollection:"&",
				filterGroup:"="
			},
			templateUrl:collectionPartialsPath+"filtergroups.html",
			controller: function($scope, $element,$attrs){
				$scope.itemInUse = false;
				console.log('collectionConfig');
				console.log($scope.collectionConfig);
				this.getFilterGroup = function(){
					return $scope.filterGroup;
				};
				
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
					for(var i in filterItem.$$siblingItems){
						filterItem.$$siblingItems[i].$$disabled = false;
					}
				};
				
				this.removeFilterItem = function(filterItemIndex){
					if(angular.isDefined(filterItemIndex)){
						
						$scope.deselectItems($scope.filterGroupItem[filterItemIndex]);
						$scope.filterGroupItem[filterItemIndex].setItemInUse(false);
						//remove item
						$log.debug('removeFilterItem');
						$log.debug(filterItemIndex);
						
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
	}
]);
	
