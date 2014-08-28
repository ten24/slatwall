angular.module('slatwalladmin')
.directive('swFilterGroupItem',
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
			siblingItems:"=",
			incrementFilterCount:"&",
			setItemInUse:"&",
			filterPropertiesList:"=",
			saveCollection:"&",
			removeFilterGroupItem:"&",
			filterGroupItemIndex:"="
		},
		link: function(scope, element,attrs){
			var filterGroupsPartial = partialsPath+"filterGroupItem.html";
			var templateLoader = $http.get(filterGroupsPartial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
			scope.setItemInUse(false);
			
			//for(item in filterGroupItem){}
			scope.filterGroupItem.setItemInUse = scope.setItemInUse;
			
			scope.filterGroupItem.$$disabled = false;
			if(angular.isUndefined(scope.filterGroupItem.isClosed)){
				scope.filterGroupItem.isClosed = true;
			}
			
			scope.filterGroupItem.$$siblingItems = scope.siblingItems;
			scope.selectFilterGroupItem = function(filterGroupItem){
				collectionService.selectFilterGroupItem(filterGroupItem);
			};
			
			scope.logicalOperatorChanged = function(logicalOperatorValue){
				$log.debug('logicalOperatorChanged');
				$log.debug(logicalOperatorValue);
				scope.filterGroupItem.logicalOperator = logicalOperatorValue;
				scope.saveCollection();
			};
		}
	};
}]);
	
	
