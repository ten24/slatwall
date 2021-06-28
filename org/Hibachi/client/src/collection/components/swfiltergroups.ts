/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
const filterGroupsTemplateString = require("./filtergroups.html");

class SWFilterGroups{
	public static Factory(){
		return /** @ngInject; */ ($log,observerService)=> new this( $log, observerService );
	}
	
    // 	@ngInject;
	constructor( $log, observerService ){
		return {
			restrict: 'EA',
			scope:{
				collectionConfig:"=?",
				filterGroupItem: "=?",
				filterPropertiesList:"=?",
				saveCollection:"&",
				filterGroup:"=?",
				comparisonType:"=?",
                simple:"=",
                readOnly:"="
			},
			template: filterGroupsTemplateString,
			controller: ['$scope','$element','$attrs',function($scope, $element,$attrs){
				//if the filter group comparisontype is not specified, then assume we are doing filters
				if(!angular.isDefined($scope.comparisonType)){
					$scope.comparisonType = 'filter';
				}
				$scope.itemInUse = false;
				$log.debug('collectionConfig');
				$log.debug($scope.collectionConfig);
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


			}]
		};
	}
}
export{
	SWFilterGroups
}

