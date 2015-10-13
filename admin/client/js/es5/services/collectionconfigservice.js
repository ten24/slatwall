var slatwalladmin;
(function (slatwalladmin) {
    var Column = (function () {
        function Column(propertyIdentifier, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, attributeID, attributeSetObject) {
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
                    allRecords: _this.allRecords
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
            /*TODO: CLEAN THIS FUNCTION */
            this.formatCollectionName = function (propertyIdentifier, property) {
                if (property === void 0) { property = true; }
                var collection = '', parts = propertyIdentifier.split('.'), current_collection = _this.collection;
                for (var i = 0; i < parts.length; i++) {
                    if (typeof _this.$slatwall['new' + _this.capitalize(parts[i])] !== "function") {
                        if (property)
                            collection += ((i) ? '' : _this.baseEntityAlias) + '.' + parts[i];
                        if (!angular.isObject(current_collection.metaData[parts[i]])) {
                            break;
                        }
                        else if (current_collection.metaData[parts[i]].fkcolumn) {
                            current_collection = _this.$slatwall['new' + current_collection.metaData[parts[i]].cfc]();
                        }
                    }
                    else {
                        if (angular.isObject(current_collection.metaData[parts[i]])) {
                            collection += ((i) ? '' : _this.baseEntityAlias) + '.' + parts[i];
                            current_collection = _this.$slatwall['new' + _this.capitalize(parts[i])]();
                        }
                        else {
                            collection += '_' + parts[i].toLowerCase();
                        }
                    }
                }
                return collection;
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
            this.capitalize = function (s) {
                return s && s[0].toUpperCase() + s.slice(1);
            };
            this.addColumn = function (column, title, options) {
                if (title === void 0) { title = ''; }
                if (options === void 0) { options = {}; }
                var isVisible = true, isDeletable = true, isSearchable = true, isExportable = true, persistent, ormtype = 'string', lastProperty = column.split('.').pop();
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
                else if (_this.collection.metaData[lastProperty] && _this.collection.metaData[lastProperty].ormtype) {
                    ormtype = _this.collection.metaData[lastProperty].ormtype;
                }
                if (angular.isDefined(_this.collection.metaData[lastProperty])) {
                    persistent = _this.collection.metaData[lastProperty].persistent;
                }
                var columnObject = new Column(column, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, options['attributeID'], options['attributeSetObject']);
                if (options.aggregate) {
                    columnObject.aggregate = options.aggregate;
                }
                //add any non-conventional options
                for (key in options) {
                    if (!columnObject[key]) {
                        columnObject[key] = options[key];
                    }
                }
                _this.columns.push(columnObject);
            };
            this.setDisplayProperties = function (propertyIdentifier, title, options) {
                if (title === void 0) { title = ''; }
                if (options === void 0) { options = {}; }
                var _DividedColumns = propertyIdentifier.trim().split(',');
                var _DividedTitles = title.trim().split(',');
                _DividedColumns.forEach(function (column, index) {
                    column = column.trim();
                    //this.addJoin(column);
                    if (!angular.isUndefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                        title = _DividedTitles[index].trim();
                    }
                    else {
                        title = _this.$slatwall.getRBKey("entity." + _this.baseEntityName + "." + column);
                    }
                    _this.addColumn(_this.formatCollectionName(column), title, options);
                });
            };
            this.addDisplayAggregate = function (propertyIdentifier, aggregateFunction, aggregateAlias) {
                var alias = _this.baseEntityAlias;
                var doJoin = false;
                var collection = propertyIdentifier;
                var propertyKey = '';
                if (propertyIdentifier.indexOf('.') !== -1) {
                    collection = _this.utilityService.mid(propertyIdentifier, 0, propertyIdentifier.lastIndexOf('.'));
                    propertyKey = '.' + _this.utilityService.listLast(propertyIdentifier, '.');
                }
                var column = {
                    propertyIdentifier: alias + '.' + propertyIdentifier,
                    aggregate: {
                        aggregateFunction: aggregateFunction,
                        aggregateAlias: aggregateAlias
                    }
                };
                var isObject = _this.$slatwall.getPropertyIsObjectByEntityNameAndPropertyIdentifier(_this.baseEntityName, propertyIdentifier);
                if (isObject) {
                    //check if count is on a one-to-many
                    var lastEntityName = _this.$slatwall.getLastEntityNameInPropertyIdentifier(_this.baseEntityName, propertyIdentifier);
                    var propertyMetaData = _this.$slatwall.getEntityMetaData(lastEntityName)[_this.utilityService.listLast(propertyIdentifier, '.')];
                    var isOneToMany = angular.isDefined(propertyMetaData['singularname']);
                    //if is a one-to-many propertyKey then add a groupby
                    if (isOneToMany) {
                        _this.addGroupBy(alias);
                    }
                    column.propertyIdentifier = _this.buildPropertyIdentifier(alias, propertyIdentifier);
                    var join = new Join(propertyIdentifier, column.propertyIdentifier);
                    doJoin = true;
                }
                else {
                    column.propertyIdentifier = _this.buildPropertyIdentifier(alias, collection) + propertyKey;
                    var join = new Join(collection, _this.buildPropertyIdentifier(alias, collection));
                    doJoin = true;
                }
                //Add columns
                _this.addColumn(column.propertyIdentifier, undefined, column);
                if (doJoin) {
                    _this.addJoin(join);
                }
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
                    //this.addJoin(column);
                    if (!angular.isUndefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                        title = _DividedTitles[index].trim();
                    }
                    else {
                        title = _this.$slatwall.getRBKey("entity." + _this.baseEntityName + "." + column);
                    }
                    _this.addColumn(_this.formatCollectionName(column), title, options);
                });
            };
            this.addFilter = function (propertyIdentifier, value, comparisonOperator, logicalOperator) {
                if (comparisonOperator === void 0) { comparisonOperator = '='; }
                console.log('addFilter');
                console.log(propertyIdentifier);
                var alias = _this.baseEntityAlias;
                var join;
                var doJoin = false;
                //if filterGroups does not exists then set a default
                if (!_this.filterGroups) {
                    _this.filterGroups = [{ filterGroup: [] }];
                }
                var collection = propertyIdentifier;
                var propertyKey = '.' + _this.utilityService.listLast(propertyIdentifier, '.');
                console.log(propertyKey);
                //if the propertyIdenfifier is a chain
                if (propertyIdentifier.indexOf('.') !== -1) {
                    collection = _this.utilityService.mid(propertyIdentifier, 0, propertyIdentifier.lastIndexOf('.'));
                    propertyKey = '.' + _this.utilityService.listLast(propertyIdentifier, '.');
                }
                console.log(collection);
                console.log(propertyKey);
                //create filter group
                var filter = new Filter(_this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator, propertyIdentifier.split('.').pop(), value);
                var isObject = _this.$slatwall.getPropertyIsObjectByEntityNameAndPropertyIdentifier(_this.baseEntityName, propertyIdentifier);
                if (isObject) {
                    filter.propertyIdentifier = _this.buildPropertyIdentifier(alias, propertyIdentifier);
                    join = new Join(propertyIdentifier, _this.buildPropertyIdentifier(alias, propertyIdentifier));
                    doJoin = true;
                }
                else {
                    filter.propertyIdentifier = _this.buildPropertyIdentifier(alias, collection) + propertyKey;
                    join = new Join(collection, _this.buildPropertyIdentifier(alias, collection));
                    doJoin = true;
                }
                //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
                if (_this.filterGroups[0].filterGroup.length && !logicalOperator)
                    logicalOperator = 'AND';
                _this.filterGroups[0].filterGroup.push(filter);
                if (doJoin) {
                    _this.addJoin(join);
                }
            };
            this.buildPropertyIdentifier = function (alias, propertyIdentifier, joinChar) {
                if (joinChar === void 0) { joinChar = '_'; }
                return alias + joinChar + _this.utilityService.replaceAll(propertyIdentifier, '.', '_');
            };
            this.addCollectionFilter = function (propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly) {
                if (criteria === void 0) { criteria = 'One'; }
                if (readOnly === void 0) { readOnly = false; }
                _this.filterGroups[0].filterGroup.push(new CollectionFilter(_this.formatCollectionName(propertyIdentifier), displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly));
            };
            this.setOrderBy = function (propertyIdentifier, direction) {
                if (direction === void 0) { direction = 'DESC'; }
                if (angular.isUndefined(_this.orderBy)) {
                    _this.orderBy = [];
                }
                _this.addJoin(propertyIdentifier);
                _this.orderBy.push(new OrderBy(_this.formatCollectionName(propertyIdentifier), direction));
            };
            this.setCurrentPage = function (pageNumber) {
                _this.currentPage = pageNumber;
            };
            this.setPageShow = function (NumberOfPages) {
                _this.pageShow = NumberOfPages;
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
            this.getEntity = function (id) {
                if (angular.isDefined(id)) {
                    _this.setId(id);
                }
                return _this.$slatwall.getEntity(_this.baseEntityName, _this.getOptions());
            };
            console.log('collectionConfigtest');
            console.log(this);
            if (angular.isDefined(this.baseEntityName)) {
                this.collection = this.$slatwall['new' + this.getEntityName()]();
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

//# sourceMappingURL=../services/collectionconfigservice.js.map