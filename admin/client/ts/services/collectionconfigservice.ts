module slatwalladmin{

    class Column{
        constructor(
            public propertyIdentifier:string,
            public title:string,
            public isVisible:boolean=true,
            public isDeletable:boolean=true,
            public isSearchable:boolean=true,
            public isExportable:boolean=true,
            public persistent?:boolean,
            public ormtype?:string,
            private attributeID?:string,
            private attributeSetObject?:string
        ){}
    }

    class Filter{
        constructor(
            public propertyIdentifier:string,
            public value:string,
            public comparisonOperator:string,
            public logicalOperator?:string,
            public displayPropertyIdentifier?:string,
            public displayValue?:string
        ){}
    }

    class CollectionFilter{
        constructor(
            private propertyIdentifier:string,
            private displayPropertyIdentifier:string,
            private displayValue:string,
            private collectionID:string,
            private criteria:string,
            private fieldtype?:string,
            private readOnly:boolean=false
        ){}
    }

    export class Join{
        constructor(
            public associationName:string,
            public alias:string
        ){}
    }

    class OrderBy{
        constructor(
            private propertyIdentifier:string,
            private direction:string
        ){}
    }

    export class CollectionConfig {
        public collection: any;
        public static $inject = ['$slatwall','utilityService'];
        constructor(
            private $slatwall:any,
            private utilityService,
            public  baseEntityName?:string,
            public  baseEntityAlias?:string,
            public columns?:Column[],
            private filterGroups:Array=[{filterGroup: []}],
            private joins?:Join[],
            private orderBy?:OrderBy[],
            private groupBys?:string,
            private id?:number,
            private currentPage:number = 1,
            private pageShow:number = 10,
            private keywords:string = '',
            private allRecords:boolean = false

        ){
            if(angular.isDefined(this.baseEntityName)){
                this.collection = this.$slatwall['new' + this.getEntityName()]();
                if(angular.isUndefined(this.baseEntityAlias)){
                    this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
                }
            }
        }

        public clearFilterGroups=():void=>{
            this.filterGroups = [{filterGroup: []}];
        };

        public newCollectionConfig=(baseEntityName?:string,baseEntityAlias?:string):CollectionConfig=>{
            return new CollectionConfig(this.$slatwall, this.utilityService, baseEntityName, baseEntityAlias);
        };

        public loadJson= (jsonCollection):void =>{
            //if json then make a javascript object else use the javascript object
            if(angular.isString(jsonCollection)){
                jsonCollection = angular.fromJson(jsonCollection);
            }

            this.baseEntityAlias = jsonCollection.baseEntityAlias;
            this.baseEntityName = jsonCollection.baseEntityName;
            if(angular.isDefined(jsonCollection.filterGroups)){
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

        public loadFilterGroups= (filterGroupsConfig:Array=[{filterGroup: []}]):void =>{
            this.filterGroups = filterGroupsConfig;
        };

        public loadColumns= (columns:Column[]):void =>{
            this.columns = columns;
        };

        public getCollectionConfig= ():Object =>{
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

        public getEntityName= ():string =>{
            return this.baseEntityName.charAt(0).toUpperCase() + this.baseEntityName.slice(1);
        };

        public getOptions= (): Object =>{
            var options= {
                columnsConfig: angular.toJson(this.columns),
                filterGroupsConfig: angular.toJson(this.filterGroups),
                joinsConfig: angular.toJson(this.joins),
                orderByConfig:angular.toJson(this.orderBy),
                groupBysConfig: angular.toJson(this.groupBys),
                currentPage: this.currentPage,
                pageShow: this.pageShow,
                keywords: this.keywords,
                defaultColumns: (!this.columns || !this.columns.length),
                allRecords: this.allRecords
            };
            if(angular.isDefined(this.id)){
                options['id'] = this.id;
            }
            return options;
        };

        public debug= ():CollectionConfig =>{
            return this;
        };

        private formatPropertyIdentifier= (propertyIdentifier:string, addJoin:boolean=false):string =>{
            var _propertyIdentifier = this.baseEntityAlias,
                _joinPropertyIdentifier='',
                propertyIdentifierParts = propertyIdentifier.split('.'),
                current_collection =  this.collection;

            //Loop Over all property Identifier parts
            for (var i = 0; i < propertyIdentifierParts.length; i++) {

                //Check if current part is an Object
                if('cfc' in current_collection.metaData[propertyIdentifierParts[i]]){
                    current_collection = this.$slatwall['new' + current_collection.metaData[propertyIdentifierParts[i]].cfc]();
                    if(addJoin) {
                        var joinProperty = ((_joinPropertyIdentifier) ? _joinPropertyIdentifier + '.' : '') + propertyIdentifierParts[i];
                        var join = new Join(joinProperty, this.baseEntityAlias + '_' + joinProperty.replace(/\./g, '_'));
                        this.addJoin(join);
                        _joinPropertyIdentifier += ((_joinPropertyIdentifier) ? '.' : '') + propertyIdentifierParts[i];
                        _propertyIdentifier += '_' + propertyIdentifierParts[i];
                    }else{
                        _propertyIdentifier += '.' + propertyIdentifierParts[i];
                    }

                }else{
                    _propertyIdentifier +=  '.' + propertyIdentifierParts[i];
                }

            }
            return _propertyIdentifier;
        };

        private addJoin= (join:Join):void =>{
            if(!this.joins){
                this.joins = [];
            }
            var joinFound = false;
            angular.forEach(this.joins,(configJoin)=>{
                if(configJoin.alias === join.alias){
                    joinFound = true;
                }
            });

            if(!joinFound){
                this.joins.push(join);
            }
        };

        private addAlias= (propertyIdentifier:string):string =>{
            var parts = propertyIdentifier.split('.');
            if(parts.length > 1 && parts[0] !== this.baseEntityAlias){
                return this.baseEntityAlias+'.'+propertyIdentifier;
            }
            return propertyIdentifier;
        };

        public addColumn= (column: string, title: string = '', options:Object = {}):void =>{
            if(!this.columns || this.utilityService.ArrayFindByPropertyValue(this.columns,'propertyIdentifier',column) === -1){
                var isVisible = true,
                    isDeletable = true,
                    isSearchable = true,
                    isExportable = true,
                    persistent ,
                    ormtype = 'string',
                    lastProperty=column.split('.').pop()
                    ;
                var lastEntity = this.$slatwall.getEntityExample(this.$slatwall.getLastEntityNameInPropertyIdentifier(this.baseEntityName,column));
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
                }else if(lastEntity.metaData[lastProperty] && lastEntity.metaData[lastProperty].ormtype){
                    ormtype = lastEntity.metaData[lastProperty].ormtype;
                }

                if(angular.isDefined(lastEntity[lastProperty])){
                    persistent = lastEntity[lastProperty].persistent;
                }

                var columnObject = new Column(
                    column,
                    title,
                    isVisible,
                    isDeletable,
                    isSearchable,
                    isExportable,
                    persistent,
                    ormtype,
                    options['attributeID'],
                    options['attributeSetObject']
                );
                if(options['aggregate']){
                    columnObject['aggregate'] = options['aggregate'],
                        columnObject['aggregateAlias'] = title
                }
                //add any non-conventional options
                for(var key in options){
                    if(!columnObject[key]){
                        columnObject[key] = options[key];
                    }
                }


                this.columns.push(columnObject);
            }
        };


        public setDisplayProperties= (propertyIdentifier: string, title: string = '', options:Object = {}):void =>{
            this.addDisplayProperty= (propertyIdentifier, title, options);
        };

        public addDisplayAggregate=(propertyIdentifier:string,aggregateFunction:string,aggregateAlias:string,options?):void=>{
            var column = {
                propertyIdentifier:this.formatPropertyIdentifier(propertyIdentifier, true),
                title : this.$slatwall.getRBKey("entity."+this.baseEntityName+"."+propertyIdentifier),
                aggregate:{
                    aggregateFunction:aggregateFunction,
                    aggregateAlias:aggregateAlias
                }
            };

            angular.extend(column,options);
            //Add columns
            this.addColumn(column.propertyIdentifier,undefined,column);
        };

        public addGroupBy = (groupByAlias):void=>{
            if(!this.groupBys){
                this.groupBys = '';
            }
            this.groupBys = this.utilityService.listAppend(this.groupBys,groupByAlias);
        };

        public addDisplayProperty= (propertyIdentifier: string, title: string = '', options:Object = {}):void =>{
            var _DividedColumns = propertyIdentifier.trim().split(',');
            var _DividedTitles = title.trim().split(',');
            _DividedColumns.forEach((column:string, index)  => {
                column = column.trim();
                if(angular.isDefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                    title = _DividedTitles[index].trim();
                }else {
                    title = this.$slatwall.getRBKey("entity."+this.baseEntityName+"."+column);
                }
                this.addColumn(this.formatPropertyIdentifier(column),title, options);
            });
        };

        public addFilter= (propertyIdentifier: string, value: any, comparisonOperator: string = '=', logicalOperator?: string):void =>{

            //if filterGroups does not exists then set a default
            if(!this.filterGroups){
                this.filterGroups = [{filterGroup:[]}];
            }

            //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
            if(this.filterGroups[0].filterGroup.length && !logicalOperator) logicalOperator = 'AND';


            //create filter group
            var filter = new Filter(
                this.formatPropertyIdentifier(propertyIdentifier, true),
                value,
                comparisonOperator,
                logicalOperator,
                propertyIdentifier.split('.').pop(),
                value
            );

            this.filterGroups[0].filterGroup.push(filter);
        };

        public addCollectionFilter= (propertyIdentifier: string, displayPropertyIdentifier:string, displayValue:string,
                                     collectionID: string, criteria:string='One', fieldtype?:string, readOnly:boolean=false
        ):void =>{
            this.filterGroups[0].filterGroup.push(
                new CollectionFilter(
                    this.formatPropertyIdentifier(propertyIdentifier),
                    displayPropertyIdentifier,
                    displayValue,
                    collectionID,
                    criteria,
                    fieldtype,
                    readOnly
                )
            );

        };
        //orderByList in this form: "property|direction" concrete: "skuName|ASC"
        public setOrderBy = (orderByList):void=>{
            var orderBys = orderByList.split(',');
            angular.forEach(orderBys,(orderBy)=>{
                this.addOrderBy(orderBy);
            });
        };

        public addOrderBy = (orderByString):void=>{
            if(!this.orderBy){
                this.orderBy = [];
            }

            var propertyIdentifier = this.utilityService.listFirst(orderByString,'|');
            var direction = this.utilityService.listLast(orderByString,'|');

            var orderBy = {
                propertyIdentifier:this.formatPropertyIdentifier(propertyIdentifier),
                direction:direction
            };

            this.orderBy.push(orderBy);
        };

        public setCurrentPage= (pageNumber):void =>{
            this.currentPage = pageNumber;
        };

        public setPageShow= (NumberOfPages):void =>{
            this.pageShow = NumberOfPages;
        };

        public getPageShow=():number=>{
            return this.pageShow;
        };

        public setAllRecords= (allFlag:boolean=false):void =>{
            this.allRecords = allFlag;
        };

        public setKeywords= (keyword):void =>{
            this.keywords = keyword;
        };

        private setId=(id):void=>{
            this.id = id;
        };

        public hasFilters=():boolean=>{
            return (this.filterGroups.length && this.filterGroups[0].filterGroup.length);
        };

        public clearFilters=():void=>{
            this.filterGroups = [{filterGroup:[]}];
        };

        public getEntity=(id?)=>{
            if (angular.isDefined(id)){
                this.setId(id);
            }
            return this.$slatwall.getEntity(this.baseEntityName, this.getOptions());
        };

    }
    angular.module('slatwalladmin')
        .factory('collectionConfigService', ['$slatwall','utilityService', ($slatwall: any,utilityService) => new CollectionConfig($slatwall,utilityService)]);
}