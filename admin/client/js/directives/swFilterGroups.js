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
			var filterGroupsPartial = partialsPath+"filterGroups.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
		},
		controller: function($scope,$element,$attrs){
			$scope.itemInUse = false;
			$scope.setItemInUse = function(booleanValue){
				$scope.itemInUse = booleanValue;
			};
			
			$scope.removeFilterItem = function(filterItemIndex){
				//remove item
				$scope.filterGroupItem.splice(filterItemIndex,1);
				//make sure first item has no logical operator if it exists
				if($scope.filterGroupItem.length){
					delete $scope.filterGroupItem[0].logicalOperator;
				}else{
					delete $scope.filterGroupItem;
				}
				
				$log.debug('removeFilterItem');
				$log.debug(filterItemIndex);
				$scope.saveCollection();
			};
			
			$scope.removeFilterGroupItem = function(filterGroupItemIndex){
				//remove Item
				$scope.filterGroupItem.splice(filterGroupItemIndex,1);
				//make sure first item has no logical operator if it exists
				if($scope.filterGroupItem.length){
					delete $scope.filterGroupItem[0].logicalOperator;
				}else{
					delete $scope.filterGroupItem;
				}
				$log.debug('removeFilterGroupItem');
				$log.debug(filterGroupItemIndex);
				$scope.saveCollection();
			};
		}
	};
}]);
	
