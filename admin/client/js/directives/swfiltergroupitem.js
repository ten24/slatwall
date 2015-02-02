'use strict';
angular.module('slatwalladmin')
.directive('swFilterGroupItem', [
	'$http',
	'$compile',
	'$templateCache',
	'$log',
	'collectionService',
	'collectionPartialsPath',
	function(
		$http,
		$compile,
		$templateCache,
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
			link: function(scope, element,attrs,filterGroupsController){
				var Partial = collectionPartialsPath+"filtergroupitem.html";
				var templateLoader = $http.get(Partial,{cache:$templateCache});
				var promise = templateLoader.success(function(html){
					element.html(html);
				}).then(function(response){
					element.replaceWith($compile(element.html())(scope));
				});
				
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
			}
		};
	}
]);
	
	
