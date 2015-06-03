"use strict";
'use strict';
angular.module('slatwalladmin').directive('swEditFilterItem', ['$http', '$compile', '$templateCache', '$log', '$filter', '$slatwall', 'collectionPartialsPath', 'collectionService', 'metadataService', function($http, $compile, $templateCache, $log, $filter, $slatwall, collectionPartialsPath, collectionService, metadataService) {
  return {
    require: '^swFilterGroups',
    restrict: 'E',
    scope: {
      collectionConfig: "=",
      filterItem: "=",
      filterPropertiesList: "=",
      saveCollection: "&",
      removeFilterItem: "&",
      filterItemIndex: "=",
      comparisonType: "="
    },
    templateUrl: collectionPartialsPath + "editfilteritem.html",
    link: function(scope, element, attrs, filterGroupsController) {
      function daysBetween(first, second) {
        var one = new Date(first.getFullYear(), first.getMonth(), first.getDate());
        var two = new Date(second.getFullYear(), second.getMonth(), second.getDate());
        var millisecondsPerDay = 1000 * 60 * 60 * 24;
        var millisBetween = two.getTime() - one.getTime();
        var days = millisBetween / millisecondsPerDay;
        return Math.floor(days);
      }
      if (angular.isUndefined(scope.filterItem.breadCrumbs)) {
        scope.filterItem.breadCrumbs = [];
        if (scope.filterItem.propertyIdentifier === "") {
          scope.filterItem.breadCrumbs = [{
            rbKey: $slatwall.getRBKey('entity.' + scope.collectionConfig.baseEntityAlias.replace('_', '')),
            entityAlias: scope.collectionConfig.baseEntityAlias,
            cfc: scope.collectionConfig.baseEntityAlias,
            propertyIdentifier: scope.collectionConfig.baseEntityAlias
          }];
        } else {
          var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
          entityAliasArrayFromString.pop();
          for (var i in entityAliasArrayFromString) {
            var breadCrumb = {
              rbKey: $slatwall.getRBKey('entity.' + scope.collectionConfig.baseEntityAlias.replace('_', '')),
              entityAlias: entityAliasArrayFromString[i],
              cfc: entityAliasArrayFromString[i],
              propertyIdentifier: entityAliasArrayFromString[i]
            };
            scope.filterItem.breadCrumbs.push(breadCrumb);
          }
        }
      } else {
        angular.forEach(scope.filterItem.breadCrumbs, function(breadCrumb, key) {
          if (angular.isUndefined(scope.filterPropertiesList[breadCrumb.propertyIdentifier])) {
            var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(breadCrumb.cfc);
            filterPropertiesPromise.then(function(value) {
              metadataService.setPropertiesList(value, breadCrumb.propertyIdentifier);
              scope.filterPropertiesList[breadCrumb.propertyIdentifier] = metadataService.getPropertiesListByBaseEntityAlias(breadCrumb.propertyIdentifier);
              metadataService.formatPropertiesList(scope.filterPropertiesList[breadCrumb.propertyIdentifier], breadCrumb.propertyIdentifier);
              var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
              entityAliasArrayFromString.pop();
              entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
              if (angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])) {
                for (var i in scope.filterPropertiesList[entityAliasArrayFromString].data) {
                  var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
                  if (filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier) {
                    scope.selectedFilterProperty = filterProperty;
                    scope.selectedFilterProperty.value = scope.filterItem.value;
                    scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
                  }
                }
              }
            });
          } else {
            var entityAliasArrayFromString = scope.filterItem.propertyIdentifier.split('.');
            entityAliasArrayFromString.pop();
            entityAliasArrayFromString = entityAliasArrayFromString.join('.').trim();
            if (angular.isDefined(scope.filterPropertiesList[entityAliasArrayFromString])) {
              for (var i in scope.filterPropertiesList[entityAliasArrayFromString].data) {
                var filterProperty = scope.filterPropertiesList[entityAliasArrayFromString].data[i];
                if (filterProperty.propertyIdentifier === scope.filterItem.propertyIdentifier) {
                  scope.selectedFilterProperty = filterProperty;
                  scope.selectedFilterProperty.value = scope.filterItem.value;
                  scope.selectedFilterProperty.comparisonOperator = scope.filterItem.comparisonOperator;
                }
              }
            }
          }
        });
      }
      if (angular.isUndefined(scope.filterItem.$$isClosed)) {
        scope.filterItem.$$isClosed = true;
      }
      scope.filterGroupItem = filterGroupsController.getFilterGroupItem();
      scope.togglePrepareForFilterGroup = function() {
        scope.filterItem.$$prepareForFilterGroup = !scope.filterItem.$$prepareForFilterGroup;
      };
      scope.selectBreadCrumb = function(breadCrumbIndex) {
        var removeCount = scope.filterItem.breadCrumbs.length - 1 - breadCrumbIndex;
        scope.filterItem.breadCrumbs.splice(breadCrumbIndex + 1, removeCount);
        $log.debug('selectBreadCrumb');
        $log.debug(scope.selectedFilterProperty);
        scope.selectedFilterPropertyChanged(null);
      };
      scope.selectedFilterPropertyChanged = function(selectedFilterProperty) {
        $log.debug('selectedFilterProperty');
        $log.debug(selectedFilterProperty);
        if (angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType)) {
          delete scope.selectedFilterProperty.selectedCriteriaType;
        }
        if (angular.isDefined(scope.filterItem.value)) {
          delete scope.filterItem.value;
        }
        scope.selectedFilterProperty.showCriteriaValue = false;
        scope.selectedFilterProperty = selectedFilterProperty;
      };
      scope.addFilterItem = function() {
        collectionService.newFilterItem(filterGroupsController.getFilterGroupItem(), filterGroupsController.setItemInUse);
      };
      scope.cancelFilterItem = function() {
        $log.debug('cancelFilterItem');
        $log.debug(scope.filterItemIndex);
        scope.filterItem.setItemInUse(false);
        scope.filterItem.$$isClosed = true;
        for (var siblingIndex in scope.filterItem.$$siblingItems) {
          scope.filterItem.$$siblingItems[siblingIndex].$$disabled = false;
        }
        if (scope.filterItem.$$isNew === true) {
          scope.removeFilterItem({filterItemIndex: scope.filterItemIndex});
        }
      };
      scope.saveFilter = function(selectedFilterProperty, filterItem, callback) {
        $log.debug('saveFilter begin');
        if (angular.isDefined(selectedFilterProperty.selectedCriteriaType) && angular.equals({}, selectedFilterProperty.selectedCriteriaType)) {
          return ;
        }
        if (angular.isDefined(selectedFilterProperty) && angular.isDefined(selectedFilterProperty.selectedCriteriaType)) {
          filterItem.$$isNew = false;
          filterItem.propertyIdentifier = selectedFilterProperty.propertyIdentifier;
          filterItem.displayPropertyIdentifier = selectedFilterProperty.displayPropertyIdentifier;
          switch (selectedFilterProperty.ormtype) {
            case 'boolean':
              filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
              filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
              filterItem.displayValue = filterItem.value;
              break;
            case 'string':
              if (angular.isDefined(selectedFilterProperty.attributeID)) {
                filterItem.attributeID = selectedFilterProperty.attributeID;
                filterItem.attributeSetObject = selectedFilterProperty.attributeSetObject;
              }
              filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
              if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
                filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
                filterItem.displayValue = filterItem.value;
              } else {
                if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.pattern)) {
                  filterItem.pattern = selectedFilterProperty.selectedCriteriaType.pattern;
                  filterItem.displayValue = filterItem.value;
                } else {
                  filterItem.value = filterItem.value;
                  if (angular.isUndefined(filterItem.displayValue)) {
                    filterItem.displayValue = filterItem.value;
                  }
                }
              }
              break;
            case 'timestamp':
              filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
              if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
                filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
                filterItem.displayValue = filterItem.value;
              } else {
                if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.dateInfo.type) && selectedFilterProperty.selectedCriteriaType.dateInfo.type === 'calculation') {
                  var _daysBetween = daysBetween(new Date(selectedFilterProperty.criteriaRangeStart), new Date(selectedFilterProperty.criteriaRangeEnd));
                  filterItem.value = _daysBetween;
                  filterItem.displayValue = selectedFilterProperty.selectedCriteriaType.display;
                  if (angular.isDefined(selectedFilterProperty.criteriaNumberOf)) {
                    filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
                  }
                } else {
                  var dateValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
                  filterItem.value = dateValueString;
                  var formattedDateValueString = $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeStart), 'MM/dd/yyyy @ h:mma') + '-' + $filter('date')(angular.copy(selectedFilterProperty.criteriaRangeEnd), 'MM/dd/yyyy @ h:mma');
                  filterItem.displayValue = formattedDateValueString;
                  if (angular.isDefined(selectedFilterProperty.criteriaNumberOf)) {
                    filterItem.criteriaNumberOf = selectedFilterProperty.criteriaNumberOf;
                  }
                }
              }
              break;
            case 'big_decimal':
            case 'integer':
            case 'float':
              filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
              if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
                filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
              } else {
                if (angular.isUndefined(selectedFilterProperty.selectedCriteriaType.type)) {
                  filterItem.value = selectedFilterProperty.criteriaValue;
                } else {
                  var decimalValueString = selectedFilterProperty.criteriaRangeStart + '-' + selectedFilterProperty.criteriaRangeEnd;
                  filterItem.value = decimalValueString;
                }
              }
              filterItem.displayValue = filterItem.value;
              break;
          }
          switch (selectedFilterProperty.fieldtype) {
            case 'many-to-one':
              filterItem.comparisonOperator = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
              if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
                filterItem.value = selectedFilterProperty.selectedCriteriaType.value;
              }
              filterItem.displayValue = filterItem.value;
              break;
            case 'one-to-many':
            case 'many-to-many':
              filterItem.collectionID = selectedFilterProperty.selectedCollection.collectionID;
              filterItem.displayValue = selectedFilterProperty.selectedCollection.collectionName;
              filterItem.criteria = selectedFilterProperty.selectedCriteriaType.comparisonOperator;
              break;
          }
          if (angular.isUndefined(filterItem.displayValue)) {
            filterItem.displayValue = filterItem.value;
          }
          if (angular.isDefined(selectedFilterProperty.ormtype)) {
            filterItem.ormtype = selectedFilterProperty.ormtype;
          }
          if (angular.isDefined(selectedFilterProperty.fieldtype)) {
            filterItem.fieldtype = selectedFilterProperty.fieldtype;
          }
          for (var siblingIndex in filterItem.$$siblingItems) {
            filterItem.$$siblingItems[siblingIndex].$$disabled = false;
          }
          filterItem.conditionDisplay = selectedFilterProperty.selectedCriteriaType.display;
          if (filterItem.$$prepareForFilterGroup === true) {
            collectionService.transplantFilterItemIntoFilterGroup(filterGroupsController.getFilterGroupItem(), filterItem);
          }
          scope.saveCollection();
          $log.debug(selectedFilterProperty);
          $log.debug(filterItem);
          callback();
          $log.debug('saveFilter end');
        }
      };
    }
  };
}]);

//# sourceMappingURL=../../directives/collection/sweditfilteritem.js.map