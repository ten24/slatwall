
module slatwalladmin{

    export class Column{
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
        ){
            return this;
        }
        
        setColumn(propertyIdentifier: string){
          this.propertyIdentifier = propertyIdentifier;  
          return this;
        }; 
        setTitle(title: string){
          this.title = title; 
          return this;
        }
        setVisible(isVisible: boolean){
            this.isVisible = isVisible;
            return this;
        }
        setDeletable(isDeletable: boolean){
            this.isDeletable = isDeletable;
            return this;
        }
        setSearchable(isSearchable: boolean){
            this.isSearchable = isSearchable;
            return this;
        }
        setExportable(isExportable: boolean){
            this.isExportable = isExportable;
            return this;
        }
        setOrmType(ormType: string){
            this.ormtype = ormType;
            return this;
        }
        setAttributeID(attributeID: string){
            this.attributeID = attributeID;
            return this;
        }
        setAttributeSetObject(attributeSetObject: string){
            this.attributeSetObject = attributeSetObject;
            return this;
        }
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
    
    interface IColumnOptions {
            isVisible?: boolean;
            isDeletable?: boolean;
            isSearchable?: boolean;
            isExportable?: boolean;
            ormType?: string;
            attributeID: string;
            attributeSetObject: string
    }
    export class CollectionConfig {
        private collection: any;

        constructor(
            private $slatwall,
            public  baseEntityName:string,
            public  baseEntityAlias?:string,
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
            if(this.baseEntityName){
                try {
                    this.collection = this.$slatwall['new' + this.getEntityName()]();
                }catch(e){
                    throw "can't instantiate without entity name specified: " + e;
                }
                if(!this.baseEntityAlias){
                    this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
                }
            }
        return this;
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
            return this;
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
            };
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
            return this;
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
        
        addColumn= (column: any, title: string = '', options: IColumnOptions) =>{
            if(!this.columns){
                this.columns = [];
            }
            if (!angular.isString(column) && !angular.isUndefined(column)){
                //using a class column builder.
                this.columns.push(column);
                return this;
            }
            if(options.isExportable && !options.isVisible){
                options.isExportable = false;
            }
            
            if(!options.ormType && this.collection.metaData[column] && this.collection.metaData[column].ormtype){
                options.ormType = this.collection.metaData[column].ormtype;
            }

            this.columns.push(new Column(
                column,
                title,
                options.isVisible,
                options.isDeletable,
                options.isSearchable,
                options.isExportable,
                options.ormType,
                options.attributeID,
                options.attributeSetObject
            ));
            return this;
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
            return this;
        };

        addFilter= (propertyIdentifier: string, value:string, comparisonOperator: string = '=', logicalOperator?: string) =>{
            //this.addJoin(propertyIdentifier);
            if(this.filterGroups[0].filterGroup.length && !logicalOperator) logicalOperator = 'AND';

            this.filterGroups[0].filterGroup.push(
                new Filter(this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator)
            );
            return this;
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
            return this;
        };

        setOrderBy= (propertyIdentifier:string, direction:string='DESC') =>{
            if(angular.isUndefined(this.orderBy)){
                this.orderBy = [];
            }
            this.addJoin(propertyIdentifier);
            this.orderBy.push(new OrderBy(this.formatCollectionName(propertyIdentifier), direction));
            return this;
        };

        setCurrentPage= (pageNumber) =>{
            this.currentPage = pageNumber;
            return this;
        };

        setPageShow= (NumberOfPages) =>{
            this.pageShow = NumberOfPages;
            return this;
        };

        setKeywords= (keyword) =>{
            this.keywords = keyword;
            return this;
        };

    }
}