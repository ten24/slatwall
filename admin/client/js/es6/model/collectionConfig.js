var slatwalladmin;
(function (slatwalladmin) {
    class Column {
        constructor(propertyIdentifier, title, isVisible, isDeletable, attributeID, attributeSetObject) {
            this.propertyIdentifier = propertyIdentifier;
            this.title = title;
            this.isVisible = isVisible;
            this.isDeletable = isDeletable;
            this.attributeID = attributeID;
            this.attributeSetObject = attributeSetObject;
        }
    }
    class FilterGroup {
        constructor(filterGroups) {
            this.filterGroups = filterGroups;
        }
    }
    class Filter {
        constructor(propertyIdentifier, value, comparisonOperator, logicalOperator) {
            this.propertyIdentifier = propertyIdentifier;
            this.value = value;
            this.comparisonOperator = comparisonOperator;
            this.logicalOperator = logicalOperator;
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
        constructor($slatwall, baseEntityName, baseEntityAlias, columns, filterGroups = [], joins, orderBy, currentPage = 1, pageShow = 10, keywords = '') {
            this.$slatwall = $slatwall;
            this.baseEntityName = baseEntityName;
            this.baseEntityAlias = baseEntityAlias;
            this.columns = columns;
            this.filterGroups = filterGroups;
            this.joins = joins;
            this.orderBy = orderBy;
            this.currentPage = currentPage;
            this.pageShow = pageShow;
            this.keywords = keywords;
        }
        loadJson(jsonCollection) {
            //if json then make a javascript object else use the javascript object
            if (angular.isString(jsonCollection)) {
                jsonCollection = angular.fromJson(jsonCollection);
            }
            this.baseEntityAlias = jsonCollection.baseEntityAlias;
            this.baseEntityName = jsonCollection.baseEntityName;
            this.columns = jsonCollection.columns;
            this.currentPage = jsonCollection.currentPage;
            this.filterGroups = jsonCollection.filterGroups;
            this.joins = jsonCollection.joins;
            this.keywords = jsonCollection.keywords;
            this.orderBy = jsonCollection.orderBy;
            this.pageShow = jsonCollection.pageShow;
        }
        getJson() {
            var config = this;
            delete config['$slatwall'];
            //config.filterGroups= [{'filterGroup': this.filterGroups}];
            return angular.toJson(config);
        }
        getEntityName() {
            return this.baseEntityName.charAt(0).toUpperCase() + this.baseEntityName.slice(1);
        }
        getOptions() {
            return {
                columnsConfig: angular.toJson(this.columns),
                filterGroupsConfig: angular.toJson([{ 'filterGroup': this.filterGroups }]),
                joinsConfig: angular.toJson(this.joins),
                currentPage: this.currentPage,
                pageShow: this.pageShow,
                keywords: this.keywords
            };
        }
        debug() {
            return this;
        }
        formatCollectionName(propertyIdentifier, property = true) {
            var collection = '';
            var parts = propertyIdentifier.split('.');
            for (var i = 0; i < parts.length; i++) {
                if (typeof this.$slatwall['new' + this.capitalize(parts[i])] !== "function") {
                    if (property)
                        collection += ((i) ? '' : this.baseEntityAlias) + '.' + parts[i];
                    break;
                }
                collection += '_' + parts[i].toLowerCase();
            }
            return collection;
        }
        addJoin(associationName) {
            var joinFound = false;
            if (angular.isUndefined(this.columns)) {
                this.joins = [];
            }
            var parts = associationName.split('.');
            var collection = '';
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
        }
        addAlias(propertyIdentifier) {
            var parts = propertyIdentifier.split('.');
            if (parts.length > 1 && parts[0] !== this.baseEntityAlias) {
                return this.baseEntityAlias + '.' + propertyIdentifier;
            }
            return propertyIdentifier;
        }
        capitalize(s) {
            return s && s[0].toUpperCase() + s.slice(1);
        }
        addColumn(column, title = '', options = {}) {
            var isVisible = true;
            var isDeletable = true;
            if (angular.isUndefined(this.columns)) {
                this.columns = [];
            }
            if (!angular.isUndefined(options['isVisible'])) {
                isVisible = options['isVisible'];
            }
            if (!angular.isUndefined(options['isDeletable'])) {
                isDeletable = options['isDeletable'];
            }
            this.columns.push(new Column(column, title, isVisible, isDeletable, options['attributeID'], options['attributeSetObject']));
        }
        setDisplayProperties(propertyIdentifier, title = '', options = {}) {
            var _DividedColumns = propertyIdentifier.trim().split(',');
            var _DividedTitles = title.trim().split(',');
            if (_DividedColumns.length > 0) {
                _DividedColumns.forEach((column, index) => {
                    column = column.trim();
                    this.addJoin(column);
                    if (_DividedTitles[index] !== undefined && _DividedTitles[index] != '') {
                        title = _DividedTitles[index].trim();
                    }
                    else {
                        var startAlias = new RegExp('^' + this.baseEntityAlias + '\\.');
                        title = column.replace(startAlias, '').replace(/\./g, '_');
                    }
                    this.addColumn(this.formatCollectionName(column), title, options);
                });
            }
            else {
                this.addJoin(propertyIdentifier);
                propertyIdentifier = this.addAlias(propertyIdentifier);
                if (title == '')
                    title = propertyIdentifier.trim().replace(this.baseEntityAlias + '.', '').replace(/\./g, '_');
                this.addColumn(this.formatCollectionName(propertyIdentifier), title, options);
            }
        }
        addFilter(propertyIdentifier, value, comparisonOperator = '=', logicalOperator = '') {
            this.addJoin(propertyIdentifier);
            this.filterGroups.push(new Filter(this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator));
        }
        setOrderBy(propertyIdentifier, direction = 'DESC') {
            if (angular.isUndefined(this.orderBy)) {
                this.orderBy = [];
            }
            this.addJoin(propertyIdentifier);
            this.orderBy.push(new OrderBy(this.formatCollectionName(propertyIdentifier), direction));
        }
        setCurrentPage(pageNumber) {
            this.currentPage = pageNumber;
        }
        setPageShow(NumberOfPages) {
            this.pageShow = NumberOfPages;
        }
        setKeywords(keyword) {
            this.keywords = keyword;
        }
    }
    slatwalladmin.CollectionConfig = CollectionConfig;
})(slatwalladmin || (slatwalladmin = {}));

//# sourceMappingURL=../model/collectionConfig.js.map