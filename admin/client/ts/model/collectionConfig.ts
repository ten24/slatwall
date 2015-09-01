
module slatwalladmin{

    class Column{
        constructor(
            public propertyIdentifier:string,
            public title:string,
            public isVisible:boolean,
            public isDeletable:boolean,
            public isSearchable:boolean,
            public isExportable:boolean,
            public ormtype?:string,
            public attributeID?:string,
            public attributeSetObject?:string
        ){}
    }

    class Filter{
        constructor(
            public propertyIdentifier:string,
            public value:string,
            public comparisonOperator:string,
            public logicalOperator?:string
        ){}
    }

    class CollectionFilter{
        constructor(
            public propertyIdentifier:string,
            public displayPropertyIdentifier:string,
            public displayValue:string,
            public collectionID:string,
            public criteria:string,
            public fieldtype?:string,
            public readOnly:boolean=false
        ){}
    }

    class Join{
        constructor(
            public associationName:string,
            public alias:string
        ){}
    }

    class OrderBy{
        constructor(
            public propertyIdentifier:string,
            public direction:string
        ){}
    }

    export class CollectionConfig {
        private collection: any;

        constructor(
            private $slatwall,
            public  baseEntityName:string,
            public baseEntityAlias?:string,
            private columns?:Column[],
            private filterGroups:Array=[{filterGroup: []}],
            private joins?:Join[],
            private orderBy?:OrderBy[],
            private id?:number,
            private currentPage:number = 1,
            private pageShow:number = 10,
            private keywords:string = '',
            private defaultColumns:boolean = false

        ){
            if(!angular.isUndefined(this.baseEntityName)){
                this.collection = this.$slatwall['new' + this.getEntityName()]();
                if(angular.isUndefined(this.baseEntityAlias)){
                    this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
                }
            }
        }

        loadJson= (jsonCollection) =>{
            //if json then make a javascript object else use the javascript object
            if(angular.isString(jsonCollection)){
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
            this.defaultColumns = jsonCollection.defaultColumns

        };

        getCollectionConfig= () =>{
            return {
                baseEntityAlias: this.baseEntityAlias,
                baseEntityName: this.baseEntityName,
                columns: this.columns,
                filterGroups: this.filterGroups,
                joins: this.joins,
                currentPage: this.currentPage,
                pageShow: this.pageShow,
                keywords: this.keywords,
                defaultColumns: this.defaultColumns
            };
        };

        getEntityName= () =>{
            return this.baseEntityName.charAt(0).toUpperCase() + this.baseEntityName.slice(1);
        };

        getOptions= () =>{
            return {
                columnsConfig: angular.toJson(this.columns),
                filterGroupsConfig: angular.toJson(this.filterGroups),
                joinsConfig: angular.toJson(this.joins),
                currentPage: this.currentPage,
                pageShow: this.pageShow,
                keywords: this.keywords,
                defaultColumns: this.defaultColumns
            }
        };

        debug= () =>{
            return this;
        }

        private formatCollectionName= (propertyIdentifier:string, property:boolean=true) =>{
            var collection = '',
                parts = propertyIdentifier.split('.'),
                current_collection =  this.collection;
            for (var i = 0; i < parts.length; i++) {
                if (typeof this.$slatwall['new' + this.capitalize(parts[i])] !== "function") {
                    if (property) collection += ((i)?'':this.baseEntityAlias) + '.' + parts[i];
                    if(!angular.isObject(current_collection.metaData[parts[i]])) {
                        break;
                    }
                }else{
                    if(angular.isObject(current_collection.metaData[parts[i]])){
                        collection += ((i)?'':this.baseEntityAlias+'.')  + parts[i];
                        current_collection = this.$slatwall['new' + this.capitalize(parts[i])]();
                    }else{
                        collection += '_' + parts[i].toLowerCase();
                    }
                }
            }
            return collection;
        };

        private addJoin= (associationName: string) =>{
            var joinFound:boolean = false,
                parts = associationName.split('.'),
                collection = '';

            if(angular.isUndefined(this.joins)){
                this.joins = [];
            }
            for (var i = 0; i < parts.length; i++) {
                joinFound = false;
                if (typeof this.$slatwall['new' + this.capitalize(parts[i])] !== "function") break;
                collection += '.' + parts[i];
                this.joins.map(function(_join) {
                    if (_join.associationName == collection.slice(1)) {
                        joinFound = true;
                        return;
                    }
                });
                if(!joinFound) {
                    this.joins.push(new Join(collection.slice(1), collection.toLowerCase().replace(/\./g, '_')));
                }

            }

        };

        private addAlias= (propertyIdentifier:string) =>{
            var parts = propertyIdentifier.split('.');
            if(parts.length > 1 && parts[0] !== this.baseEntityAlias){
                return this.baseEntityAlias+'.'+propertyIdentifier;
            }
            return propertyIdentifier;
        };

        private capitalize = (s)  => {
            return s && s[0].toUpperCase() + s.slice(1);
        };

        addColumn= (column: string, title: string = '', options:Object = {}) =>{
            var isVisible = true,
                isDeletable = true,
                isSearchable = true,
                isExportable = true,
                ormtype = 'string';

            if(angular.isUndefined(this.columns)){
                this.columns = [];
            }
            if(!angular.isUndefined(options['isVisible'])){
                isVisible = options['isVisible'];
            }
            if(!angular.isUndefined(options['isDeletable'])){
                isDeletable = options['isDeletable'];
            }
            if(!angular.isUndefined(options['isSearchable'])){
                isSearchable = options['isSearchable'];
            }
            if(!angular.isUndefined(options['isExportable'])){
                isExportable = options['isExportable'];
            }
            if(angular.isUndefined(options['isExportable']) && !isVisible){
                isExportable = false;
            }
            if(!angular.isUndefined(options['ormtype'])){
                ormtype = options['ormtype'];
            }else if(this.collection.metaData[column] && this.collection.metaData[column].ormtype){
                ormtype = this.collection.metaData[column].ormtype;
            }

            this.columns.push(new Column(
                column,
                title,
                isVisible,
                isDeletable,
                isSearchable,
                isExportable,
                ormtype,
                options['attributeID'],
                options['attributeSetObject']
            ));
        };


        setDisplayProperties= (propertyIdentifier: string, title: string = '', options:Object = {}) =>{

            var _DividedColumns = propertyIdentifier.trim().split(',');
            var _DividedTitles = title.trim().split(',');
            if(_DividedColumns.length > 0) {
                _DividedColumns.forEach((column:string, index)  => {
                    column = column.trim();
                    //this.addJoin(column);
                    if(_DividedTitles[index] !== undefined && _DividedTitles[index] != '') {
                        title = _DividedTitles[index].trim();
                    }else {
                        title = this.$slatwall.getRBKey("entity."+this.baseEntityName.toLowerCase()+"."+column.toLowerCase());
                    }
                    this.addColumn(this.formatCollectionName(column),title, options);

                });
            }else{
                //this.addJoin(propertyIdentifier);
                propertyIdentifier = this.addAlias(propertyIdentifier);
                if(title == '') title = this.$slatwall.getRBKey("entity."+this.baseEntityName.toLowerCase()+"."+propertyIdentifier.toLowerCase());
                this.addColumn(this.formatCollectionName(propertyIdentifier),title, options);
            }
        };

        addFilter= (propertyIdentifier: string, value:string, comparisonOperator: string = '=', logicalOperator?: string) =>{
            //this.addJoin(propertyIdentifier);
            if(this.filterGroups[0].filterGroup.length && !logicalOperator) logicalOperator = 'AND';

            this.filterGroups[0].filterGroup.push(
                new Filter(this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator)
            );

        };

        addCollectionFilter= (propertyIdentifier: string, displayPropertyIdentifier:string, displayValue:string,
                              collectionID: string, criteria:string='One', fieldtype?:string, readOnly:boolean=false
        ) =>{
            this.filterGroups[0].filterGroup.push(
                new CollectionFilter(
                    this.formatCollectionName(propertyIdentifier),
                    displayPropertyIdentifier,
                    displayValue,
                    collectionID,
                    criteria,
                    fieldtype,
                    readOnly
                )
            );

        };

        setOrderBy= (propertyIdentifier:string, direction:string='DESC') =>{
            if(angular.isUndefined(this.orderBy)){
                this.orderBy = [];
            }
            this.addJoin(propertyIdentifier);
            this.orderBy.push(new OrderBy(this.formatCollectionName(propertyIdentifier), direction));
        };

        setCurrentPage= (pageNumber) =>{
            this.currentPage = pageNumber;
        };

        setPageShow= (NumberOfPages) =>{
            this.pageShow = NumberOfPages;
        };

        setKeywords= (keyword) =>{
            this.keywords = keyword;
        };

    }
}