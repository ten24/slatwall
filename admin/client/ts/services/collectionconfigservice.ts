module slatwalladmin{

    class Column{
        constructor(
            private propertyIdentifier:string,
            private title:string,
            private isVisible:boolean,
            private isDeletable:boolean,
            private isSearchable:boolean,
            private isExportable:boolean,
            private persistent?:boolean,
            private ormtype?:string,
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
        constructor(public associationName:string,
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
        
        clearFilterGroups=()=>{
            this.filterGroups = [{filterGroup: []}];    
        };

        newCollectionConfig=(baseEntityName?:string,baseEntityAlias?:string):CollectionConfig=>{
            return new CollectionConfig(this.$slatwall, this.utilityService, baseEntityName, baseEntityAlias);
        };

        loadJson= (jsonCollection) =>{
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
        
        loadFilterGroups= (filterGroupsConfig:Array=[{filterGroup: []}]) =>{
            this.filterGroups = filterGroupsConfig;
        }
        
        loadColumns= (columns:Column[]) =>{
            this.columns = columns; 
        }

        getCollectionConfig= () =>{
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

        getEntityName= () =>{
            return this.baseEntityName.charAt(0).toUpperCase() + this.baseEntityName.slice(1);
        };

        getOptions= () =>{
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

        debug= () =>{
            return this;
        }
        /*TODO: CLEAN THIS FUNCTION */
        private formatCollectionName= (propertyIdentifier:string, property:boolean=true) =>{
            var collection = '',
                parts = propertyIdentifier.split('.'),
                current_collection =  this.collection;
            for (var i = 0; i < parts.length; i++) {
                if (typeof this.$slatwall['new' + this.capitalize(parts[i])] !== "function") {
                    if (property) collection += ((i)?'':this.baseEntityAlias) + '.' + parts[i];
                    if(!angular.isObject(current_collection.metaData[parts[i]])) {
                        break;
                    }else if(current_collection.metaData[parts[i]].fkcolumn){
                        current_collection = this.$slatwall['new' + current_collection.metaData[parts[i]].cfc]();
                    }
                }else{
                    if(angular.isObject(current_collection.metaData[parts[i]])){
                        collection += ((i)?'':this.baseEntityAlias) +'.' + parts[i];
                        current_collection = this.$slatwall['new' + this.capitalize(parts[i])]();
                    }else{
                        collection += '_' + parts[i].toLowerCase();
                    }
                }
            }
            return collection;
        };

        private addJoin= (join:Join) =>{
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
        
        private addColumn=(column:Column)=>{
            if(!this.columns || this.utilityService.ArrayFindByPropertyValue(this.columns,'propertyIdentifier',column.propertyIdentifier) === -1){
                this.addColumn(column.propertyIdentifier,column.title,column);
            }
        }

        private addColumn= (column: string, title: string = '', options:Object = {}) =>{
            if(!this.columns || this.utilityService.ArrayFindByPropertyValue(this.columns,'propertyIdentifier',column) === -1){
                var isVisible = true,
                    isDeletable = true,
                    isSearchable = true,
                    isExportable = true,
                    persistent ,
                    ormtype = 'string',
                    lastProperty=column.split('.').pop(),
                    properties = column.split('.');
                
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
                }else if(properties.length === 2 && this.collection.metaData[lastProperty] && this.collection.metaData[lastProperty].ormtype){
                    ormtype = this.collection.metaData[lastProperty].ormtype;
                }else if(properties.length > 2){
                    var currentEntityName = this.collection.metaData[properties[1]].cfc; 
                    for(var i=2; i<properties.length; i++){
                        var property = properties[i];
                        var currentEntityMetaData = this.$slatwall.getEntityMetaData(currentEntityName);
                        if(angular.isDefined(currentEntityMetaData[property])){
                            if(angular.isDefined(currentEntityMetaData[property].cfc)){
                                currentEntityName = currentEntityMetaData[property].cfc;
                            } else if(angular.isDefined(currentEntityMetaData[property].ormtype)){ 
                                ormtype = currentEntityMetaData[property].ormtype;
                            }
                        } 
                    }
                }
                
                console.log(ormtype);
    
                if(properties.length === 2 && angular.isDefined(this.collection.metaData[lastProperty])){
                    persistent = this.collection.metaData[lastProperty].persistent || true;
                } else if(properties.length > 2){
                    var currentEntityName = this.collection.metaData[properties[1]].cfc; 
                    for(var i=2; i<properties.length; i++){
                        var property = properties[i];
                        var currentEntityMetaData = this.$slatwall.getEntityMetaData(currentEntityName);
                        if(angular.isDefined(currentEntityMetaData[property])){
                            if(angular.isDefined(currentEntityMetaData[property].cfc)){
                                currentEntityName = currentEntityMetaData[property].cfc;
                            } else if(angular.isDefined(currentEntityMetaData[property].persistent)){ 
                                persistent = currentEntityMetaData[property].persistent;
                            } else { 
                                //default to true (persistent properties are not listed as such in the metadata)
                                persistent = true; 
                            }
                        }   
                    }
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
                if(options.aggregate){
                    columnObject.aggregate = options.aggregate;
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


        setDisplayProperties= (propertyIdentifier: string, title: string = '', options:Object = {}) =>{
            var _DividedColumns = propertyIdentifier.trim().split(',');
            var _DividedTitles = title.trim().split(',');
            _DividedColumns.forEach((column:string, index)  => {
                column = column.trim();
                //this.addJoin(column);
                if(!angular.isUndefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                    title = _DividedTitles[index].trim();
                }else {
                    title = this.$slatwall.getRBKey("entity."+this.baseEntityName+"."+column);
                }
                this.addColumn(this.formatCollectionName(column),title, options);
            });
        };
        
        addDisplayAggregate=(propertyIdentifier:string,aggregateFunction:string,aggregateAlias:string,options?)=>{
            var alias = this.baseEntityAlias;
            
            var doJoin = false;
            var collection = propertyIdentifier;
            var propertyKey = '';
            
            if(propertyIdentifier.indexOf('.') !== -1){
                collection = this.utilityService.mid(propertyIdentifier,0,propertyIdentifier.lastIndexOf('.'));
                propertyKey = '.' + this.utilityService.listLast(propertyIdentifier,'.');
            }
            
            
            
            var column = {
                propertyIdentifier:alias + '.' + propertyIdentifier,
                aggregate:{
                    aggregateFunction:aggregateFunction,
                    aggregateAlias:aggregateAlias
                }
            };
            
            var isObject = this.$slatwall.getPropertyIsObjectByEntityNameAndPropertyIdentifier(
                this.baseEntityName,propertyIdentifier
            );
            if(isObject){
                //check if count is on a one-to-many
                var lastEntityName = this.$slatwall.getLastEntityNameInPropertyIdentifier(this.baseEntityName,propertyIdentifier);
                var propertyMetaData = this.$slatwall.getEntityMetaData(lastEntityName)[this.utilityService.listLast(propertyIdentifier,'.')];
                var isOneToMany = angular.isDefined(propertyMetaData['singularname']);
                //if is a one-to-many propertyKey then add a groupby
//                if(isOneToMany){
//                    this.addGroupBy(alias);
//                }
                
                column.propertyIdentifier = this.buildPropertyIdentifier(alias,propertyIdentifier);
                var join = new Join(propertyIdentifier,column.propertyIdentifier);
                doJoin = true;
            }else{
                column.propertyIdentifier = this.buildPropertyIdentifier(alias,collection) + propertyKey;
                var join = new Join(collection,this.buildPropertyIdentifier(alias,collection));
                doJoin = true;
            }
            angular.extend(column,options);
            //Add columns
            this.addColumn(column.propertyIdentifier,undefined,column);
            if(doJoin){
                this.addJoin(join);
            }
        }
        
        addGroupBy = (groupByAlias)=>{
            if(!this.groupBys){
                this.groupBys = '';
            }
            this.groupBys = this.utilityService.listAppend(this.groupBys,groupByAlias);
        }
        
        addDisplayProperty= (propertyIdentifier: string, title: string = '', options:Object = {}) =>{
            var _DividedColumns = propertyIdentifier.trim().split(',');
            var _DividedTitles = title.trim().split(',');
            _DividedColumns.forEach((column:string, index)  => {
                column = column.trim();
                //this.addJoin(column);
                if(!angular.isUndefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                    title = _DividedTitles[index].trim();
                }else {
                    title = this.$slatwall.getRBKey("entity."+this.baseEntityName+"."+column);
                }
                this.addColumn(this.formatCollectionName(column),title, options);
            });
        };

        addFilter= (propertyIdentifier: string, value: any, comparisonOperator: string = '=', logicalOperator?: string) =>{
            var alias = this.baseEntityAlias;
            var join;
            var doJoin = false;
            
            //if filterGroups does not exists then set a default
            if(!this.filterGroups){
                this.filterGroups = [{filterGroup:[]}];
            }
            
            var collection = propertyIdentifier;
           
            //if the propertyIdenfifier is a chain
            var propertyKey = '';
            
            if(propertyIdentifier.indexOf('.') !== -1){
                collection = this.utilityService.mid(propertyIdentifier,0,propertyIdentifier.lastIndexOf('.'));
                propertyKey = '.'+this.utilityService.listLast(propertyIdentifier,'.');
            }
            
            //create filter group
            var filter = new Filter(
                this.formatCollectionName(propertyIdentifier),
                value,
                comparisonOperator,
                logicalOperator,
                propertyIdentifier.split('.').pop(),
                value
            );
            
            var isObject = this.$slatwall.getPropertyIsObjectByEntityNameAndPropertyIdentifier(this.baseEntityName,propertyIdentifier);
            if(isObject){
                filter.propertyIdentifier = this.buildPropertyIdentifier(alias,propertyIdentifier);
                join =  new Join(propertyIdentifier,this.buildPropertyIdentifier(alias,propertyIdentifier));
                doJoin = true;
            }else if(propertyKey !== ''){
                filter.propertyIdentifier = this.buildPropertyIdentifier(alias,collection) + propertyKey;
                join = new Join(collection,this.buildPropertyIdentifier(alias,collection));
                doJoin = true;
            }
            
            
            //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
            if(this.filterGroups[0].filterGroup.length && !logicalOperator) logicalOperator = 'AND';
            
            this.filterGroups[0].filterGroup.push(filter);
            if(doJoin){
                this.addJoin(join);   
            }
        };
        
        buildPropertyIdentifier = (alias:string,propertyIdentifier:string, joinChar:string = '_'):string=>{
            return alias + joinChar + this.utilityService.replaceAll(propertyIdentifier,'.','_');
        }

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
        //orderByList in this form: "property|direction" concrete: "skuName|ASC"
        setOrderBy = (orderByList)=>{
            var orderBys = orderByList.split(',');
            angular.forEach(orderBys,(orderBy)=>{
                this.addOrderBy(orderBy);
            });
        };
        
        addOrderBy = (orderByString)=>{
            if(!this.orderBy){
                this.orderBy = [];    
            }
            
            var propertyIdentifier = this.utilityService.listFirst(orderByString,'|');
            var direction = this.utilityService.listLast(orderByString,'|');
            
            var orderBy = {
                propertyIdentifier:this.formatCollectionName(propertyIdentifier),
                direction:direction
            };
            
            this.orderBy.push(orderBy);
        }

        setCurrentPage= (pageNumber) =>{
            this.currentPage = pageNumber;
        };

        setPageShow= (NumberOfPages) =>{
            this.pageShow = NumberOfPages;
        };

        setAllRecords= (allFlag:boolean=false) =>{
            this.allRecords = allFlag;
        };

        setKeywords= (keyword) =>{
            this.keywords = keyword;
        };

        private setId=(id)=>{
            this.id = id;
        }

        getEntity=(id?)=>{
            if (angular.isDefined(id)){
                this.setId(id);
            }
            return this.$slatwall.getEntity(this.baseEntityName, this.getOptions());
        };

    }
    angular.module('slatwalladmin')
        .factory('collectionConfigService', ['$slatwall','utilityService', ($slatwall: any,utilityService) => new CollectionConfig($slatwall,utilityService)]);
}
