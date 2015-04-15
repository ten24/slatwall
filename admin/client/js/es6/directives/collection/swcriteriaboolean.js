"use strict";
'use strict';
angular.module('slatwalladmin').directive('swCriteriaBoolean', ['$log', '$slatwall', '$filter', 'collectionPartialsPath', 'collectionService', 'metadataService', function($log, $slatwall, $filter, collectionPartialsPath, collectionService, metadataService) {
  return {
    restrict: 'E',
    templateUrl: collectionPartialsPath + 'criteriaboolean.html',
    link: function(scope, element, attrs) {
      var getBooleanOptions = function() {
        var booleanOptions = [{
          display: "True",
          comparisonOperator: "=",
          value: "True"
        }, {
          display: "False",
          comparisonOperator: "=",
          value: "False"
        }, {
          display: "Defined",
          comparisonOperator: "is not",
          value: "null"
        }, {
          display: "Not Defined",
          comparisonOperator: "is",
          value: "null"
        }];
        return booleanOptions;
      };
      scope.conditionOptions = getBooleanOptions();
      angular.forEach(scope.conditionOptions, function(conditionOption) {
        if (conditionOption.display == scope.filterItem.conditionDisplay) {
          scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
          scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
          if (angular.isDefined(scope.selectedConditionChanged)) {
            scope.selectedConditionChanged(scope.selectedFilterProperty);
          }
        }
      });
    }
  };
}]);
