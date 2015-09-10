var slatwalladmin;
(function (slatwalladmin) {
    var Column = (function () {
        function Column(propertyIdentifier, title, isVisible, isDeletable, isSearchable, isExportable, ormtype, attributeID, attributeSetObject) {
            this.propertyIdentifier = propertyIdentifier;
            this.title = title;
            this.isVisible = isVisible;
            this.isDeletable = isDeletable;
            this.isSearchable = isSearchable;
            this.isExportable = isExportable;
            this.ormtype = ormtype;
            this.attributeID = attributeID;
            this.attributeSetObject = attributeSetObject;
            return this;
        }
        Column.prototype.setColumn = function (propertyIdentifier) {
            this.propertyIdentifier = propertyIdentifier;
            return this;
        };
        ;
        Column.prototype.setTitle = function (title) {
            this.title = title;
            return this;
        };
        Column.prototype.setVisible = function (isVisible) {
            this.isVisible = isVisible;
            return this;
        };
        Column.prototype.setDeletable = function (isDeletable) {
            this.isDeletable = isDeletable;
            return this;
        };
        Column.prototype.setSearchable = function (isSearchable) {
            this.isSearchable = isSearchable;
            return this;
        };
        Column.prototype.setExportable = function (isExportable) {
            this.isExportable = isExportable;
            return this;
        };
        Column.prototype.setOrmType = function (ormType) {
            this.ormtype = ormType;
            return this;
        };
        Column.prototype.setAttributeID = function (attributeID) {
            this.attributeID = attributeID;
            return this;
        };
        Column.prototype.setAttributeSetObject = function (attributeSetObject) {
            this.attributeSetObject = attributeSetObject;
            return this;
        };
        return Column;
    })();
    slatwalladmin.Column = Column;
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
                return _this;
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
                return {
                    columnsConfig: angular.toJson(_this.columns),
                    filterGroupsConfig: angular.toJson(_this.filterGroups),
                    joinsConfig: angular.toJson(_this.joins),
                    currentPage: _this.currentPage,
                    pageShow: _this.pageShow,
                    keywords: _this.keywords,
                    defaultColumns: _this.defaultColumns
                };
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
                return _this;
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
                if (!_this.columns) {
                    _this.columns = [];
                }
                if (!angular.isString(column) && !angular.isUndefined(column)) {
                    //using a class column builder.
                    _this.columns.push(column);
                    return _this;
                }
                if (options.isExportable && !options.isVisible) {
                    options.isExportable = false;
                }
                if (!options.ormType && _this.collection.metaData[column] && _this.collection.metaData[column].ormtype) {
                    options.ormType = _this.collection.metaData[column].ormtype;
                }
                _this.columns.push(new Column(column, title, options.isVisible, options.isDeletable, options.isSearchable, options.isExportable, options.ormType, options.attributeID, options.attributeSetObject));
                return _this;
            };
            this.setDisplayProperties = function (propertyIdentifier, title, options) {
                if (title === void 0) { title = ''; }
                if (options === void 0) { options = {}; }
                var _DividedColumns = propertyIdentifier.trim().split(',');
                var _DividedTitles = title.trim().split(',');
                if (_DividedColumns.length > 0) {
                    _DividedColumns.forEach(function (column, index) {
                        column = column.trim();
                        //this.addJoin(column);
                        if (_DividedTitles[index] !== undefined && _DividedTitles[index] != '') {
                            title = _DividedTitles[index].trim();
                        }
                        else {
                            title = _this.$slatwall.getRBKey("entity." + _this.baseEntityName.toLowerCase() + "." + column.toLowerCase());
                        }
                        _this.addColumn(_this.formatCollectionName(column), title, options);
                    });
                }
                else {
                    //this.addJoin(propertyIdentifier);
                    propertyIdentifier = _this.addAlias(propertyIdentifier);
                    if (title == '')
                        title = _this.$slatwall.getRBKey("entity." + _this.baseEntityName.toLowerCase() + "." + propertyIdentifier.toLowerCase());
                    _this.addColumn(_this.formatCollectionName(propertyIdentifier), title, options);
                }
                return _this;
            };
            this.addFilter = function (propertyIdentifier, value, comparisonOperator, logicalOperator) {
                if (comparisonOperator === void 0) { comparisonOperator = '='; }
                //this.addJoin(propertyIdentifier);
                if (_this.filterGroups[0].filterGroup.length && !logicalOperator)
                    logicalOperator = 'AND';
                _this.filterGroups[0].filterGroup.push(new Filter(_this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator));
                return _this;
            };
            this.addCollectionFilter = function (propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly) {
                if (criteria === void 0) { criteria = 'One'; }
                if (readOnly === void 0) { readOnly = false; }
                _this.filterGroups[0].filterGroup.push(new CollectionFilter(_this.formatCollectionName(propertyIdentifier), displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly));
                return _this;
            };
            this.setOrderBy = function (propertyIdentifier, direction) {
                if (direction === void 0) { direction = 'DESC'; }
                if (angular.isUndefined(_this.orderBy)) {
                    _this.orderBy = [];
                }
                _this.addJoin(propertyIdentifier);
                _this.orderBy.push(new OrderBy(_this.formatCollectionName(propertyIdentifier), direction));
                return _this;
            };
            this.setCurrentPage = function (pageNumber) {
                _this.currentPage = pageNumber;
                return _this;
            };
            this.setPageShow = function (NumberOfPages) {
                _this.pageShow = NumberOfPages;
                return _this;
            };
            this.setKeywords = function (keyword) {
                _this.keywords = keyword;
                return _this;
            };
            if (this.baseEntityName) {
                try {
                    this.collection = this.$slatwall['new' + this.getEntityName()]();
                }
                catch (e) {
                    throw "can't instantiate without entity name specified: " + e;
                }
                if (!this.baseEntityAlias) {
                    this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
                }
            }
            return this;
        }
        return CollectionConfig;
    })();
    slatwalladmin.CollectionConfig = CollectionConfig;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/collectionConfig.js.map