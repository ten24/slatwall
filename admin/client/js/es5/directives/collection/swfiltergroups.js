"use strict";
'use strict';
angular.module('slatwalladmin').directive('swFilterGroups', ['$http', '$compile', '$templateCache', '$log', 'collectionPartialsPath', function($http, $compile, $templateCache, $log, collectionPartialsPath) {
  return {
    restrict: 'EA',
    scope: {
      collectionConfig: "=",
      filterGroupItem: "=",
      filterPropertiesList: "=",
      saveCollection: "&",
      filterGroup: "=",
      comparisonType: "@"
    },
    templateUrl: collectionPartialsPath + "filtergroups.html",
    controller: ['$scope', '$element', '$attrs', function($scope, $element, $attrs) {
      if (!angular.isDefined($scope.comparisonType)) {
        $scope.comparisonType = 'filter';
      }
      $scope.itemInUse = false;
      $log.debug('collectionConfig');
      $log.debug($scope.collectionConfig);
      this.getFilterGroup = function() {
        return $scope.filterGroup;
      };
      this.getFilterGroupItem = function() {
        return $scope.filterGroupItem;
      };
      this.setItemInUse = function(booleanValue) {
        $scope.itemInUse = booleanValue;
      };
      this.getItemInUse = function() {
        return $scope.itemInUse;
      };
      this.saveCollection = function() {
        $scope.saveCollection();
      };
      $scope.deselectItems = function(filterItem) {
        for (var i in filterItem.$$siblingItems) {
          filterItem.$$siblingItems[i].$$disabled = false;
        }
      };
      this.removeFilterItem = function(filterItemIndex) {
        if (angular.isDefined(filterItemIndex)) {
          $scope.deselectItems($scope.filterGroupItem[filterItemIndex]);
          $scope.filterGroupItem[filterItemIndex].setItemInUse(false);
          $log.debug('removeFilterItem');
          $log.debug(filterItemIndex);
          $scope.filterGroupItem.splice(filterItemIndex, 1);
          if ($scope.filterGroupItem.length) {
            delete $scope.filterGroupItem[0].logicalOperator;
          }
          $log.debug('removeFilterItem');
          $log.debug(filterItemIndex);
          $scope.saveCollection();
        }
      };
      this.removeFilterGroupItem = function(filterGroupItemIndex) {
        $scope.deselectItems($scope.filterGroupItem[filterGroupItemIndex]);
        $scope.filterGroupItem[filterGroupItemIndex].setItemInUse(false);
        $scope.filterGroupItem.splice(filterGroupItemIndex, 1);
        if ($scope.filterGroupItem.length) {
          delete $scope.filterGroupItem[0].logicalOperator;
        }
        $log.debug('removeFilterGroupItem');
        $log.debug(filterGroupItemIndex);
        $scope.saveCollection();
      };
    }]
  };
}]);

//# sourceMappingURL=../../directives/collection/swfiltergroups.js.map