"use strict";
angular.module("slatwalladmin").directive("swFilterItem", ["$log", "collectionService", "collectionPartialsPath", function ($log, collectionService, collectionPartialsPath) {
	return {
		restrict: "A",
		require: "^swFilterGroups",
		scope: {
			collectionConfig: "=",
			filterItem: "=",
			siblingItems: "=",
			filterPropertiesList: "=",
			filterItemIndex: "=",
			saveCollection: "&"
		},
		templateUrl: collectionPartialsPath + "filteritem.html",
		link: function (scope, element, attrs, filterGroupsController) {
			scope.baseEntityAlias = scope.collectionConfig.baseEntityAlias;

			if (angular.isUndefined(scope.filterItem.$$isClosed)) {
				scope.filterItem.$$isClosed = true;
			}
			if (angular.isUndefined(scope.filterItem.$$disabled)) {
				scope.filterItem.$$disabled = false;
			}
			if (angular.isUndefined(scope.filterItem.siblingItems)) {
				scope.filterItem.$$siblingItems = scope.siblingItems;
			}
			scope.filterItem.setItemInUse = filterGroupsController.setItemInUse;

			scope.selectFilterItem = function (filterItem) {
				collectionService.selectFilterItem(filterItem);
			};

			scope.removeFilterItem = function () {
				filterGroupsController.removeFilterItem(scope.filterItemIndex, filterGroupsController.getFilterGroupItem());
			};

			scope.filterGroupItem = filterGroupsController.getFilterGroupItem();

			scope.logicalOperatorChanged = function (logicalOperatorValue) {
				$log.debug("logicalOperatorChanged");
				$log.debug(logicalOperatorValue);
				scope.filterItem.logicalOperator = logicalOperatorValue;
				filterGroupsController.saveCollection();
			};
		}
	};
}]);