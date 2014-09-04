'use strict';
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
		require:"^swFilterGroups",
		scope:{
			filterGroupItem: "=",
			siblingItems:"=",
			filterPropertiesList:"=",
			filterGroupItemIndex:"=",
			saveCollection:"&"
		},
		link: function(scope, element,attrs,filterGroupsController){
			var Partial = partialsPath+"filtergroupitem.html";
			var templateLoader = $http.get(Partial,{cache:$templateCache});
			var promise = templateLoader.success(function(html){
				element.html(html);
			}).then(function(response){
				element.replaceWith($compile(element.html())(scope));
			});
			
			//for(item in filterGroupItem){}
			scope.filterGroupItem.setItemInUse = filterGroupsController.setItemInUse;
			
			scope.incrementFilterCount = function(number){
				filterGroupsController.incrementFilterCount(number);
			};
			
			scope.removeFilterGroupItem = function(){
				filterGroupsController.removeFilterGroupItem(scope.filterGroupItemIndex);
			};
			
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
		}
	};
}]);
	
	
