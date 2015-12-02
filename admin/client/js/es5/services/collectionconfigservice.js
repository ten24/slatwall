var slatwalladmin;
(function (slatwalladmin) {
    var Column = (function () {
        function Column(propertyIdentifier, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, attributeID, attributeSetObject) {
            if (isVisible === void 0) { isVisible = true; }
            if (isDeletable === void 0) { isDeletable = true; }
            if (isSearchable === void 0) { isSearchable = true; }
            if (isExportable === void 0) { isExportable = true; }
            this.propertyIdentifier = propertyIdentifier;
            this.title = title;
            this.isVisible = isVisible;
            this.isDeletable = isDeletable;
            this.isSearchable = isSearchable;
            this.isExportable = isExportable;
            this.persistent = persistent;
            this.ormtype = ormtype;
            this.attributeID = attributeID;
            this.attributeSetObject = attributeSetObject;
        }
        return Column;
    })();
    var Filter = (function () {
        function Filter(propertyIdentifier, value, comparisonOperator, logicalOperator, displayPropertyIdentifier, displayValue) {
            this.propertyIdentifier = propertyIdentifier;
            this.value = value;
            this.comparisonOperator = comparisonOperator;
            this.logicalOperator = logicalOperator;
            this.displayPropertyIdentifier = displayPropertyIdentifier;
            this.displayValue = displayValue;
        }
        return Filter;
    })();
    var CollectionFilter = (function () {
        function CollectionFilter(propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly) {
            if (readOnly === void 0) { readOnly = false; }
            this.propertyIdentifier = propertyIdentifier;
            this.displayPropertyIdentifier = displayPropertyIdentifier;
            this.displayValue = displayValue;
            this.collectionID = collectionID;
            this.criteria = criteria;
            this.fieldtype = fieldtype;
            this.readOnly = readOnly;
        }
        return CollectionFilter;
    })();
    var Join = (function () {
        function Join(associationName, alias) {
            this.associationName = associationName;
            this.alias = alias;
        }
        return Join;
    })();
    slatwalladmin.Join = Join;
    var OrderBy = (function () {
        function OrderBy(propertyIdentifier, direction) {
            this.propertyIdentifier = propertyIdentifier;
            this.direction = direction;
        }
        return OrderBy;
    })();
    var CollectionConfig = (function () {
        function CollectionConfig($slatwall, utilityService, baseEntityName, baseEntityAlias, columns, filterGroups, joins, orderBy, groupBys, id, currentPage, pageShow, keywords, allRecords) {
            var _this = this;
            if (filterGroups === void 0) { filterGroups = [{ filterGroup: [] }]; }
            if (currentPage === void 0) { currentPage = 1; }
            if (pageShow === void 0) { pageShow = 10; }
            if (keywords === void 0) { keywords = ''; }
            if (allRecords === void 0) { allRecords = false; }
            this.$slatwall = $slatwall;
            this.utilityService = utilityService;
            this.baseEntityName = baseEntityName;
            this.baseEntityAlias = baseEntityAlias;
            this.columns = columns;
            this.filterGroups = filterGroups;
            this.joins = joins;
            this.orderBy = orderBy;
            this.groupBys = groupBys;
            this.id = id;
            this.currentPage = currentPage;
            this.pageShow = pageShow;
            this.keywords = keywords;
            this.allRecords = allRecords;
            this.clearFilterGroups = function () {
                _this.filterGroups = [{ filterGroup: [] }];
            };
            this.newCollectionConfig = function (baseEntityName, baseEntityAlias) {
                return new CollectionConfig(_this.$slatwall, _this.utilityService, baseEntityName, baseEntityAlias);
            };
            this.loadJson = function (jsonCollection) {
                //if json then make a javascript object else use the javascript object
                if (angular.isString(jsonCollection)) {
                    jsonCollection = angular.fromJson(jsonCollection);
                }
                _this.baseEntityAlias = jsonCollection.baseEntityAlias;
                _this.baseEntityName = jsonCollection.baseEntityName;
                if (angular.isDefined(jsonCollection.filterGroups)) {
                    _this.filterGroups = jsonCollection.filterGroups;
                }
                _this.columns = jsonCollection.columns;
                _this.joins = jsonCollection.joins;
                _this.keywords = jsonCollection.keywords;
                _this.orderBy = jsonCollection.orderBy;
                _this.groupBys = jsonCollection.groupBys;
                _this.pageShow = jsonCollection.pageShow;
                _this.allRecords = jsonCollection.allRecords;
            };
            this.loadFilterGroups = function (filterGroupsConfig) {
                if (filterGroupsConfig === void 0) { filterGroupsConfig = [{ filterGroup: [] }]; }
                _this.filterGroups = filterGroupsConfig;
            };
            this.loadColumns = function (columns) {
                _this.columns = columns;
            };
            this.getCollectionConfig = function () {
                return {
                    baseEntityAlias: _this.baseEntityAlias,
                    baseEntityName: _this.baseEntityName,
                    columns: _this.columns,
                    filterGroups: _this.filterGroups,
                    joins: _this.joins,
                    groupBys: _this.groupBys,
                    currentPage: _this.currentPage,
                    pageShow: _this.pageShow,
                    keywords: _this.keywords,
                    defaultColumns: (!_this.columns || !_this.columns.length),
                    allRecords: _this.allRecords,
                };
            };
            this.getEntityName = function () {
                return _this.baseEntityName.charAt(0).toUpperCase() + _this.baseEntityName.slice(1);
            };
            this.getOptions = function () {
                var options = {
                    columnsConfig: angular.toJson(_this.columns),
                    filterGroupsConfig: angular.toJson(_this.filterGroups),
                    joinsConfig: angular.toJson(_this.joins),
                    orderByConfig: angular.toJson(_this.orderBy),
                    groupBysConfig: angular.toJson(_this.groupBys),
                    currentPage: _this.currentPage,
                    pageShow: _this.pageShow,
                    keywords: _this.keywords,
                    defaultColumns: (!_this.columns || !_this.columns.length),
                    allRecords: _this.allRecords
                };
                if (angular.isDefined(_this.id)) {
                    options['id'] = _this.id;
                }
                return options;
            };
            this.debug = function () {
                return _this;
            };
            this.formatPropertyIdentifier = function (propertyIdentifier, addJoin) {
                if (addJoin === void 0) { addJoin = false; }
                var _propertyIdentifier = _this.baseEntityAlias;
                if (addJoin === true) {
                    _propertyIdentifier += _this.processJoin(propertyIdentifier);
                }
                else {
                    _propertyIdentifier += '.' + propertyIdentifier;
                }
                return _propertyIdentifier;
            };
            this.processJoin = function (propertyIdentifier) {
                var _propertyIdentifier = '', propertyIdentifierParts = propertyIdentifier.split('.'), current_collection = _this.collection;
                for (var i = 0; i < propertyIdentifierParts.length; i++) {
                    if ('cfc' in current_collection.metaData[propertyIdentifierParts[i]]) {
                        current_collection = _this.$slatwall.getEntityExample(current_collection.metaData[propertyIdentifierParts[i]].cfc);
                        _propertyIdentifier += '_' + propertyIdentifierParts[i];
                        _this.addJoin(new Join(_propertyIdentifier.replace(/_/g, '.').substring(1), _this.baseEntityAlias + _propertyIdentifier));
                    }
                    else {
                        _propertyIdentifier += '.' + propertyIdentifierParts[i];
                    }
                }
                return _propertyIdentifier;
            };
            this.addJoin = function (join) {
                if (!_this.joins) {
                    _this.joins = [];
                }
                var joinFound = false;
                angular.forEach(_this.joins, function (configJoin) {
                    if (configJoin.alias === join.alias) {
                        joinFound = true;
                    }
                });
                if (!joinFound) {
                    _this.joins.push(join);
                }
            };
            this.addAlias = function (propertyIdentifier) {
                var parts = propertyIdentifier.split('.');
                if (parts.length > 1 && parts[0] !== _this.baseEntityAlias) {
                    return _this.baseEntityAlias + '.' + propertyIdentifier;
                }
                return propertyIdentifier;
            };
            this.addColumn = function (column, title, options) {
                if (title === void 0) { title = ''; }
                if (options === void 0) { options = {}; }
                if (!_this.columns || _this.utilityService.ArrayFindByPropertyValue(_this.columns, 'propertyIdentifier', column) === -1) {
                    var isVisible = true, isDeletable = true, isSearchable = true, isExportable = true, persistent, ormtype = 'string', lastProperty = column.split('.').pop();
                    var lastEntity = _this.$slatwall.getEntityExample(_this.$slatwall.getLastEntityNameInPropertyIdentifier(_this.baseEntityName, column));
                    if (angular.isUndefined(_this.columns)) {
                        _this.columns = [];
                    }
                    if (!angular.isUndefined(options['isVisible'])) {
                        isVisible = options['isVisible'];
                    }
                    if (!angular.isUndefined(options['isDeletable'])) {
                        isDeletable = options['isDeletable'];
                    }
                    if (!angular.isUndefined(options['isSearchable'])) {
                        isSearchable = options['isSearchable'];
                    }
                    if (!angular.isUndefined(options['isExportable'])) {
                        isExportable = options['isExportable'];
                    }
                    if (angular.isUndefined(options['isExportable']) && !isVisible) {
                        isExportable = false;
                    }
                    if (!angular.isUndefined(options['ormtype'])) {
                        ormtype = options['ormtype'];
                    }
                    else if (lastEntity.metaData[lastProperty] && lastEntity.metaData[lastProperty].ormtype) {
                        ormtype = lastEntity.metaData[lastProperty].ormtype;
                    }
                    if (angular.isDefined(lastEntity[lastProperty])) {
                        persistent = lastEntity[lastProperty].persistent;
                    }
                    var columnObject = new Column(column, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, options['attributeID'], options['attributeSetObject']);
                    if (options['aggregate']) {
                        columnObject['aggregate'] = options['aggregate'],
                            columnObject['aggregateAlias'] = title;
                    }
                    //add any non-conventional options
                    for (var key in options) {
                        if (!columnObject[key]) {
                            columnObject[key] = options[key];
                        }
                    }
                    _this.columns.push(columnObject);
                }
            };
            this.setDisplayProperties = function (propertyIdentifier, title, options) {
                if (title === void 0) { title = ''; }
                if (options === void 0) { options = {}; }
                _this.addDisplayProperty = (propertyIdentifier, title, options);
            };
            this.addDisplayAggregate = function (propertyIdentifier, aggregateFunction, aggregateAlias, options) {
                var column = {
                    propertyIdentifier: _this.formatPropertyIdentifier(propertyIdentifier, true),
                    title: _this.$slatwall.getRBKey("entity." + _this.baseEntityName + "." + propertyIdentifier),
                    aggregate: {
                        aggregateFunction: aggregateFunction,
                        aggregateAlias: aggregateAlias
                    }
                };
                angular.extend(column, options);
                //Add columns
                _this.addColumn(column.propertyIdentifier, undefined, column);
            };
            this.addGroupBy = function (groupByAlias) {
                if (!_this.groupBys) {
                    _this.groupBys = '';
                }
                _this.groupBys = _this.utilityService.listAppend(_this.groupBys, groupByAlias);
            };
            this.addDisplayProperty = function (propertyIdentifier, title, options) {
                if (title === void 0) { title = ''; }
                if (options === void 0) { options = {}; }
                var _DividedColumns = propertyIdentifier.trim().split(',');
                var _DividedTitles = title.trim().split(',');
                _DividedColumns.forEach(function (column, index) {
                    column = column.trim();
                    if (angular.isDefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                        title = _DividedTitles[index].trim();
                    }
                    else {
                        title = _this.$slatwall.getRBKey("entity." + _this.baseEntityName + "." + column);
                    }
                    _this.addColumn(_this.formatPropertyIdentifier(column), title, options);
                });
            };
            this.addFilter = function (propertyIdentifier, value, comparisonOperator, logicalOperator) {
                if (comparisonOperator === void 0) { comparisonOperator = '='; }
                //if filterGroups does not exists then set a default
                if (!_this.filterGroups) {
                    _this.filterGroups = [{ filterGroup: [] }];
                }
                //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
                if (_this.filterGroups[0].filterGroup.length && !logicalOperator)
                    logicalOperator = 'AND';
                //create filter group
                var filter = new Filter(_this.formatPropertyIdentifier(propertyIdentifier, true), value, comparisonOperator, logicalOperator, propertyIdentifier.split('.').pop(), value);
                _this.filterGroups[0].filterGroup.push(filter);
            };
            this.addCollectionFilter = function (propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly) {
                if (criteria === void 0) { criteria = 'One'; }
                if (readOnly === void 0) { readOnly = false; }
                _this.filterGroups[0].filterGroup.push(new CollectionFilter(_this.formatPropertyIdentifier(propertyIdentifier), displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly));
            };
            //orderByList in this form: "property|direction" concrete: "skuName|ASC"
            this.setOrderBy = function (orderByList) {
                var orderBys = orderByList.split(',');
                angular.forEach(orderBys, function (orderBy) {
                    _this.addOrderBy(orderBy);
                });
            };
            this.addOrderBy = function (orderByString) {
                if (!_this.orderBy) {
                    _this.orderBy = [];
                }
                var propertyIdentifier = _this.utilityService.listFirst(orderByString, '|');
                var direction = _this.utilityService.listLast(orderByString, '|');
                var orderBy = {
                    propertyIdentifier: _this.formatPropertyIdentifier(propertyIdentifier),
                    direction: direction
                };
                _this.orderBy.push(orderBy);
            };
            this.setCurrentPage = function (pageNumber) {
                _this.currentPage = pageNumber;
            };
            this.setPageShow = function (NumberOfPages) {
                _this.pageShow = NumberOfPages;
            };
            this.getPageShow = function () {
                return _this.pageShow;
            };
            this.setAllRecords = function (allFlag) {
                if (allFlag === void 0) { allFlag = false; }
                _this.allRecords = allFlag;
            };
            this.setKeywords = function (keyword) {
                _this.keywords = keyword;
            };
            this.setId = function (id) {
                _this.id = id;
            };
            this.hasFilters = function () {
                return (_this.filterGroups.length && _this.filterGroups[0].filterGroup.length);
            };
            this.clearFilters = function () {
                _this.filterGroups = [{ filterGroup: [] }];
            };
            this.getEntity = function (id) {
                if (angular.isDefined(id)) {
                    _this.setId(id);
                }
                return _this.$slatwall.getEntity(_this.baseEntityName, _this.getOptions());
            };
            if (angular.isDefined(this.baseEntityName)) {
                this.collection = this.$slatwall.getEntityExample(this.baseEntityName);
                if (angular.isUndefined(this.baseEntityAlias)) {
                    this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
                }
            }
        }
        CollectionConfig.$inject = ['$slatwall', 'utilityService'];
        return CollectionConfig;
    })();
    slatwalladmin.CollectionConfig = CollectionConfig;
    angular.module('slatwalladmin')
        .factory('collectionConfigService', ['$slatwall', 'utilityService', function ($slatwall, utilityService) { return new CollectionConfig($slatwall, utilityService); }]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=collectionconfigservice.js.map
