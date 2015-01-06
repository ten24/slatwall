'use strict';
angular.module('slatwalladmin')
.directive('swFilterGroupItem', [
	'$log',
	'collectionService',
	'collectionPartialsPath',
	function(
		$log,
		collectionService,
		collectionPartialsPath
	){
		return {
			restrict: 'A',
			require:"^swFilterGroups",
			scope:{
				collectionConfig:"=",
				filterGroupItem: "=",
				siblingItems:"=",
				filterPropertiesList:"=",
				filterGroupItemIndex:"=",
				saveCollection:"&"
			},
			templateUrl:collectionPartialsPath+"filtergroupitem.html",
			link: function(scope, element,attrs,filterGroupsController){
				
				collectionService.incrementFilterCount(1);
				
				//for(item in filterGroupItem){}
				scope.filterGroupItem.setItemInUse = filterGroupsController.setItemInUse;
				scope.filterGroupItem.$$index = scope.filterGroupItemIndex;
				
				scope.removeFilterGroupItem = function(){
					filterGroupsController.removeFilterGroupItem(scope.filterGroupItemIndex);
				};
				
				scope.filterGroupItem.removeFilterGroupItem = scope.removeFilterGroupItem;
				
				scope.filterGroupItem.$$disabled = false;
				if(angular.isUndefined(scope.filterGroupItem.$$isClosed)){
					scope.filterGroupItem.$$isClosed = true;
				}
				
				scope.filterGroupItem.$$siblingItems = scope.siblingItems;
				scope.selectFilterGroupItem = function(filterGroupItem){
					collectionService.selectFilterGroupItem(filterGroupItem);
				};
				
				scope.logicalOperatorChanged = function(logicalOperatorValue){
					$log.debug('logicalOperatorChanged');
					$log.debug(logicalOperatorValue);
					scope.filterGroupItem.logicalOperator = logicalOperatorValue;
					filterGroupsController.saveCollection();
				};
				
				scope.$on(
	                "$destroy",
	                function() {
	                	$log.debug('destroy filterGroupItem');
	                	collectionService.incrementFilterCount(-1);
	                }
	            );
			}
		};
	}
]);
	
	
