var __extends = (this && this.__extends) || function (d, b) {
    for (var p in b) if (b.hasOwnProperty(p)) d[p] = b[p];
    function __() { this.constructor = d; }
    d.prototype = b === null ? Object.create(b) : (__.prototype = b.prototype, new __());
};
/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />
/*collection service is used to maintain the state of the ui*/
var slatwalladmin;
(function (slatwalladmin) {
    var CollectionService = (function (_super) {
        __extends(CollectionService, _super);
        function CollectionService($filter, $log) {
            var _this = this;
            _super.call(this);
            this.$filter = $filter;
            this.$log = $log;
            this.get = function () {
                return _this._pageDialogs || [];
            };
            //test
            this.setFilterCount = function (count) {
                _this.$log.debug('incrementFilterCount');
                _this._filterCount = count;
            };
            this.getFilterCount = function () {
                return _this._filterCount;
            };
            this.getColumns = function () {
                return _this._collection.collectionConfig.columns;
            };
            this.getFilterPropertiesList = function () {
                return _this._filterPropertiesList;
            };
            this.getFilterPropertiesListByBaseEntityAlias = function (baseEntityAlias) {
                return _this._filterPropertiesList[baseEntityAlias];
            };
            this.setFilterPropertiesList = function (value, key) {
                if (angular.isUndefined(_this._filterPropertiesList[key])) {
                    _this._filterPropertiesList[key] = value;
                }
            };
            this.stringifyJSON = function (jsonObject) {
                var jsonString = angular.toJson(jsonObject);
                return jsonString;
            };
            this.removeFilterItem = function (filterItem, filterGroup) {
                filterGroup.pop(filterGroup.indexOf(filterItem));
            };
            this.selectFilterItem = function (filterItem) {
                if (filterItem.$$isClosed) {
                    for (var i in filterItem.$$siblingItems) {
                        filterItem.$$siblingItems[i].$$isClosed = true;
                        filterItem.$$siblingItems[i].$$disabled = true;
                    }
                    filterItem.$$isClosed = false;
                    filterItem.$$disabled = false;
                    filterItem.setItemInUse(true);
                }
                else {
                    for (var i in filterItem.$$siblingItems) {
                        filterItem.$$siblingItems[i].$$disabled = false;
                    }
                    filterItem.$$isClosed = true;
                    filterItem.setItemInUse(false);
                }
            };
            this.selectFilterGroupItem = function (filterGroupItem) {
                if (filterGroupItem.$$isClosed) {
                    for (var i in filterGroupItem.$$siblingItems) {
                        filterGroupItem.$$siblingItems[i].$$disabled = true;
                    }
                    filterGroupItem.$$isClosed = false;
                    filterGroupItem.$$disabled = false;
                }
                else {
                    for (var i in filterGroupItem.$$siblingItems) {
                        filterGroupItem.$$siblingItems[i].$$disabled = false;
                    }
                    filterGroupItem.$$isClosed = true;
                }
                filterGroupItem.setItemInUse(!filterGroupItem.$$isClosed);
            };
            this.newFilterItem = function (filterItemGroup, setItemInUse, prepareForFilterGroup) {
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
                _this.selectFilterItem(filterItem);
            };
            this.newFilterGroupItem = function (filterItemGroup, setItemInUse) {
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
                _this.selectFilterGroupItem(filterGroupItem);
                _this.newFilterItem(filterGroupItem.filterGroup, setItemInUse);
            };
            this.transplantFilterItemIntoFilterGroup = function (filterGroup, filterItem) {
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
            };
            this.formatFilterPropertiesList = function (filterPropertiesList, propertyIdentifier) {
                _this.$log.debug('format Filter Properties List arguments 2');
                _this.$log.debug(filterPropertiesList);
                _this.$log.debug(propertyIdentifier);
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
                        }
                        else {
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
                filterPropertiesList.data = _this._orderBy(filterPropertiesList.data, ['-$$group', 'propertyIdentifier'], false);
            };
            this.orderBy = function (propertiesList, predicate, reverse) {
                return _this._orderBy(propertiesList, predicate, reverse);
            };
            this.$filter = $filter;
            this.$log = $log;
            this._collection = null;
            this._collectionConfig = null;
            this._filterPropertiesList = {};
            this._filterCount = 0;
            this._orderBy = $filter('orderBy');
        }
        CollectionService.$inject = [
            '$filter', '$log'
        ];
        return CollectionService;
    })(slatwalladmin.BaseService);
    slatwalladmin.CollectionService = CollectionService;
    angular.module('slatwalladmin').service('collectionService', CollectionService);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=collectionservice.js.map
