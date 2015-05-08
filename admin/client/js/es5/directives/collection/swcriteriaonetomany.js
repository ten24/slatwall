"use strict";
'use strict';
angular.module('slatwalladmin').directive('swCriteriaOneToMany', ['$log', '$slatwall', '$filter', 'collectionPartialsPath', 'collectionService', 'metadataService', function($log, $slatwall, $filter, collectionPartialsPath, collectionService, metadataService) {
  return {
    restrict: 'E',
    templateUrl: collectionPartialsPath + 'criteriaonetomany.html',
    link: function(scope, element, attrs) {
      var getOneToManyOptions = function(type) {
        if (angular.isUndefined(type)) {
          type = 'filter';
        }
        var oneToManyOptions = [];
        if (type === 'filter') {
          oneToManyOptions = [{
            display: "All Exist In Collection",
            comparisonOperator: "All"
          }, {
            display: "None Exist In Collection",
            comparisonOperator: "None"
          }, {
            display: "Some Exist In Collection",
            comparisonOperator: "One"
          }];
        } else if (type === 'condition') {
          oneToManyOptions = [];
        }
        return oneToManyOptions;
      };
      $log.debug('onetomany');
      $log.debug(scope.selectedFilterProperty);
      scope.oneToManyOptions = getOneToManyOptions(scope.comparisonType);
      var existingCollectionsPromise = $slatwall.getExistingCollectionsByBaseEntity(scope.selectedFilterProperty.cfc);
      existingCollectionsPromise.then(function(value) {
        scope.collectionOptions = value.data;
        if (angular.isDefined(scope.filterItem.collectionID)) {
          for (var i in scope.collectionOptions) {
            if (scope.collectionOptions[i].collectionID === scope.filterItem.collectionID) {
              scope.selectedFilterProperty.selectedCollection = scope.collectionOptions[i];
            }
          }
          for (var i in scope.oneToManyOptions) {
            if (scope.oneToManyOptions[i].comparisonOperator === scope.filterItem.criteria) {
              scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[i];
            }
          }
        }
      });
      scope.selectedCriteriaChanged = function(selectedCriteria) {
        $log.debug(selectedCriteria);
        $log.debug(scope.selectedFilterProperty);
        var breadCrumb = {
          entityAlias: scope.selectedFilterProperty.name,
          cfc: scope.selectedFilterProperty.cfc,
          propertyIdentifier: scope.selectedFilterProperty.propertyIdentifier,
          rbKey: $slatwall.getRBKey('entity.' + scope.selectedFilterProperty.cfc.replace('_', '')),
          filterProperty: scope.selectedFilterProperty
        };
        scope.filterItem.breadCrumbs.push(breadCrumb);
        $log.debug('criteriaChanged');
        $log.debug(scope.selectedFilterProperty);
        scope.selectedFilterPropertyChanged({selectedFilterProperty: scope.selectedFilterProperty.selectedCriteriaType});
      };
    }
  };
}]);

//# sourceMappingURL=../../directives/collection/swcriteriaonetomany.js.map