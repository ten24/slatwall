"use strict";
'use strict';
angular.module('slatwalladmin').directive('swCriteriaNumber', ['$log', '$slatwall', '$filter', 'collectionPartialsPath', 'collectionService', 'metadataService', function($log, $slatwall, $filter, collectionPartialsPath, collectionService, metadataService) {
  return {
    restrict: 'E',
    templateUrl: collectionPartialsPath + 'criterianumber.html',
    link: function(scope, element, attrs) {
      var getNumberOptions = function() {
        var numberOptions = [{
          display: "Equals",
          comparisonOperator: "="
        }, {
          display: "Doesn't Equal",
          comparisonOperator: "<>"
        }, {
          display: "In Range",
          comparisonOperator: "between",
          type: "range"
        }, {
          display: "Not In Range",
          comparisonOperator: "not between",
          type: "range"
        }, {
          display: "Greater Than",
          comparisonOperator: ">"
        }, {
          display: "Greater Than Or Equal",
          comparisonOperator: ">="
        }, {
          display: "Less Than",
          comparisonOperator: "<"
        }, {
          display: "Less Than Or Equal",
          comparisonOperator: "<="
        }, {
          display: "In List",
          comparisonOperator: "in"
        }, {
          display: "Not In List",
          comparisonOperator: "not in"
        }, {
          display: "Defined",
          comparisonOperator: "is not",
          value: "null"
        }, {
          display: "Not Defined",
          comparisonOperator: "is",
          value: "null"
        }];
        return numberOptions;
      };
      scope.$watch('selectedFilterProperty.criteriaValue', function(criteriaValue) {
        if (angular.isDefined(criteriaValue)) {
          scope.selectedFilterProperty.criteriaValue = criteriaValue;
          $log.debug(scope.selectedFilterProperty);
        }
      });
      scope.conditionOptions = getNumberOptions();
      scope.criteriaRangeChanged = function(selectedFilterProperty) {
        var selectedCondition = selectedFilterProperty.selectedCriteriaType;
      };
      scope.selectedConditionChanged = function(selectedFilterProperty) {
        selectedFilterProperty.showCriteriaValue = true;
        if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.type)) {
          selectedFilterProperty.showCriteriaValue = false;
          selectedFilterProperty.selectedCriteriaType.showCriteriaStart = true;
          selectedFilterProperty.selectedCriteriaType.showCriteriaEnd = true;
        }
        if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
          selectedFilterProperty.showCriteriaValue = false;
        }
      };
      angular.forEach(scope.conditionOptions, function(conditionOption) {
        $log.debug('populate');
        if (conditionOption.display == scope.filterItem.conditionDisplay) {
          scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
          $log.debuge.log(scope.filterItem);
          if (scope.filterItem.comparisonOperator === 'between' || scope.filterItem.comparisonOperator === 'not between') {
            var criteriaRangeArray = scope.filterItem.value.split('-');
            $log.debug(criteriaRangeArray);
            scope.selectedFilterProperty.criteriaRangeStart = parseInt(criteriaRangeArray[0]);
            scope.selectedFilterProperty.criteriaRangeEnd = parseInt(criteriaRangeArray[1]);
          } else {
            scope.selectedFilterProperty.criteriaValue = scope.filterItem.value;
          }
          if (angular.isDefined(scope.filterItem.criteriaNumberOf)) {
            scope.selectedFilterProperty.criteriaNumberOf = scope.filterItem.criteriaNumberOf;
          }
          if (angular.isDefined(scope.selectedConditionChanged)) {
            scope.selectedConditionChanged(scope.selectedFilterProperty);
          }
        }
      });
    }
  };
}]);
