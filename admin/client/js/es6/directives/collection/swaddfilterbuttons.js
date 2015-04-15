"use strict";
'use strict';
angular.module('slatwalladmin').directive('swAddFilterButtons', ['$http', '$compile', '$templateCache', 'collectionService', 'collectionPartialsPath', function($http, $compile, $templateCache, collectionService, collectionPartialsPath) {
  return {
    require: '^swFilterGroups',
    restrict: 'E',
    templateUrl: collectionPartialsPath + "addfilterbuttons.html",
    scope: {itemInUse: "="},
    link: function(scope, element, attrs, filterGroupsController) {
      scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
      scope.addFilterItem = function() {
        collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(), filterGroupsController.setItemInUse);
      };
      scope.addFilterGroupItem = function() {
        collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(), filterGroupsController.setItemInUse, true);
      };
    }
  };
}]);
