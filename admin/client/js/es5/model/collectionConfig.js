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
        function Filter(propertyIdentifier, value, comparisonOperator, logicalOperator) {
            this.propertyIdentifier = propertyIdentifier;
            this.value = value;
            this.comparisonOperator = comparisonOperator;
            this.logicalOperator = logicalOperator;
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
        function CollectionConfig($slatwall, baseEntityName, baseEntityAlias, columns, filterGroups, joins, orderBy, id, currentPage, pageShow, keywords, defaultColumns) {
            var _this = this;
            if (filterGroups === void 0) { filterGroups = [{ filterGroup: [] }]; }
            if (currentPage === void 0) { currentPage = 1; }
            if (pageShow === void 0) { pageShow = 10; }
            if (keywords === void 0) { keywords = ''; }
            if (defaultColumns === void 0) { defaultColumns = false; }
            this.$slatwall = $slatwall;
            this.baseEntityName = baseEntityName;
            this.baseEntityAlias = baseEntityAlias;
            this.columns = columns;
            this.filterGroups = filterGroups;
            this.joins = joins;
            this.orderBy = orderBy;
            this.id = id;
            this.currentPage = currentPage;
            this.pageShow = pageShow;
            this.keywords = keywords;
            this.defaultColumns = defaultColumns;
            this.loadJson = function (jsonCollection) {
                //if json then make a javascript object else use the javascript object
                if (angular.isString(jsonCollection)) {
                    jsonCollection = angular.fromJson(jsonCollection);
                }
                _this.baseEntityAlias = jsonCollection.baseEntityAlias;
                _this.baseEntityName = jsonCollection.baseEntityName;
                _this.columns = jsonCollection.columns;
                _this.currentPage = jsonCollection.currentPage;
                _this.filterGroups = jsonCollection.filterGroups;
                _this.joins = jsonCollection.joins;
                _this.keywords = jsonCollection.keywords;
                _this.orderBy = jsonCollection.orderBy;
                _this.pageShow = jsonCollection.pageShow;
                _this.defaultColumns = jsonCollection.defaultColumns;
            };
            this.getCollectionConfig = function () {
                return {
                    baseEntityAlias: _this.baseEntityAlias,
                    baseEntityName: _this.baseEntityName,
                    columns: _this.columns,
                    filterGroups: _this.filterGroups,
                    joins: _this.joins,
                    currentPage: _this.currentPage,
                    pageShow: _this.pageShow,
                    keywords: _this.keywords,
                    defaultColumns: _this.defaultColumns
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
                    currentPage: _this.currentPage,
                    pageShow: _this.pageShow,
                    keywords: _this.keywords,
                    defaultColumns: _this.defaultColumns
                };
                if (angular.isDefined(_this.id)) {
                    options['id'] = _this.id;
                }
                return options;
            };
            this.debug = function () {
                return _this;
            };
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
                    }
                    else {
                        if (angular.isObject(current_collection.metaData[parts[i]])) {
                            collection += ((i) ? '' : _this.baseEntityAlias + '.') + parts[i];
                            current_collection = _this.$slatwall['new' + _this.capitalize(parts[i])]();
                        }
                        else {
                            collection += '_' + parts[i].toLowerCase();
                        }
                    }
                }
                return collection;
            };
            this.addJoin = function (associationName) {
                var joinFound = false, parts = associationName.split('.'), collection = '';
                if (angular.isUndefined(_this.joins)) {
                    _this.joins = [];
                }
                for (var i = 0; i < parts.length; i++) {
                    joinFound = false;
                    if (typeof _this.$slatwall['new' + _this.capitalize(parts[i])] !== "function")
                        break;
                    collection += '.' + parts[i];
                    _this.joins.map(function (_join) {
                        if (_join.associationName == collection.slice(1)) {
                            joinFound = true;
                            return;
                        }
                    });
                    if (!joinFound) {
                        _this.joins.push(new Join(collection.slice(1), collection.toLowerCase().replace(/\./g, '_')));
                    }
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
                _this.columns.push(new Column(column, title, isVisible, isDeletable, isSearchable, isExportable, ormtype, options['attributeID'], options['attributeSetObject']));
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
            this.addFilter = function (propertyIdentifier, value, comparisonOperator, logicalOperator) {
                if (comparisonOperator === void 0) { comparisonOperator = '='; }
                //this.addJoin(propertyIdentifier);
                if (_this.filterGroups[0].filterGroup.length && !logicalOperator)
                    logicalOperator = 'AND';
                _this.filterGroups[0].filterGroup.push(new Filter(_this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator));
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
            this.setKeywords = function (keyword) {
                _this.keywords = keyword;
            };
            this.useDefaultColumns = function (flag) {
                if (flag === void 0) { flag = true; }
                _this.defaultColumns = flag;
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
            if (!angular.isUndefined(this.baseEntityName)) {
                this.collection = this.$slatwall['new' + this.getEntityName()]();
                if (angular.isUndefined(this.baseEntityAlias)) {
                    this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
                }
            }
        }
        return CollectionConfig;
    })();
    slatwalladmin.CollectionConfig = CollectionConfig;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/collectionConfig.js.map