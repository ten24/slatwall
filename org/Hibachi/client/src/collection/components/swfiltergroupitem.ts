/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
const filterGroupItemTemplateString = require("./filtergroupitem.html");

class SWFilterGroupItem{
    
	public static Factory(){
		var directive = /** @ngInject; */ ($compile, $templateCache, $templateRequest, $log, collectionService) => {
		    if( !$templateCache.get('filterGroupItemTemplateString') ){
		        $templateCache.put('filterGroupItemTemplateString', filterGroupItemTemplateString);
		    }
		    return new this($compile, $templateCache, $templateRequest, $log, collectionService );
		}
		return directive;
	}
	
	constructor(
		$compile,
		$templateCache,
		$templateRequest,
		$log,
		collectionService
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

				$templateRequest('filterGroupItemTemplateString')
				.then( (html) => element.html(html) )
                .then( () => {
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