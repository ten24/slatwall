
module slatwalladmin{

    class Column{
        constructor(
            public propertyIdentifier:string,
            public title:string,
            public isVisible:boolean,
            public isDeletable:boolean,
            public attributeID?:string,
            public attributeSetObject?:string
        ){}
    }

    class FilterGroup{
        constructor(
            public filterGroups:Filter[]
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

        constructor(
            private $slatwall,
            public  baseEntityName:string,
            private baseEntityAlias:string,
            private columns?:Column[],
            private filterGroups:Filter[]=[],
            private joins?:Join[],
            private orderBy?:OrderBy[],
            private currentPage:number = 1,
            private pageShow:number = 10,
            private keywords:string = ''
        ){}


        loadJson(jsonCollection){
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

        getJson(){
            var config = this;
            delete config['$slatwall'];
            //config.filterGroups= [{'filterGroup': this.filterGroups}];
            return angular.toJson(config);
        }

        getEntityName(){
            return this.baseEntityName.charAt(0).toUpperCase() + this.baseEntityName.slice(1);
        }

        getOptions(){
            return {
                columnsConfig: angular.toJson(this.columns),
                filterGroupsConfig: angular.toJson([{'filterGroup': this.filterGroups}]),
                joinsConfig: angular.toJson(this.joins),
                currentPage: this.currentPage,
                pageShow: this.pageShow,
                keywords: this.keywords
            }
        }

        debug(){
            return this;
        }

        private formatCollectionName(propertyIdentifier:string, property:boolean=true){
            var collection = '';
            var parts = propertyIdentifier.split('.');
            for (var i = 0; i < parts.length; i++) {
                if (typeof this.$slatwall['new' + this.capitalize(parts[i])] !== "function"){
                    if(property) collection += ((i)?'':this.baseEntityAlias)+'.' + parts[i];
                    break;
                }
                collection += '_' + parts[i].toLowerCase();
            }
            return collection;
        }

        private addJoin(associationName: string) {
            var joinFound:boolean = false;
            if(angular.isUndefined(this.columns)){
                this.joins = [];
            }
            var parts = associationName.split('.');
            var collection = '';
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

        }

        private addAlias(propertyIdentifier:string){
            var parts = propertyIdentifier.split('.');
            if(parts.length > 1 && parts[0] !== this.baseEntityAlias){
                return this.baseEntityAlias+'.'+propertyIdentifier;
            }
            return propertyIdentifier;
        }

        private capitalize(s) {
            return s && s[0].toUpperCase() + s.slice(1);
        }

        addColumn(column: string, title: string = '', options:Object = {}){
            var isVisible = true;
            var isDeletable = true;
            if(angular.isUndefined(this.columns)){
                this.columns = [];
            }
            if(!angular.isUndefined(options['isVisible'])){
                isVisible = options['isVisible'];
            }
            if(!angular.isUndefined(options['isDeletable'])){
                isDeletable = options['isDeletable'];
            }

            this.columns.push(new Column(
                column,
                title,
                isVisible,
                isDeletable,
                options['attributeID'],
                options['attributeSetObject']
            ));
        }


        setDisplayProperties(propertyIdentifier: string, title: string = '', options:Object = {}){

            var _DividedColumns = propertyIdentifier.trim().split(',');
            var _DividedTitles = title.trim().split(',');
            if(_DividedColumns.length > 0) {
                _DividedColumns.forEach((column:string, index)  => {
                    column = column.trim();
                    this.addJoin(column);
                    if(_DividedTitles[index] !== undefined && _DividedTitles[index] != '') {
                        title = _DividedTitles[index].trim();
                    }else {
                        var startAlias = new RegExp('^'+this.baseEntityAlias +'\\.');
                        title = column.replace(startAlias, '').replace(/\./g, '_');
                    }
                    this.addColumn(this.formatCollectionName(column),title, options);

                });
            }else{
                this.addJoin(propertyIdentifier);
                propertyIdentifier = this.addAlias(propertyIdentifier);
                if(title == '') title = propertyIdentifier.trim().replace(this.baseEntityAlias+'.','').replace(/\./g,'_');
                this.addColumn(this.formatCollectionName(propertyIdentifier),title, options);
            }
        }

        addFilter(propertyIdentifier: string, value:string, comparisonOperator: string = '=', logicalOperator: string = ''){
            this.addJoin(propertyIdentifier);
            this.filterGroups.push(
                new Filter(this.formatCollectionName(propertyIdentifier), value, comparisonOperator, logicalOperator)
            );

        }

        setOrderBy(propertyIdentifier:string, direction:string='DESC'){
            if(angular.isUndefined(this.orderBy)){
                this.orderBy = [];
            }
            this.addJoin(propertyIdentifier);
            this.orderBy.push(new OrderBy(this.formatCollectionName(propertyIdentifier), direction));
        }

        setCurrentPage(pageNumber){
            this.currentPage = pageNumber;
        }

        setPageShow(NumberOfPages){
            this.pageShow = NumberOfPages;
        }

        setKeywords(keyword){
            this.keywords = keyword;
        }

     }
}