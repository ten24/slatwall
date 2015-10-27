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
    slatwalladmin.Join = Join;
    class OrderBy {
        constructor(propertyIdentifier, direction) {
            this.propertyIdentifier = propertyIdentifier;
            this.direction = direction;
        }
    }
    class CollectionConfig {
        constructor($slatwall, utilityService, baseEntityName, baseEntityAlias, columns, filterGroups = [{ filterGroup: [] }], joins, orderBy, groupBys, id, currentPage = 1, pageShow = 10, keywords = '', allRecords = false) {
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
            this.clearFilterGroups = () => {
                this.filterGroups = [{ filterGroup: [] }];
            };
            this.newCollectionConfig = (baseEntityName, baseEntityAlias) => {
                return new CollectionConfig(this.$slatwall, this.utilityService, baseEntityName, baseEntityAlias);
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
                this.groupBys = jsonCollection.groupBys;
                this.pageShow = jsonCollection.pageShow;
                this.allRecords = jsonCollection.allRecords;
            };
            this.loadFilterGroups = (filterGroupsConfig = [{ filterGroup: [] }]) => {
                this.filterGroups = filterGroupsConfig;
            };
            this.loadColumns = (columns) => {
                this.columns = columns;
            };
            this.getCollectionConfig = () => {
                return {
                    baseEntityAlias: this.baseEntityAlias,
                    baseEntityName: this.baseEntityName,
                    columns: this.columns,
                    filterGroups: this.filterGroups,
                    joins: this.joins,
                    groupBys: this.groupBys,
                    currentPage: this.currentPage,
                    pageShow: this.pageShow,
                    keywords: this.keywords,
                    defaultColumns: (!this.columns || !this.columns.length),
                    allRecords: this.allRecords,
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
                    groupBysConfig: angular.toJson(this.groupBys),
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
            this.addJoin = (join) => {
                if (!this.joins) {
                    this.joins = [];
                }
                var joinFound = false;
                angular.forEach(this.joins, (configJoin) => {
                    if (configJoin.alias === join.alias) {
                        joinFound = true;
                    }
                });
                if (!joinFound) {
                    this.joins.push(join);
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
            this.addColumn = (column) => {
                if (!this.columns || this.utilityService.ArrayFindByPropertyValue(this.columns, 'propertyIdentifier', column.propertyIdentifier) === -1) {
                    this.addColumn(column.propertyIdentifier, column.title, column);
                }
            };
            this.addColumn = (column, title = '', options = {}) => {
                if (!this.columns || this.utilityService.ArrayFindByPropertyValue(this.columns, 'propertyIdentifier', column) === -1) {
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
                    var columnObject = new Column(column, title, isVisible, isDeletable, isSearchable, isExportable, persistent, ormtype, options['attributeID'], options['attributeSetObject']);
                    if (options.aggregate) {
                        columnObject.aggregate = options.aggregate;
                    }
                    //add any non-conventional options
                    for (var key in options) {
                        if (!columnObject[key]) {
                            columnObject[key] = options[key];
                        }
                    }
                    this.columns.push(columnObject);
                }
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
            this.addDisplayAggregate = (propertyIdentifier, aggregateFunction, aggregateAlias, options) => {
                var alias = this.baseEntityAlias;
                var doJoin = false;
                var collection = propertyIdentifier;
                var propertyKey = '';
                if (propertyIdentifier.indexOf('.') !== -1) {
                    collection = this.utilityService.mid(propertyIdentifier, 0, propertyIdentifier.lastIndexOf('.'));
                    propertyKey = '.' + this.utilityService.listLast(propertyIdentifier, '.');
                }
                var column = {
                    propertyIdentifier: alias + '.' + propertyIdentifier,
                    aggregate: {
                        aggregateFunction: aggregateFunction,
                        aggregateAlias: aggregateAlias
                    }
                };
                var isObject = this.$slatwall.getPropertyIsObjectByEntityNameAndPropertyIdentifier(this.baseEntityName, propertyIdentifier);
                if (isObject) {
                    //check if count is on a one-to-many
                    var lastEntityName = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.baseEntityName, propertyIdentifier);
                    var propertyMetaData = this.$slatwall.getEntityMetaData(lastEntityName)[this.utilityService.listLast(propertyIdentifier, '.')];
                    var isOneToMany = angular.isDefined(propertyMetaData['singularname']);
                    //if is a one-to-many propertyKey then add a groupby
                    if (isOneToMany) {
                        this.addGroupBy(alias);
                    }
                    column.propertyIdentifier = this.buildPropertyIdentifier(alias, propertyIdentifier);
                    var join = new Join(propertyIdentifier, column.propertyIdentifier);
                    doJoin = true;
                }
                else {
                    column.propertyIdentifier = this.buildPropertyIdentifier(alias, collection) + propertyKey;
                    var join = new Join(collection, this.buildPropertyIdentifier(alias, collection));
                    doJoin = true;
                }
                angular.extend(column, options);
                //Add columns
                this.addColumn(column.propertyIdentifier, undefined, column);
                if (doJoin) {
                    this.addJoin(join);
                }
            };
            this.addGroupBy = (groupByAlias) => {
                if (!this.groupBys) {
                    this.groupBys = '';
                }
                this.groupBys = this.utilityService.listAppend(this.groupBys, groupByAlias);
            };
            this.addDisplayProperty = (propertyIdentifier, title = '', options = {}) => {
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
                var alias = this.baseEntityAlias;
                var join;
                var doJoin = false;
                //if filterGroups does not exists then set a default
                if (!this.filterGroups) {
                    this.filterGroups = [{ filterGroup: [] }];
                }
                var collection = propertyIdentifier;
                //if the propertyIdenfifier is a chain
                var propertyKey = '';
                if (propertyIdentifier.indexOf('.') !== -1) {
                    collection = this.utilityService.mid(propertyIdentifier, 0, propertyIdentifier.lastIndexOf('.'));
                    propertyKey = '.' + this.utilityService.listLast(propertyIdentifier, '.');
                }
                //create filter group
                var filter = new Filter(this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator, propertyIdentifier.split('.').pop(), value);
                var isObject = this.$slatwall.getPropertyIsObjectByEntityNameAndPropertyIdentifier(this.baseEntityName, propertyIdentifier);
                if (isObject) {
                    filter.propertyIdentifier = this.buildPropertyIdentifier(alias, propertyIdentifier);
                    join = new Join(propertyIdentifier, this.buildPropertyIdentifier(alias, propertyIdentifier));
                    doJoin = true;
                }
                else if (propertyKey !== '') {
                    filter.propertyIdentifier = this.buildPropertyIdentifier(alias, collection) + propertyKey;
                    join = new Join(collection, this.buildPropertyIdentifier(alias, collection));
                    doJoin = true;
                }
                //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
                if (this.filterGroups[0].filterGroup.length && !logicalOperator)
                    logicalOperator = 'AND';
                this.filterGroups[0].filterGroup.push(filter);
                if (doJoin) {
                    this.addJoin(join);
                }
            };
            this.buildPropertyIdentifier = (alias, propertyIdentifier, joinChar = '_') => {
                return alias + joinChar + this.utilityService.replaceAll(propertyIdentifier, '.', '_');
            };
            this.addCollectionFilter = (propertyIdentifier, displayPropertyIdentifier, displayValue, collectionID, criteria = 'One', fieldtype, readOnly = false) => {
                this.filterGroups[0].filterGroup.push(new CollectionFilter(this.formatCollectionName(propertyIdentifier), displayPropertyIdentifier, displayValue, collectionID, criteria, fieldtype, readOnly));
            };
            //orderByList in this form: "property|direction" concrete: "skuName|ASC"
            this.setOrderBy = (orderByList) => {
                var orderBys = orderByList.split(',');
                for (var orderBy in orderBys) {
                    this.addOrderBy(orderBy);
                }
            };
            this.addOrderBy = (orderByString) => {
                if (!this.orderBy) {
                    this.orderBy = [];
                }
                var propertyIdentifier = this.utilityService.listFirst(orderByString, '|');
                var direction = this.utilityService.listLast(orderByString, '|');
                var orderBy = {
                    propertyIdentifier: propertyIdentifier,
                    direction: direction
                };
                this.orderBy.push(orderBy);
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
    CollectionConfig.$inject = ['$slatwall', 'utilityService'];
    slatwalladmin.CollectionConfig = CollectionConfig;
    angular.module('slatwalladmin')
        .factory('collectionConfigService', ['$slatwall', 'utilityService', ($slatwall, utilityService) => new CollectionConfig($slatwall, utilityService)]);
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../services/collectionconfigservice.js.map