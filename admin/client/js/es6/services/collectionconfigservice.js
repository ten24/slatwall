var slatwalladmin;
(function (slatwalladmin) {
    class Column {
        constructor(propertyIdentifier, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, attributeID, attributeSetObject) {
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
    }
    class Filter {
        constructor(propertyIdentifier, value, comparisonOperator, logicalOperator, displayPropertyIdentifier, displayValue) {
            this.propertyIdentifier = propertyIdentifier;
            this.value = value;
            this.comparisonOperator = comparisonOperator;
            this.logicalOperator = logicalOperator;
            this.displayPropertyIdentifier = displayPropertyIdentifier;
            this.displayValue = displayValue;
        }
    }
    class CollectionFilter {
        constructor(propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly = false) {
            this.propertyIdentifier = propertyIdentifier;
            this.displayPropertyIdentifier = displayPropertyIdentifier;
            this.displayValue = displayValue;
            this.collectionID = collectionID;
            this.criteria = criteria;
            this.fieldtype = fieldtype;
            this.readOnly = readOnly;
        }
    }
    class Join {
        constructor(associationName, alias) {
            this.associationName = associationName;
            this.alias = alias;
        }
    }
    class OrderBy {
        constructor(propertyIdentifier, direction) {
            this.propertyIdentifier = propertyIdentifier;
            this.direction = direction;
        }
    }
    class CollectionConfig {
        constructor($slatwall, baseEntityName, baseEntityAlias, columns, filterGroups = [{ filterGroup: [] }], joins, orderBy, id, currentPage = 1, pageShow = 10, keywords = '', allRecords = false) {
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
            this.allRecords = allRecords;
            this.newCollectionConfig = (baseEntityName, baseEntityAlias) => {
                return new CollectionConfig(this.$slatwall, baseEntityName, baseEntityAlias);
            };
            this.loadJson = (jsonCollection) => {
                //if json then make a javascript object else use the javascript object
                if (angular.isString(jsonCollection)) {
                    jsonCollection = angular.fromJson(jsonCollection);
                }
                this.baseEntityAlias = jsonCollection.baseEntityAlias;
                this.baseEntityName = jsonCollection.baseEntityName;
                if (angular.isDefined(jsonCollection.filterGroups)) {
                    this.filterGroups = jsonCollection.filterGroups;
                }
                this.columns = jsonCollection.columns;
                this.joins = jsonCollection.joins;
                this.keywords = jsonCollection.keywords;
                this.orderBy = jsonCollection.orderBy;
                this.pageShow = jsonCollection.pageShow;
                this.allRecords = jsonCollection.allRecords;
            };
            this.getCollectionConfig = () => {
                return {
                    baseEntityAlias: this.baseEntityAlias,
                    baseEntityName: this.baseEntityName,
                    columns: this.columns,
                    filterGroups: this.filterGroups,
                    joins: this.joins,
                    currentPage: this.currentPage,
                    pageShow: this.pageShow,
                    keywords: this.keywords,
                    defaultColumns: (!this.columns || !this.columns.length),
                    allRecords: this.allRecords
                };
            };
            this.getEntityName = () => {
                return this.baseEntityName.charAt(0).toUpperCase() + this.baseEntityName.slice(1);
            };
            this.getOptions = () => {
                var options = {
                    columnsConfig: angular.toJson(this.columns),
                    filterGroupsConfig: angular.toJson(this.filterGroups),
                    joinsConfig: angular.toJson(this.joins),
                    currentPage: this.currentPage,
                    pageShow: this.pageShow,
                    keywords: this.keywords,
                    defaultColumns: (!this.columns || !this.columns.length),
                    allRecords: this.allRecords
                };
                if (angular.isDefined(this.id)) {
                    options['id'] = this.id;
                }
                return options;
            };
            this.debug = () => {
                return this;
            };
            /*TODO: CLEAN THIS FUNCTION */
            this.formatCollectionName = (propertyIdentifier, property = true) => {
                var collection = '', parts = propertyIdentifier.split('.'), current_collection = this.collection;
                for (var i = 0; i < parts.length; i++) {
                    if (typeof this.$slatwall['new' + this.capitalize(parts[i])] !== "function") {
                        if (property)
                            collection += ((i) ? '' : this.baseEntityAlias) + '.' + parts[i];
                        if (!angular.isObject(current_collection.metaData[parts[i]])) {
                            break;
                        }
                        else if (current_collection.metaData[parts[i]].fkcolumn) {
                            current_collection = this.$slatwall['new' + current_collection.metaData[parts[i]].cfc]();
                        }
                    }
                    else {
                        if (angular.isObject(current_collection.metaData[parts[i]])) {
                            collection += ((i) ? '' : this.baseEntityAlias) + '.' + parts[i];
                            current_collection = this.$slatwall['new' + this.capitalize(parts[i])]();
                        }
                        else {
                            collection += '_' + parts[i].toLowerCase();
                        }
                    }
                }
                return collection;
            };
            this.addJoin = (associationName) => {
                var joinFound = false, parts = associationName.split('.'), collection = '';
                if (angular.isUndefined(this.joins)) {
                    this.joins = [];
                }
                for (var i = 0; i < parts.length; i++) {
                    joinFound = false;
                    if (typeof this.$slatwall['new' + this.capitalize(parts[i])] !== "function")
                        break;
                    collection += '.' + parts[i];
                    this.joins.map(function (_join) {
                        if (_join.associationName == collection.slice(1)) {
                            joinFound = true;
                            return;
                        }
                    });
                    if (!joinFound) {
                        this.joins.push(new Join(collection.slice(1), collection.toLowerCase().replace(/\./g, '_')));
                    }
                }
            };
            this.addAlias = (propertyIdentifier) => {
                var parts = propertyIdentifier.split('.');
                if (parts.length > 1 && parts[0] !== this.baseEntityAlias) {
                    return this.baseEntityAlias + '.' + propertyIdentifier;
                }
                return propertyIdentifier;
            };
            this.capitalize = (s) => {
                return s && s[0].toUpperCase() + s.slice(1);
            };
            this.addColumn = (column, title = '', options = {}) => {
                var isVisible = true, isDeletable = true, isSearchable = true, isExportable = true, persistent, ormtype = 'string', lastProperty = column.split('.').pop();
                if (angular.isUndefined(this.columns)) {
                    this.columns = [];
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
                else if (this.collection.metaData[lastProperty] && this.collection.metaData[lastProperty].ormtype) {
                    ormtype = this.collection.metaData[lastProperty].ormtype;
                }
                if (angular.isDefined(this.collection.metaData[lastProperty])) {
                    persistent = this.collection.metaData[lastProperty].persistent;
                }
                this.columns.push(new Column(column, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, options['attributeID'], options['attributeSetObject']));
            };
            this.setDisplayProperties = (propertyIdentifier, title = '', options = {}) => {
                var _DividedColumns = propertyIdentifier.trim().split(',');
                var _DividedTitles = title.trim().split(',');
                _DividedColumns.forEach((column, index) => {
                    column = column.trim();
                    //this.addJoin(column);
                    if (!angular.isUndefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                        title = _DividedTitles[index].trim();
                    }
                    else {
                        title = this.$slatwall.getRBKey("entity." + this.baseEntityName + "." + column);
                    }
                    this.addColumn(this.formatCollectionName(column), title, options);
                });
            };
            this.addFilter = (propertyIdentifier, value, comparisonOperator = '=', logicalOperator) => {
                //this.addJoin(propertyIdentifier);
                if (this.filterGroups[0].filterGroup.length && !logicalOperator)
                    logicalOperator = 'AND';
                this.filterGroups[0].filterGroup.push(new Filter(this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator, propertyIdentifier.split('.').pop(), value));
            };
            this.addCollectionFilter = (propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria = 'One', fieldtype, readOnly = false) => {
                this.filterGroups[0].filterGroup.push(new CollectionFilter(this.formatCollectionName(propertyIdentifier), displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly));
            };
            this.setOrderBy = (propertyIdentifier, direction = 'DESC') => {
                if (angular.isUndefined(this.orderBy)) {
                    this.orderBy = [];
                }
                this.addJoin(propertyIdentifier);
                this.orderBy.push(new OrderBy(this.formatCollectionName(propertyIdentifier), direction));
            };
            this.setCurrentPage = (pageNumber) => {
                this.currentPage = pageNumber;
            };
            this.setPageShow = (NumberOfPages) => {
                this.pageShow = NumberOfPages;
            };
            this.setAllRecords = (allFlag = false) => {
                this.allRecords = allFlag;
            };
            this.setKeywords = (keyword) => {
                this.keywords = keyword;
            };
            this.setId = (id) => {
                this.id = id;
            };
            this.getEntity = (id) => {
                if (angular.isDefined(id)) {
                    this.setId(id);
                }
                return this.$slatwall.getEntity(this.baseEntityName, this.getOptions());
            };
            if (angular.isDefined(this.baseEntityName)) {
                this.collection = this.$slatwall['new' + this.getEntityName()]();
                if (angular.isUndefined(this.baseEntityAlias)) {
                    this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
                }
            }
        }
    }
    slatwalladmin.CollectionConfig = CollectionConfig;
    angular.module('slatwalladmin')
        .factory('CollectionConfigService', ['$slatwall', ($slatwall) => new CollectionConfig($slatwall)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=collectionconfigservice.js.map
