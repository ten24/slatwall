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
			incrementFilterCount:"&",
			saveCollection:"&"
		},
		link: function(scope, element,attrs){
			var Partial = partialsPath+"filterGroups.html";
			var templateLoader = $http.get(Partial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
			
			scope.itemInUse = false;
			scope.setItemInUse = function(booleanValue){
				scope.itemInUse = booleanValue;
			};
			
			scope.deselectItems = function(filterItem){
				for(i in filterItem.$$siblingItems){
					filterItem.$$siblingItems[i].$$disabled = false;
				}
			}
			
			scope.removeFilterItem = function(filterItemIndex){
				console.log('remove')
				console.log(scope.filterGroupItem);
				if(angular.isDefined(filterItemIndex)){
					
					scope.deselectItems(scope.filterGroupItem[filterItemIndex]);
					scope.filterGroupItem[filterItemIndex].setItemInUse({booleanValue:false});
					//remove item
					$log.debug('removeFilterItem');
					$log.debug(filterItemIndex);
					scope.incrementFilterCount({number:-1});
					
					scope.filterGroupItem.splice(filterItemIndex,1);
					//make sure first item has no logical operator if it exists
					if(scope.filterGroupItem.length){
						delete scope.filterGroupItem[0].logicalOperator;
					}
					
					$log.debug('removeFilterItem');
					$log.debug(filterItemIndex);
					
					scope.saveCollection();
				}
			};
			
			//scope.
			
			scope.removeFilterGroupItem = function(filterGroupItemIndex){
				//remove Item
				scope.filterGroupItem.splice(filterGroupItemIndex,1);
				//make sure first item has no logical operator if it exists
				if(scope.filterGroupItem.length){
					delete scope.filterGroupItem[0].logicalOperator;
				}
				$log.debug('removeFilterGroupItem');
				$log.debug(filterGroupItemIndex);
				scope.saveCollection();
			};
		}
	};
}]);
	
