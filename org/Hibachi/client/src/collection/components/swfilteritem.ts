/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWFilterItem{
    public template = require('./filteritem.html');
    public restrict =  'A';

	public require = '^swFilterGroups';

	public scope = {
		collectionConfig:"=",
		filterItem: "=",
		siblingItems: "=",
		filterPropertiesList:"=",
		filterItemIndex:"=",
		saveCollection:"&",
		comparisonType:"=",
        simple:"="
	}
	
	public link: ng.IDirectiveLinkFn = (scope, element,attrs, filterGroupsController: any) => {
		scope.baseEntityAlias = scope.collectionConfig.baseEntityAlias;

		if(angular.isUndefined(scope.filterItem.$$isClosed)){
			scope.filterItem.$$isClosed = true;
		}
		if(angular.isUndefined(scope.filterItem.$$disabled)){
			scope.filterItem.$$disabled = false;
		}
		if(angular.isUndefined(scope.filterItem.siblingItems)){
			scope.filterItem.$$siblingItems = scope.siblingItems;
		}
		scope.filterItem.setItemInUse = filterGroupsController.setItemInUse;

		scope.selectFilterItem = function(filterItem){
			this.collectionService.selectFilterItem(filterItem);
		};

		scope.removeFilterItem = function(){
			filterGroupsController.removeFilterItem(scope.filterItemIndex,filterGroupsController.getFilterGroupItem());
		};

		scope.filterGroupItem = filterGroupsController.getFilterGroupItem();

		scope.logicalOperatorChanged = function(logicalOperatorValue){
			this.$log.debug('logicalOperatorChanged');
			this.$log.debug(logicalOperatorValue);
			scope.filterItem.logicalOperator = logicalOperatorValue;
			filterGroupsController.saveCollection();
		};
	}

	public static Factory(){
		return /** @ngInject;*/ ($log, collectionService) => new SWFilterItem($log, collectionService);
	}
    
    // 	@ngInject;
	constructor( $log, collectionService ){
	}
}
export{
	SWFilterItem
}

