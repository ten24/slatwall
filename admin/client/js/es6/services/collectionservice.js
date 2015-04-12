"use strict";
'use strict';
angular.module('slatwalladmin').factory('collectionService', ['$filter', '$log', function($filter, $log) {
  var _collection = null;
  var _collectionConfig = null;
  var _filterPropertiesList = {};
  var _filterCount = 0;
  var _orderBy = $filter('orderBy');
  var collectionService = {
    setFilterCount: function(number) {
      $log.debug('incrementFilterCount');
      _filterCount = number;
    },
    getFilterCount: function() {
      return _filterCount;
    },
    getColumns: function() {
      return _collection.collectionConfig.columns;
    },
    getFilterPropertiesList: function() {
      return _filterPropertiesList;
    },
    getFilterPropertiesListByBaseEntityAlias: function(baseEntityAlias) {
      return _filterPropertiesList[baseEntityAlias];
    },
    setFilterPropertiesList: function(value, key) {
      if (angular.isUndefined(_filterPropertiesList[key])) {
        _filterPropertiesList[key] = value;
      }
    },
    stringifyJSON: function(jsonObject) {
      var jsonString = angular.toJson(jsonObject);
      return jsonString;
    },
    removeFilterItem: function(filterItem, filterGroup) {
      filterGroup.pop(filterGroup.indexOf(filterItem));
    },
    selectFilterItem: function(filterItem) {
      if (filterItem.$$isClosed) {
        for (var i in filterItem.$$siblingItems) {
          filterItem.$$siblingItems[i].$$isClosed = true;
          filterItem.$$siblingItems[i].$$disabled = true;
        }
        filterItem.$$isClosed = false;
        filterItem.$$disabled = false;
        filterItem.setItemInUse(true);
      } else {
        for (var i in filterItem.$$siblingItems) {
          filterItem.$$siblingItems[i].$$disabled = false;
        }
        filterItem.$$isClosed = true;
        filterItem.setItemInUse(false);
      }
    },
    selectFilterGroupItem: function(filterGroupItem) {
      if (filterGroupItem.$$isClosed) {
        for (var i in filterGroupItem.$$siblingItems) {
          filterGroupItem.$$siblingItems[i].$$disabled = true;
        }
        filterGroupItem.$$isClosed = false;
        filterGroupItem.$$disabled = false;
      } else {
        for (var i in filterGroupItem.$$siblingItems) {
          filterGroupItem.$$siblingItems[i].$$disabled = false;
        }
        filterGroupItem.$$isClosed = true;
      }
      filterGroupItem.setItemInUse(!filterGroupItem.$$isClosed);
    },
    newFilterItem: function(filterItemGroup, setItemInUse, prepareForFilterGroup) {
      if (angular.isUndefined(prepareForFilterGroup)) {
        prepareForFilterGroup = false;
      }
      var filterItem = {
        displayPropertyIdentifier: "",
        propertyIdentifier: "",
        comparisonOperator: "",
        value: "",
        $$disabled: false,
        $$isClosed: true,
        $$isNew: true,
        $$siblingItems: filterItemGroup,
        setItemInUse: setItemInUse
      };
      if (filterItemGroup.length !== 0) {
        filterItem.logicalOperator = "AND";
      }
      if (prepareForFilterGroup === true) {
        filterItem.$$prepareForFilterGroup = true;
      }
      filterItemGroup.push(filterItem);
      this.selectFilterItem(filterItem);
    },
    newFilterGroupItem: function(filterItemGroup, setItemInUse) {
      var filterGroupItem = {
        filterGroup: [],
        $$disabled: "false",
        $$isClosed: "true",
        $$siblingItems: filterItemGroup,
        $$isNew: "true",
        setItemInUse: setItemInUse
      };
      if (filterItemGroup.length !== 0) {
        filterGroupItem.logicalOperator = "AND";
      }
      filterItemGroup.push(filterGroupItem);
      collectionService.selectFilterGroupItem(filterGroupItem);
      this.newFilterItem(filterGroupItem.filterGroup, setItemInUse);
    },
    transplantFilterItemIntoFilterGroup: function(filterGroup, filterItem) {
      var filterGroupItem = {
        filterGroup: [],
        $$disabled: "false",
        $$isClosed: "true",
        $$isNew: "true"
      };
      if (angular.isDefined(filterItem.logicalOperator)) {
        filterGroupItem.logicalOperator = filterItem.logicalOperator;
        delete filterItem.logicalOperator;
      }
      filterGroupItem.setItemInUse = filterItem.setItemInUse;
      filterGroupItem.$$siblingItems = filterItem.$$siblingItems;
      filterItem.$$siblingItems = [];
      filterGroup.pop(filterGroup.indexOf(filterItem));
      filterItem.$$prepareForFilterGroup = false;
      filterGroupItem.filterGroup.push(filterItem);
      filterGroup.push(filterGroupItem);
    },
    formatFilterPropertiesList: function(filterPropertiesList, propertyIdentifier) {
      $log.debug('format Filter Properties List arguments 2');
      $log.debug(filterPropertiesList);
      $log.debug(propertyIdentifier);
      var simpleGroup = {
        $$group: 'simple',
        displayPropertyIdentifier: '-----------------'
      };
      filterPropertiesList.data.push(simpleGroup);
      var drillDownGroup = {
        $$group: 'drilldown',
        displayPropertyIdentifier: '-----------------'
      };
      filterPropertiesList.data.push(drillDownGroup);
      var compareCollections = {
        $$group: 'compareCollections',
        displayPropertyIdentifier: '-----------------'
      };
      filterPropertiesList.data.push(compareCollections);
      var attributeCollections = {
        $$group: 'attribute',
        displayPropertyIdentifier: '-----------------'
      };
      filterPropertiesList.data.push(attributeCollections);
      for (var i in filterPropertiesList.data) {
        if (angular.isDefined(filterPropertiesList.data[i].ormtype)) {
          if (angular.isDefined(filterPropertiesList.data[i].attributeID)) {
            filterPropertiesList.data[i].$$group = 'attribute';
          } else {
            filterPropertiesList.data[i].$$group = 'simple';
          }
        }
        if (angular.isDefined(filterPropertiesList.data[i].fieldtype)) {
          if (filterPropertiesList.data[i].fieldtype === 'id') {
            filterPropertiesList.data[i].$$group = 'simple';
          }
          if (filterPropertiesList.data[i].fieldtype === 'many-to-one') {
            filterPropertiesList.data[i].$$group = 'drilldown';
          }
          if (filterPropertiesList.data[i].fieldtype === 'many-to-many' || filterPropertiesList.data[i].fieldtype === 'one-to-many') {
            filterPropertiesList.data[i].$$group = 'compareCollections';
          }
        }
        filterPropertiesList.data[i].propertyIdentifier = propertyIdentifier + '.' + filterPropertiesList.data[i].name;
      }
      filterPropertiesList.data = _orderBy(filterPropertiesList.data, ['-$$group', 'propertyIdentifier'], false);
    },
    orderBy: function(propertiesList, predicate, reverse) {
      return _orderBy(propertiesList, predicate, reverse);
    }
  };
  return collectionService;
}]);
