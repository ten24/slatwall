/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFilterGroupItem{
	public static Factory(){
		var directive = (
			$http,
			$compile,
			$templateCache,
			$log,
			collectionService,
			collectionPartialsPath,
			hibachiPathBuilder
		)=> new SWFilterGroupItem(
			$http,
			$compile,
			$templateCache,
			$log,
			collectionService,
			collectionPartialsPath,
			hibachiPathBuilder
		);
		directive.$inject = [
			'$http',
			'$compile',
			'$templateCache',
			'$log',
			'collectionService',
			'collectionPartialsPath',
			'hibachiPathBuilder'
		];
		return directive;
	}
	constructor(
		$http,
		$compile,
		$templateCache,
		$log,
		collectionService,
		collectionPartialsPath,
		hibachiPathBuilder
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
				saveCollection:"&",
				comparisonType:"="
			},
			link: function(scope, element,attrs,filterGroupsController){
				var Partial = hibachiPathBuilder.buildPartialsPath(collectionPartialsPath)+"filtergroupitem.html";
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
}
export{
	SWFilterGroupItem
}