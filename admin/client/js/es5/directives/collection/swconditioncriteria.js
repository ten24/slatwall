"use strict";
'use strict';
angular.module('slatwalladmin').directive('swConditionCriteria', ['$http', '$compile', '$templateCache', '$log', '$slatwall', '$filter', 'workflowPartialsPath', 'collectionPartialsPath', 'collectionService', 'metadataService', function($http, $compile, $templateCache, $log, $slatwall, $filter, workflowPartialsPath, collectionPartialsPath, collectionService, metadataService) {
  var getTemplate = function(selectedFilterProperty) {
    var template = '';
    var templatePath = '';
    if (angular.isUndefined(selectedFilterProperty.ormtype) && angular.isUndefined(selectedFilterProperty.fieldtype)) {
      templatePath = collectionPartialsPath + "criteria.html";
    } else {
      var criteriaormtype = selectedFilterProperty.ormtype;
      var criteriafieldtype = selectedFilterProperty.fieldtype;
      switch (criteriaormtype) {
        case 'boolean':
          templatePath = collectionPartialsPath + "criteriaboolean.html";
          break;
        case 'string':
          templatePath = collectionPartialsPath + "criteriastring.html";
          break;
        case 'timestamp':
          templatePath = collectionPartialsPath + "criteriadate.html";
          break;
        case 'big_decimal':
        case 'integer':
        case 'float':
          templatePath = collectionPartialsPath + "criterianumber.html";
          break;
      }
      switch (criteriafieldtype) {
        case "many-to-one":
          templatePath = collectionPartialsPath + "criteriamanytoone.html";
          break;
        case "many-to-many":
          templatePath = collectionPartialsPath + "criteriamanytomany.html";
          break;
        case "one-to-many":
          templatePath = collectionPartialsPath + "criteriaonetomany.html";
          break;
      }
    }
    var templateLoader = $http.get(templatePath, {cache: $templateCache});
    return templateLoader;
  };
  var getStringOptions = function(type) {
    var stringOptions = [];
    if (angular.isUndefined(type)) {
      type = 'filter';
    }
    if (type == 'filter') {
      stringOptions = [{
        display: "Equals",
        comparisonOperator: "="
      }, {
        display: "Doesn't Equal",
        comparisonOperator: "<>"
      }, {
        display: "Contains",
        comparisonOperator: "like",
        pattern: "%w%"
      }, {
        display: "Doesn't Contain",
        comparisonOperator: "not like",
        pattern: "%w%"
      }, {
        display: "Starts With",
        comparisonOperator: "like",
        pattern: "w%"
      }, {
        display: "Doesn't Start With",
        comparisonOperator: "not like",
        pattern: "w%"
      }, {
        display: "Ends With",
        comparisonOperator: "like",
        pattern: "%w"
      }, {
        display: "Doesn't End With",
        comparisonOperator: "not like",
        pattern: "%w"
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
      if (type === 'condition') {
        stringOptions = [{
          display: "Equals",
          comparisonOperator: "="
        }, {
          display: "In List",
          comparisonOperator: "in"
        }, {
          display: "Defined",
          comparisonOperator: "is not",
          value: "null"
        }, {
          display: "Not Defined",
          comparisonOperator: "is",
          value: "null"
        }];
      }
    }
    return stringOptions;
  };
  var getBooleanOptions = function(type) {
    var booleanOptions = [];
    if (angular.isUndefined(type)) {
      type = 'filter';
    }
    if (type === 'filter' || type === 'condition') {
      booleanOptions = [{
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
    }
    return booleanOptions;
  };
  var getDateOptions = function(type) {
    var dateOptions = [];
    if (angular.isUndefined(type)) {
      type = 'filter';
    }
    if (type === 'filter') {
      dateOptions = [{
        display: "Date",
        comparisonOperator: "between",
        dateInfo: {type: 'exactDate'}
      }, {
        display: "In Range",
        comparisonOperator: "between",
        dateInfo: {type: 'range'}
      }, {
        display: "Not In Range",
        comparisonOperator: "not between",
        dateInfo: {type: 'range'}
      }, {
        display: "Today",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'd',
          measureCount: 0,
          behavior: 'toDate'
        }
      }, {
        display: "Yesterday",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'd',
          measureCount: -1,
          behavior: 'toDate'
        }
      }, {
        display: "This Week",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'w',
          behavior: 'toDate'
        }
      }, {
        display: "This Month",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'm',
          behavior: 'toDate'
        }
      }, {
        display: "This Quarter",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'q',
          behavior: 'toDate'
        }
      }, {
        display: "This Year",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'y',
          behavior: 'toDate'
        }
      }, {
        display: "Last N Hour(s)",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'h',
          measureTypeDisplay: 'Hours'
        }
      }, {
        display: "Last N Day(s)",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'd',
          measureTypeDisplay: 'Days'
        }
      }, {
        display: "Last N Week(s)",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'w',
          measureTypeDisplay: 'Weeks'
        }
      }, {
        display: "Last N Month(s)",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'm',
          measureTypeDisplay: 'Months'
        }
      }, {
        display: "Last N Quarter(s)",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'q',
          measureTypeDisplay: 'Quarters'
        }
      }, {
        display: "Last N Year(s)",
        comparisonOperator: "between",
        dateInfo: {
          type: 'calculation',
          measureType: 'y',
          measureTypeDisplay: 'Years'
        }
      }, {
        display: "Defined",
        comparisonOperator: "is not",
        value: "null"
      }, {
        display: "Not Defined",
        comparisonOperator: "is",
        value: "null"
      }];
    }
    if (type === 'condition') {
      dateOptions = [{
        display: "Defined",
        comparisonOperator: "is not",
        value: "null"
      }, {
        display: "Not Defined",
        comparisonOperator: "is",
        value: "null"
      }];
    }
    return dateOptions;
  };
  var getNumberOptions = function(type) {
    var numberOptions = [];
    if (angular.isUndefined(type)) {
      type = 'filter';
    }
    if (type == 'filter') {
      numberOptions = [{
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
    }
    if (type === 'condition') {
      numberOptions = [{
        display: "Equals",
        comparisonOperator: "="
      }, {
        display: "Doesn't Equal",
        comparisonOperator: "<>"
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
        display: "Defined",
        comparisonOperator: "is not",
        value: "null"
      }, {
        display: "Not Defined",
        comparisonOperator: "is",
        value: "null"
      }];
    }
    return numberOptions;
  };
  var getOneToManyOptions = function(type) {
    var oneToManyOptions = [];
    if (angular.isUndefined(type)) {
      type = 'filter';
    }
    if (type == 'filter') {
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
    }
    if (type === 'condition') {
      oneToManyOptions = [];
    }
    return oneToManyOptions;
  };
  var getManyToManyOptions = function(type) {
    var manyToManyOptions = [];
    if (angular.isUndefined(type)) {
      type = 'filter';
    }
    if (type == 'filter') {
      manyToManyOptions = [{
        display: "All Exist In Collection",
        comparisonOperator: "All"
      }, {
        display: "None Exist In Collection",
        comparisonOperator: "None"
      }, {
        display: "Some Exist In Collection",
        comparisonOperator: "One"
      }, {
        display: "Empty",
        comparisonOperator: "is",
        value: "null"
      }, {
        display: "Not Empty",
        comparisonOperator: "is not",
        value: "null"
      }];
    }
    if (type === 'condition') {
      manyToManyOptions = [{
        display: "Empty",
        comparisonOperator: "is",
        value: "null"
      }, {
        display: "Not Empty",
        comparisonOperator: "is not",
        value: "null"
      }];
    }
    return manyToManyOptions;
  };
  var getManyToOneOptions = function(type) {
    var manyToOneOptions = [];
    if (angular.isUndefined(type)) {
      type = 'filter';
    }
    if (type == 'filter') {
      manyToOneOptions = {
        drillEntity: {},
        hasEntity: {
          display: "Defined",
          comparisonOperator: "is not",
          value: "null"
        },
        notHasEntity: {
          display: "Not Defined",
          comparisonOperator: "is",
          value: "null"
        }
      };
    }
    return manyToOneOptions;
  };
  var linker = function(scope, element, attrs) {
    scope.$watch('selectedFilterProperty.criteriaValue', function(criteriaValue) {
      if (angular.isDefined(criteriaValue)) {
        scope.selectedFilterProperty.criteriaValue = $filter('likeFilter')(criteriaValue);
      }
    });
    scope.$watch('selectedFilterProperty', function(selectedFilterProperty) {
      if (angular.isDefined(selectedFilterProperty)) {
        $log.debug('watchSelectedFilterProperty');
        $log.debug(scope.selectedFilterProperty);
        if (selectedFilterProperty === null) {
          return;
        }
        if (angular.isDefined(selectedFilterProperty.ormtype)) {
          switch (scope.selectedFilterProperty.ormtype) {
            case "boolean":
              scope.conditionOptions = getBooleanOptions();
              break;
            case "string":
              scope.conditionOptions = getStringOptions();
              scope.selectedConditionChanged = function(selectedFilterProperty) {
                if (angular.isDefined(selectedFilterProperty.selectedCriteriaType.value)) {
                  selectedFilterProperty.showCriteriaValue = false;
                } else {
                  selectedFilterProperty.showCriteriaValue = true;
                }
              };
              break;
            case "timestamp":
              scope.conditionOptions = getDateOptions();
              scope.today = function() {
                if (angular.isDefined(scope.selectedFilterProperty)) {
                  scope.selectedFilterProperty.criteriaRangeStart = new Date();
                  scope.selectedFilterProperty.criteriaRangeEnd = new Date();
                }
              };
              scope.clear = function() {
                scope.selectedFilterProperty.criteriaRangeStart = null;
                scope.selectedFilterProperty.criteriaRangeEnd = null;
              };
              scope.openCalendarStart = function($event) {
                $event.preventDefault();
                $event.stopPropagation();
                scope.openedCalendarStart = true;
              };
              scope.openCalendarEnd = function($event) {
                $event.preventDefault();
                $event.stopPropagation();
                scope.openedCalendarEnd = true;
              };
              scope.formats = ['dd-MMMM-yyyy', 'yyyy/MM/dd', 'dd.MM.yyyy', 'shortDate'];
              scope.format = scope.formats[1];
              scope.selectedConditionChanged = function(selectedFilterProperty) {
                $log.debug('selectedConditionChanged Begin');
                var selectedCondition = selectedFilterProperty.selectedCriteriaType;
                if (angular.isDefined(selectedCondition.dateInfo)) {
                  if (selectedCondition.dateInfo.type === 'calculation') {
                    selectedCondition.showCriteriaStart = true;
                    selectedCondition.showCriteriaEnd = true;
                    selectedCondition.disableCriteriaStart = true;
                    selectedCondition.disableCriteriaEnd = true;
                    if (angular.isUndefined(selectedCondition.dateInfo.behavior)) {
                      $log.debug('Not toDate');
                      selectedCondition.showNumberOf = true;
                      selectedCondition.conditionDisplay = 'Number of ' + selectedCondition.dateInfo.measureTypeDisplay + ' :';
                    } else {
                      $log.debug('toDate');
                      var today = Date.parse('today');
                      var todayEOD = today.setHours(23, 59, 59, 999);
                      selectedFilterProperty.criteriaRangeEnd = todayEOD;
                      switch (selectedCondition.dateInfo.measureType) {
                        case 'd':
                          var dateBOD = Date.parse('today').add(selectedCondition.dateInfo.measureCount).days();
                          dateBOD.setHours(0, 0, 0, 0);
                          selectedFilterProperty.criteriaRangeStart = dateBOD.getTime();
                          break;
                        case 'w':
                          var firstDayOfWeek = Date.today().last().monday();
                          selectedFilterProperty.criteriaRangeStart = firstDayOfWeek.getTime();
                          break;
                        case 'm':
                          var firstDayOfMonth = Date.today().moveToFirstDayOfMonth();
                          selectedFilterProperty.criteriaRangeStart = firstDayOfMonth.getTime();
                          break;
                        case 'q':
                          var month = Date.parse('today').toString('MM');
                          var year = Date.parse('today').toString('yyyy');
                          var quarterMonth = (Math.floor(month / 3) * 3);
                          var firstDayOfQuarter = new Date(year, quarterMonth, 1);
                          selectedFilterProperty.criteriaRangeStart = firstDayOfQuarter.getTime();
                          break;
                        case 'y':
                          var year = Date.parse('today').toString('yyyy');
                          var firstDayOfYear = new Date(year, 0, 1);
                          selectedFilterProperty.criteriaRangeStart = firstDayOfYear.getTime();
                          break;
                      }
                    }
                  }
                  if (selectedCondition.dateInfo.type === 'range') {
                    selectedCondition.showCriteriaStart = true;
                    selectedCondition.showCriteriaEnd = true;
                    selectedCondition.disableCriteriaStart = false;
                    selectedCondition.disableCriteriaEnd = false;
                    selectedCondition.showNumberOf = false;
                  }
                  if (selectedCondition.dateInfo.type === 'exactDate') {
                    selectedCondition.showCriteriaStart = true;
                    selectedCondition.showCriteriaEnd = false;
                    selectedCondition.disableCriteriaStart = false;
                    selectedCondition.disableCriteriaEnd = true;
                    selectedCondition.showNumberOf = false;
                    selectedCondition.conditionDisplay = '';
                    selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0, 0, 0, 0);
                    selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23, 59, 59, 999);
                  }
                } else {
                  selectedCondition.showCriteriaStart = false;
                  selectedCondition.showCriteriaEnd = false;
                  selectedCondition.showNumberOf = false;
                  selectedCondition.conditionDisplay = '';
                }
                $log.debug('selectedConditionChanged End');
                $log.debug('selectedConditionChanged Result');
                $log.debug(selectedCondition);
                $log.debug(selectedFilterProperty);
              };
              scope.criteriaRangeChanged = function(selectedFilterProperty) {
                var selectedCondition = selectedFilterProperty.selectedCriteriaType;
                if (selectedCondition.dateInfo.type === 'calculation') {
                  var measureCount = selectedFilterProperty.criteriaNumberOf;
                  switch (selectedCondition.dateInfo.measureType) {
                    case 'h':
                      var today = Date.parse('today');
                      selectedFilterProperty.criteriaRangeEnd = today.getTime();
                      var todayXHoursAgo = Date.parse('today').add(-(measureCount)).hours();
                      selectedFilterProperty.criteriaRangeStart = todayXHoursAgo.getTime();
                      break;
                    case 'd':
                      var lastFullDay = Date.parse('today').add(-1).days();
                      lastFullDay.setHours(23, 59, 59, 999);
                      selectedFilterProperty.criteriaRangeEnd = lastFullDay.getTime();
                      var lastXDaysAgo = Date.parse('today').add(-(measureCount)).days();
                      selectedFilterProperty.criteriaRangeStart = lastXDaysAgo.getTime();
                      break;
                    case 'w':
                      var lastFullWeekEnd = Date.today().last().sunday();
                      lastFullWeekEnd.setHours(23, 59, 59, 999);
                      selectedFilterProperty.criteriaRangeEnd = lastFullWeekEnd.getTime();
                      var lastXWeeksAgo = Date.today().last().sunday().add(-(measureCount)).weeks();
                      selectedFilterProperty.criteriaRangeStart = lastXWeeksAgo.getTime();
                      break;
                    case 'm':
                      var lastFullMonthEnd = Date.today().add(-1).months().moveToLastDayOfMonth();
                      lastFullMonthEnd.setHours(23, 59, 59, 999);
                      selectedFilterProperty.criteriaRangeEnd = lastFullMonthEnd.getTime();
                      var lastXMonthsAgo = Date.today().add(-1).months().moveToLastDayOfMonth().add(-(measureCount)).months();
                      selectedFilterProperty.criteriaRangeStart = lastXMonthsAgo.getTime();
                      break;
                    case 'q':
                      var currentQuarter = Math.floor((Date.parse('today').getMonth() / 3));
                      var firstDayOfCurrentQuarter = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
                      var lastDayOfPreviousQuarter = firstDayOfCurrentQuarter.add(-1).days();
                      lastDayOfPreviousQuarter.setHours(23, 59, 59, 999);
                      selectedFilterProperty.criteriaRangeEnd = lastDayOfPreviousQuarter.getTime();
                      var lastXQuartersAgo = new Date(Date.parse('today').getFullYear(), currentQuarter * 3, 1);
                      lastXQuartersAgo.add(-(measureCount * 3)).months();
                      selectedFilterProperty.criteriaRangeStart = lastXQuartersAgo.getTime();
                      break;
                    case 'y':
                      var lastFullYearEnd = new Date(new Date().getFullYear(), 11, 31).add(-1).years();
                      lastFullYearEnd.setHours(23, 59, 59, 999);
                      selectedFilterProperty.criteriaRangeEnd = lastFullYearEnd.getTime();
                      var lastXYearsAgo = new Date(new Date().getFullYear(), 11, 31).add(-(measureCount) - 1).years();
                      selectedFilterProperty.criteriaRangeStart = lastXYearsAgo.getTime();
                      break;
                  }
                }
                if (selectedCondition.dateInfo.type === 'exactDate') {
                  selectedFilterProperty.criteriaRangeStart = selectedFilterProperty.criteriaRangeStart.setHours(0, 0, 0, 0);
                  selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeStart).setHours(23, 59, 59, 999);
                }
                if (selectedCondition.dateInfo.type === 'range') {
                  if (angular.isDefined(selectedFilterProperty.criteriaRangeStart)) {
                    selectedFilterProperty.criteriaRangeStart = new Date(selectedFilterProperty.criteriaRangeStart).setHours(0, 0, 0, 0);
                  }
                  if (angular.isDefined(selectedFilterProperty.criteriaRangeEnd)) {
                    selectedFilterProperty.criteriaRangeEnd = new Date(selectedFilterProperty.criteriaRangeEnd).setHours(23, 59, 59, 999);
                  }
                }
                $log.debug('criteriaRangeChanged');
                $log.debug(selectedCondition);
                $log.debug(selectedFilterProperty);
              };
              break;
            case "big_decimal":
            case "integer":
            case "float":
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
              break;
          }
        }
        if (angular.isDefined(scope.selectedFilterProperty.fieldtype)) {
          switch (scope.selectedFilterProperty.fieldtype) {
            case "many-to-one":
              scope.conditionOptions = getManyToOneOptions(scope.comparisonType);
              $log.debug('many-to-one');
              $log.debug(scope.selectedFilterProperty);
              $log.debug(scope.filterPropertiesList);
              if (angular.isUndefined(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier])) {
                var filterPropertiesPromise = $slatwall.getFilterPropertiesByBaseEntityName(scope.selectedFilterProperty.cfc);
                filterPropertiesPromise.then(function(value) {
                  scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier] = value;
                  metadataService.formatPropertiesList(scope.filterPropertiesList[scope.selectedFilterProperty.propertyIdentifier], scope.selectedFilterProperty.propertyIdentifier);
                }, function(reason) {});
              }
              break;
            case "many-to-many":
            case "one-to-many":
              scope.manyToManyOptions = getManyToManyOptions();
              scope.oneToManyOptions = getOneToManyOptions();
              var existingCollectionsPromise = $slatwall.getExistingCollectionsByBaseEntity(selectedFilterProperty.cfc);
              existingCollectionsPromise.then(function(value) {
                scope.collectionOptions = value.data;
                if (angular.isDefined(scope.workflowCondition.collectionID)) {
                  for (var i in scope.collectionOptions) {
                    if (scope.collectionOptions[i].collectionID === scope.workflowCondition.collectionID) {
                      scope.selectedFilterProperty.selectedCollection = scope.collectionOptions[i];
                    }
                  }
                  for (var i in scope.oneToManyOptions) {
                    if (scope.oneToManyOptions[i].comparisonOperator === scope.workflowCondition.criteria) {
                      scope.selectedFilterProperty.selectedCriteriaType = scope.oneToManyOptions[i];
                    }
                  }
                }
              });
              break;
          }
        }
        $log.debug('workflowCondition');
        $log.debug(scope.workflowCondition);
        angular.forEach(scope.conditionOptions, function(conditionOption) {
          if (conditionOption.display == scope.workflowCondition.conditionDisplay) {
            scope.selectedFilterProperty.selectedCriteriaType = conditionOption;
            scope.selectedFilterProperty.criteriaValue = scope.workflowCondition.value;
            if (angular.isDefined(scope.selectedFilterProperty.selectedCriteriaType.dateInfo) && angular.isDefined(scope.workflowCondition.value) && scope.workflowCondition.value.length) {
              var dateRangeArray = scope.workflowCondition.value.split("-");
              scope.selectedFilterProperty.criteriaRangeStart = new Date(parseInt(dateRangeArray[0]));
              scope.selectedFilterProperty.criteriaRangeEnd = new Date(parseInt(dateRangeArray[1]));
            }
            if (angular.isDefined(scope.workflowCondition.criteriaNumberOf)) {
              scope.selectedFilterProperty.criteriaNumberOf = scope.workflowCondition.criteriaNumberOf;
            }
            if (angular.isDefined(scope.selectedConditionChanged)) {
              scope.selectedConditionChanged(scope.selectedFilterProperty);
            }
          }
        });
        $log.debug('templateLoader');
        $log.debug(selectedFilterProperty);
        var templateLoader = getTemplate(selectedFilterProperty);
        var promise = templateLoader.success(function(html) {
          element.html(html);
          $compile(element.contents())(scope);
        });
      }
    });
    scope.selectedCriteriaChanged = function(selectedCriteria) {
      $log.debug(selectedCriteria);
      $log.debug(scope.selectedFilterProperty);
      var breadCrumb = {
        entityAlias: scope.selectedFilterProperty.name,
        cfc: scope.selectedFilterProperty.cfc,
        propertyIdentifier: scope.selectedFilterProperty.propertyIdentifier
      };
      scope.workflowCondition.breadCrumbs.push(breadCrumb);
      scope.selectedFilterPropertyChanged({selectedFilterProperty: scope.selectedFilterProperty.selectedCriteriaType});
    };
  };
  return {
    restrict: 'A',
    scope: {
      workflowCondition: "=",
      selectedFilterProperty: "=",
      filterPropertiesList: "=",
      selectedFilterPropertyChanged: "&"
    },
    link: linker
  };
}]);

//# sourceMappingURL=../../directives/collection/swconditioncriteria.js.map