/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
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
        private attributeSetObject?:string,
        private type?:string
    ){}
}

interface IColumn{
    propertyIdentifier:string;
    title:string;
    isVisible:boolean;
    isDeletable:boolean;
    isSearchable:boolean;
    isExportable:boolean;
    persistent?:boolean;
    ormtype?:string;
    attributeID?:string;
    attributeSetObject?:string;
    type?:string;
}

interface IFilter{
    propertyIdentifier:string;
    value:string;
    comparisonOperator:string;
    logicalOperator?:string;
    displayPropertyIdentifier?:string;
    displayValue?:string;
}

class Filter{
    constructor(
        public propertyIdentifier:string,
        public value:string,
        public comparisonOperator:string,
        public logicalOperator?:string,
        public displayPropertyIdentifier?:string,
        public displayValue?:string,
        public hidden:boolean=false,
        public pattern?:string
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

class Join{
    constructor(
        public associationName:string,
        public alias:string
    ){}
}

interface IOrderBy{
    propertyIdentifier:string;
    direction:string;
}

class OrderBy{
    constructor(
        public propertyIdentifier:string,
        public direction:string
    ){}
}


class CollectionConfig {
    public collection: any;
    public baseEntityNameType:string;
    private eventID:string;
    public filterGroupAliasMap:any = {};
    public reportFlag:boolean=false;
    public periodInterval:string="";

    get collectionConfigString():string {
        
        return angular.toJson(this.getCollectionConfig(false));
    }

    // @ngInject
    constructor(
        private rbkeyService:any,
        private $hibachi:any,
        private utilityService,
        public  observerService,
        public  baseEntityName?:string,
        public  baseEntityAlias?:string,
        public  columns?:Column[],
        public  keywordColumns:Column[]=[],
        private useElasticSearch:boolean = false,
        private filterGroups:Array<any>=[{filterGroup: []}],
        private keywordFilterGroups:Array<any>=[{filterGroup: []}],
        private joins?:Join[],
        private orderBy?:OrderBy[],
        private groupBys?:string,
        private id?:number,
        private currentPage:number = 1,
        private pageShow:number = 10,
        private keywords:string = '',
        private allRecords:boolean = false,
        private dirtyRead:boolean = false,
        private isDistinct:boolean = false

    ){
        this.$hibachi = $hibachi;
        this.rbkeyService = rbkeyService;
        if(angular.isDefined(this.baseEntityName)){
            this.collection = this.$hibachi.getEntityExample(this.baseEntityName);
            if(angular.isUndefined(this.baseEntityAlias)){
                this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
            }
        }
    }

    public clearFilterGroups=():CollectionConfig=>{
        this.filterGroups = [{filterGroup: []}];
        this.keywordFilterGroups = [{filterGroup: []}];
        return this;
    };

    public newCollectionConfig=(baseEntityName?:string,baseEntityAlias?:string):CollectionConfig=>{
        return new CollectionConfig(this.rbkeyService, this.$hibachi, this.utilityService, this.observerService, baseEntityName, baseEntityAlias);
    };
    
    public setReportFlag = (reportFlag:boolean):void=>{
        this.reportFlag = reportFlag;
    }
    
    public isReport = ():boolean=>{
        return this.reportFlag;
    }
    
    public setPeriodInterval = (periodInterval:string):void=>{
        this.periodInterval = periodInterval;
    }
    
    public loadJson= (jsonCollection):any =>{
        //if json then make a javascript object else use the javascript object
        //if coldfusion has double encoded the json keep calling fromJson until it becomes an object
        while(angular.isString(jsonCollection)){
            jsonCollection = angular.fromJson(jsonCollection);
        }
        

        this.baseEntityAlias = jsonCollection.baseEntityAlias;
        this.baseEntityName = jsonCollection.baseEntityName;
        this.collection = this.$hibachi.getEntityExample(this.baseEntityName);
        if(angular.isUndefined(this.baseEntityAlias)){
            this.baseEntityAlias = '_' + this.baseEntityName.toLowerCase();
        }
        if(angular.isDefined(jsonCollection.filterGroups)){
            this.validateFilter(jsonCollection.filterGroups);
            this.filterGroups = jsonCollection.filterGroups;
        }
        this.columns = jsonCollection.columns;
        this.joins = jsonCollection.joins;
        this.keywords = jsonCollection.keywords;
        this.orderBy = jsonCollection.orderBy;
        this.groupBys = jsonCollection.groupBys;
        this.pageShow = jsonCollection.pageShow;
        this.allRecords = jsonCollection.allRecords;
        if(jsonCollection.dirtyRead){
            this.dirtyRead = jsonCollection.dirtyRead;
        }
        this.isDistinct = jsonCollection.isDistinct;
        this.reportFlag = jsonCollection.reportFlag;
        this.useElasticSearch = jsonCollection.useElasticSearch;

        this.periodInterval = jsonCollection.periodInterval;
        this.currentPage = jsonCollection.currentPage || 1;
        this.pageShow = jsonCollection.pageShow || 10;
        this.keywords = jsonCollection.keywords;
        return this;
    };

    public clone= () =>{
        return this.newCollectionConfig(this.baseEntityName, this.baseEntityAlias).loadJson(JSON.parse(angular.toJson(this.getCollectionConfig())));
    }

    public loadFilterGroups= (filterGroupsConfig:Array<any>=[{filterGroup: []}]):CollectionConfig =>{
        this.filterGroups = filterGroupsConfig;
        return this;
    };

    public loadColumns= (columns:Column[]):CollectionConfig =>{
        this.columns = columns;
        return this;
    };

    public getCollectionConfig= (validate=true):any =>{
        if(validate){
            this.validateFilter(this.filterGroups);
        }
        return {
            baseEntityAlias: this.baseEntityAlias,
            baseEntityName: this.baseEntityName,
            columns: this.columns,
            keywordColumns: this.keywordColumns,
            filterGroups: this.filterGroups,
            joins: this.joins,
            groupBys: this.groupBys,
            currentPage: this.currentPage,
            pageShow: this.pageShow,
            keywords: this.keywords,
            defaultColumns: (!this.columns || !this.columns.length),
            useElasticSearch: this.useElasticSearch,
            allRecords: this.allRecords,
            dirtyRead: this.dirtyRead,
            isDistinct: this.isDistinct,
            orderBy:this.orderBy,
            periodInterval:this.periodInterval
        };
    };



    public getEntityName= ():string =>{
        return this.baseEntityName.charAt(0).toUpperCase() + this.baseEntityName.slice(1);
    };

    public getOptions= (): Object =>{
        this.validateFilter(this.filterGroups);

        var columns = this.columns;

        if(this.keywords && this.keywords.length && this.keywordFilterGroups[0].filterGroup.length > 0){
            var filters = this.keywordFilterGroups;
        } else {
            var filters = this.filterGroups
        }
        var options= {
            columnsConfig: angular.toJson(columns),
            filterGroupsConfig: angular.toJson(filters),
            joinsConfig: angular.toJson(this.joins),
            orderByConfig:angular.toJson(this.orderBy),
            groupBysConfig: angular.toJson(this.groupBys),
            currentPage: this.currentPage,
            pageShow: this.pageShow,
            keywords: this.keywords,
            defaultColumns: (!this.columns || !this.columns.length),
            useElasticSearch: this.useElasticSearch,
            allRecords: this.allRecords,
            dirtyRead: this.dirtyRead,
            isDistinct: this.isDistinct,
            isReport:this.isReport(),
            periodInterval:this.periodInterval
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
        //if already starts with alias, strip it out
        if(propertyIdentifier.lastIndexOf(this.baseEntityAlias, 0) === 0){
            propertyIdentifier = propertyIdentifier.slice(this.baseEntityAlias.length+1);
        }
        var _propertyIdentifier = this.baseEntityAlias;
        if(addJoin === true){
            _propertyIdentifier +=  this.processJoin(propertyIdentifier)
        }else{
            _propertyIdentifier += '.' + propertyIdentifier;
        }
        return _propertyIdentifier;
    };


    private processJoin = (propertyIdentifier:string):string => {
        var _propertyIdentifier = '',
            propertyIdentifierParts = propertyIdentifier.split('.'),
            current_collection = this.collection;
        for (var i = 0; i < propertyIdentifierParts.length; i++) {
            if (angular.isDefined(current_collection.metaData[propertyIdentifierParts[i]]) && ('cfc' in current_collection.metaData[propertyIdentifierParts[i]])) {
                current_collection = this.$hibachi.getEntityExample(current_collection.metaData[propertyIdentifierParts[i]].cfc);
                _propertyIdentifier += '_' + propertyIdentifierParts[i];

                this.addJoin(new Join(
                    _propertyIdentifier.replace(/_([^_]+)$/,'.$1').substring(1),
                    this.baseEntityAlias + _propertyIdentifier
                ));
            } else {
                _propertyIdentifier += '.' + propertyIdentifierParts[i];
            }
        }

        return _propertyIdentifier;
    };


    private addJoin= (join:Join):any =>{
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

        return this;
    };

    private addAlias= (propertyIdentifier:string):string =>{
        var parts = propertyIdentifier.split('.');
        if(parts.length > 1 && parts[0] !== this.baseEntityAlias){
            return this.baseEntityAlias+'.'+propertyIdentifier;
        }
        return propertyIdentifier;
    };

    public addColumn= (column: string, title: string = '', options:any = {}):CollectionConfig =>{
        if(!this.columns || this.isReport() || options.aggregate != null || this.utilityService.ArrayFindByPropertyValue(this.columns,'propertyIdentifier',column) === -1){
            var isVisible = true,
                isDeletable = true,
                isSearchable = true,
                isExportable = true,
                persistent ,
                type = 'none',
                ormtype = 'string',
                lastProperty=column.split('.').pop(),
                isKeywordColumn=true,
                isOnlyKeywordColumn=false
                ;
            var lastEntity = this.$hibachi.getEntityExample(this.$hibachi.getLastEntityNameInPropertyIdentifier(this.baseEntityName,column));
            if(angular.isUndefined(lastEntity)){
                throw("You have passed an incorrect entity name to a collection config");
            }

            if(angular.isUndefined(this.columns)){
                this.columns = [];
            }
            //hide id columns
            if(angular.isDefined(options['isVisible'])){
                isVisible = options['isVisible'];
            }
            if( angular.isUndefined(options.isVisible) &&
                column.substring(column.length - 2) === "ID"
            ){
                isVisible = false;
            }
            if(angular.isDefined(options['isDeletable'])){
                isDeletable = options['isDeletable'];
            }
            if(angular.isDefined(options['isSearchable'])){
                isSearchable = options['isSearchable'];
            }
            if(angular.isDefined(options['isExportable'])){
                isExportable = options['isExportable'];
            }
            if(angular.isUndefined(options['isExportable']) && !isVisible){
                isExportable = false;
            }
            
            if(angular.isDefined(options['ormtype'])){
                ormtype = options['ormtype'];
            }else if(lastEntity.metaData[lastProperty] && lastEntity.metaData[lastProperty].ormtype){
                ormtype = lastEntity.metaData[lastProperty].ormtype;
            }
            if(angular.isDefined(options['type']) && options['type'] != 'none'){
                type = options['type'];
            }else if(lastEntity.metaData[lastProperty] && lastEntity.metaData[lastProperty].hb_formattype){
                type = lastEntity.metaData[lastProperty].hb_formattype;
            }
            
            if(angular.isDefined(options['isKeywordColumn'])){
                isKeywordColumn = options['isKeywordColumn']
            }
             if(angular.isDefined(options['isOnlyKeywordColumn'])){
                isOnlyKeywordColumn = options['isOnlyKeywordColumn']
            }

            if(angular.isDefined(lastEntity.metaData[lastProperty])){
                persistent = lastEntity.metaData[lastProperty].persistent;
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
                options['attributeSetObject'],
                type
            );
            
            //isMetric and isPeriod for reporting only reporting
            if(options['isMetric']){
                columnObject['isMetric'] = options['isMetric'];
            }
            if(options['isPeriod']){
                columnObject['isPeriod'] = options['isPeriod'];
            }
            
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

            if(!isOnlyKeywordColumn){
                this.columns.push(columnObject);
            }
            if(isKeywordColumn){
                this.keywordColumns.push(columnObject);
            }
        }
        return this;
    };

    public setUseElasticSearch = (flag:boolean=false):CollectionConfig =>{
        this.useElasticSearch = flag;
        return this;
    };

    public setDisplayProperties= (propertyIdentifier: string, title: string = '', options:any = {}):CollectionConfig =>{
        this.addDisplayProperty(propertyIdentifier, title, options);
        return this;
    };

    public addDisplayAggregate=(propertyIdentifier:string,aggregateFunction:string,aggregateAlias?:string,options?)=>{
        if(angular.isUndefined(aggregateAlias)){
            aggregateAlias = propertyIdentifier.replace(/\./g, '_')+aggregateFunction;
        }
        var column = {
            propertyIdentifier:this.formatPropertyIdentifier(propertyIdentifier, true),
            title : this.rbkeyService.getRBKey("entity."+this.$hibachi.getLastEntityNameInPropertyIdentifier(this.baseEntityName,propertyIdentifier)+"."+this.utilityService.listLast(propertyIdentifier, '.')),
            aggregate:{
                aggregateFunction:aggregateFunction,
                aggregateAlias:aggregateAlias
            }
        };

        angular.extend(column,options);
        //Add columns
        this.addColumn(column.propertyIdentifier,undefined,column);
        return this;
    };

    public addGroupBy = (groupByAlias):CollectionConfig=>{
        if(!this.groupBys){
            this.groupBys = '';
        }
        this.groupBys = this.utilityService.listAppendUnique(this.groupBys,groupByAlias);
        return this;
    };

    public addDisplayProperty= (propertyIdentifier: string, title: string = '', options:any = {}):CollectionConfig =>{
        var _DividedColumns = propertyIdentifier.trim().split(',');
        var _DividedTitles = title.trim().split(',');
        var join = propertyIdentifier.split('.').length > 1;
        _DividedColumns.forEach((column:string, index)  => {
            column = column.trim();
            if(angular.isDefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                title = _DividedTitles[index].trim();
            }else {
                title = this.rbkeyService.getRBKey("entity."+this.$hibachi.getLastEntityNameInPropertyIdentifier(this.baseEntityName,column)+"."+this.utilityService.listLast(column, "."));
            }
            this.addColumn(this.formatPropertyIdentifier(column, join),title, options);
        });
        return this;
    };

    public addFilter= (
        propertyIdentifier: string,
        value: any,
        comparisonOperator: string = '=',
        logicalOperator?: string,
        hidden:boolean=false,
        isKeywordFilter=true,
        isOnlyKeywordFilter=false,
        filterGroupAlias? : string,
        filterGroupLogicalOperator:string='AND'
    ):CollectionConfig =>{
        if(!this.filterGroups[0].filterGroup.length){
            logicalOperator = undefined;
        }

        if(propertyIdentifier.split('.').length > 1){
            this.processJoin(propertyIdentifier);
        }
		//create filter
		
        var filter = this.createFilter(propertyIdentifier, value, comparisonOperator, logicalOperator, hidden);
        var filterGroupIndex = 0;
        var filterGroup = this.filterGroups[0].filterGroup;
        if(filterGroupAlias){
            filterGroup = this.addFilterGroupWithAlias(filterGroupAlias, filterGroupLogicalOperator);
            this.filterGroupAliasMap[filterGroupAlias] = this.filterGroups[0].filterGroup.length-1;
            filterGroupIndex = this.filterGroups[0].filterGroup.length-1;
        }
        if(filterGroup.filterGroup){
            filterGroup.filterGroup.push(filter);
        }else{
            
            filterGroup.push(filter);
        }
        
        this.notify('collectionConfigUpdated', {
            collectionConfig: this
        });
        return this;
    };

    public addLikeFilter= (propertyIdentifier: string, value: any, pattern: string = '%w%',  logicalOperator?: string, displayPropertyIdentifier?:string,hidden:boolean=false):CollectionConfig =>{

        //if filterGroups does not exists then set a default
        if(!this.filterGroups){
            this.filterGroups = [{filterGroup:[]}];
        }
        //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
        if(this.filterGroups[0].filterGroup.length && !logicalOperator) logicalOperator = 'AND';

        var join = propertyIdentifier.split('.').length > 1;
        if(angular.isUndefined(displayPropertyIdentifier)){
            displayPropertyIdentifier = this.rbkeyService.getRBKey("entity."+this.$hibachi.getLastEntityNameInPropertyIdentifier(this.baseEntityName,propertyIdentifier)+"."+this.utilityService.listLast(propertyIdentifier))
        }

        //create filter group
        var filter = new Filter(
            this.formatPropertyIdentifier(propertyIdentifier, join),
            value,
            'like',
            logicalOperator,
            displayPropertyIdentifier,
            value,
            hidden,
            pattern
        );

        this.filterGroups[0].filterGroup.push(filter);
        this.notify('collectionConfigUpdated', {
            collectionConfig: this
        });
        return this;
    };

    public createFilter= (propertyIdentifier: string, value: any, comparisonOperator: string = '=', logicalOperator?: string, hidden:boolean=false):Filter =>{

        //if filterGroups does not exists then set a default
        if(!this.filterGroups){
            this.filterGroups = [{filterGroup:[]}];
        }

        //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
        if(this.filterGroups[0].filterGroup.length && !logicalOperator) logicalOperator = 'AND';

        var join = propertyIdentifier.split('.').length > 1;
        //create filter group
        var filter = new Filter(
            this.formatPropertyIdentifier(propertyIdentifier, join),
            value,
            comparisonOperator,
            logicalOperator,
            propertyIdentifier.split('.').pop(),
            value,
            hidden
        );
        return filter;
    };

    public addFilterGroup = (filterGroup:any):CollectionConfig =>{
        var group = {
            filterGroup:[],
            logicalOperator: 'AND'
        };
        for(var i =  0; i <= filterGroup.length-1; i++){
            var filter = this.createFilter(
                filterGroup[i].propertyIdentifier,
                filterGroup[i].comparisonValue,
                filterGroup[i].comparisonOperator,
                filterGroup[i].logicalOperator,
                filterGroup[i].hidden
            );
            group.filterGroup.push(filter);
        }

        this.filterGroups[0].filterGroup.push(group);
        this.notify('collectionConfigUpdated', {
            collectionConfig: this
        });
        return this;
    };
    public formatFilterGroup = (filterGroup:any, filterGroupLogicalOperator:string) => {
        var group = {
            filterGroup:[]
        };

        if(angular.isDefined(filterGroupLogicalOperator) && filterGroupLogicalOperator.length > 0){
            group["logicalOperator"] = filterGroupLogicalOperator;
        }
        for(var i =  0; i < filterGroup.length; i++){
            var filter = this.createFilter(
                filterGroup[i].propertyIdentifier,
                filterGroup[i].comparisonValue,
                filterGroup[i].comparisonOperator,
                filterGroup[i].logicalOperator,
                filterGroup[i].hidden
            );
            group.filterGroup.push(filter);
        }
        return group;
    }
    
    public removeFilterGroupByFilterGroupAlias = ( filterGroupAlias:string):any =>{
        
        for(var i in this.filterGroups[0].filterGroup){
            if(
                this.filterGroups[0].filterGroup[i].filterGroupAlias 
                && this.filterGroups[0].filterGroup[i].filterGroupAlias == filterGroupAlias
            ){
                this.filterGroups[0].filterGroup.splice(i,1);  
                break
            }
        }
    };

    public getFilterGroupIndexByFilterGroupAlias = ( filterGroupAlias:string, filterGroupLogicalOperator?:string):any =>{
        if(!this.filterGroups){
            this.filterGroups = [{filterGroup:[]}];
        }
        return this.filterGroupAliasMap[filterGroupAlias];
    };

    public addFilterGroupWithAlias = (filterGroupAlias:string, filterGroupLogicalOperator?:string):any =>{
        for(var i in this.filterGroups[0].filterGroup){
            if(this.filterGroups[0].filterGroup[i].filterGroupAlias){
                return this.filterGroups[0].filterGroup[i];
            }
        }
        var newFilterGroup = {"filterGroup": []};
        if(angular.isDefined(filterGroupLogicalOperator) && filterGroupLogicalOperator.length > 0 && this.filterGroups[0].filterGroup.length > 0){
            newFilterGroup["logicalOperator"] = filterGroupLogicalOperator;
        }else if (this.filterGroups[0].filterGroup.length > 0){
            newFilterGroup["logicalOperator"] = "AND";
        }
        newFilterGroup['filterGroupAlias'] = filterGroupAlias;
        this.filterGroups[0].filterGroup.push(newFilterGroup);
        return newFilterGroup;
    };

    public upsertFilterGroup = (filterGroupName:string, filterGroup:any):CollectionConfig=>{
        var filterGroupIndex = this.getFilterGroupIndexByFilterGroupAlias(filterGroupName);
        var logicalOperator = "";
        if(this.filterGroups[0].filterGroup[filterGroupIndex].logicalOperator){
            logicalOperator = this.filterGroups[0].filterGroup[filterGroupIndex].logicalOperator;
        }
        this.filterGroups[0].filterGroup[filterGroupIndex] = this.formatFilterGroup(filterGroup, logicalOperator);
        return this;
    };

    public removeFilter = (propertyIdentifier: string, value: any, comparisonOperator: string = '=')=>{
        this.removeFilterHelper(this.filterGroups, propertyIdentifier, value, comparisonOperator);
        this.notify('collectionConfigUpdated', {
            collectionConfig: this
        });
        return this;
    };

    public removeFilterByDisplayPropertyIdentifier = (displayPropertyIdentifier) =>{
        this.removeFromFilterGroupsByPropertyIdentifier(this.filterGroups, displayPropertyIdentifier);
        this.removeFromFilterGroupsByPropertyIdentifier(this.keywordFilterGroups, displayPropertyIdentifier);
    }

    private removeFromFilterGroupsByPropertyIdentifier = (filterGroups, displayPropertyIdentifier) =>{
        for( var j = 0; j < filterGroups.length; j++){
            var filterGroup = filterGroups[j].filterGroup;
            for( var i = 0; i < filterGroup.length; i++){
                var filter = filterGroup[i];
                if(filter.displayPropertyIdentifier == displayPropertyIdentifier){
                    filterGroup.splice(i, 1);
                    i--;
                }
            }
        }
    }

    public removeFilterHelper = (filter:any, propertyIdentifier:string, value:any, comparisonOperator:string, currentGroup?)=>{
        if(angular.isUndefined(currentGroup)){
            currentGroup = filter;
        }
        if(angular.isArray(filter)){
            angular.forEach(filter,(key)=>{
                this.removeFilterHelper(key, propertyIdentifier, value, comparisonOperator, filter);
            })
        }else if(angular.isArray(filter.filterGroup)){
            this.removeFilterHelper(filter.filterGroup, propertyIdentifier, value, comparisonOperator, filter.filterGroup);
        }else{
            if(filter.propertyIdentifier == propertyIdentifier && filter.value == value && filter.comparisonOperator == comparisonOperator){
                currentGroup.splice(currentGroup.indexOf(filter), 1);
            }
        }
    };

    public addCollectionFilter= (propertyIdentifier: string, displayPropertyIdentifier:string, displayValue:string,
                                 collectionID: string, criteria:string='One', fieldtype?:string, readOnly:boolean=false
    ):CollectionConfig =>{
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
        this.notify('collectionConfigUpdated', {
            collectionConfig: this
        });
        return this;
    };
    //orderByList in this form: "property|direction" concrete: "skuName|ASC"
    public setOrderBy = (orderByList):CollectionConfig=>{
        var orderBys = orderByList.split(',');
        angular.forEach(orderBys,(orderBy)=>{
            this.addOrderBy(orderBy);
        });
        return this;
    };

    public clearOrderBy=() =>{
        this.orderBy = [];
    }

    public addOrderBy = (orderByString, formatPropertyIdentifier:boolean = true):void=>{
        if(!this.orderBy){
            this.orderBy = [];
        }

        var propertyIdentifier = this.utilityService.listFirst(orderByString,'|');
        if(formatPropertyIdentifier){
            propertyIdentifier = this.formatPropertyIdentifier(propertyIdentifier);
        }
        var direction = this.utilityService.listLast(orderByString,'|');

        var orderBy = {
            propertyIdentifier:propertyIdentifier,
            direction:direction
        };

        this.orderBy.push(orderBy);
    };

    public toggleOrderBy = (formattedPropertyIdentifier:string, singleColumn:boolean=false) => {

        if(!this.orderBy){
            this.orderBy = [];
        }
        var found = false;
        for(var i = this.orderBy.length - 1; i >= 0; i--){
            if(this.orderBy[i].propertyIdentifier == formattedPropertyIdentifier){
                found = true;
                if(this.orderBy[i].direction.toUpperCase() == "DESC" ){
                    this.orderBy[i].direction = "ASC";
                } else if(this.orderBy[i].direction.toUpperCase() == "ASC") {
                    this.orderBy.splice(i,1);
                }
                break;
            }
        }
        var direction = 'desc';

        if(singleColumn){
            this.orderBy = [];

            for(var i =  0; i < this.columns.length; i++){
                if(!this.columns[i]["sorting"]){
                    this.columns[i]["sorting"] = {};
                }
                if(angular.isUndefined(this.columns[i]["sorting"]["active"])){
                    this.columns[i]["sorting"]["active"] = false;
                }
                if(this.columns[i]['propertyIdentifier'] == formattedPropertyIdentifier){
                    this.columns[i]["sorting"]["active"] = true;
                    this.columns[i]["sorting"]["priority"] = 1;
                    if(!this.columns[i]["sorting"]["sortOrder"] || this.columns[i]["sorting"]["sortOrder"] === 'desc'){
                        this.columns[i]["sorting"]["sortOrder"] = 'asc';
                        direction = 'asc';
                    }else{
                        this.columns[i]["sorting"]["sortOrder"] = 'desc';
                        direction = 'desc';
                    }
                }else if(this.columns[i]["sorting"] && this.columns[i]["sorting"]["active"]){
                    this.columns[i]["sorting"]["active"] = false;
                    this.columns[i]["sorting"]["sortOrder"] = 'asc';
                }

            }

        }

        this.addOrderBy(formattedPropertyIdentifier + '|'+direction, false);

        this.notify('swPaginationAction',{type:'setCurrentPage',payload:1});
    };

    public removeOrderBy = (formattedPropertyIdentifier:string) => {
        angular.forEach(this.orderBy, (orderBy, index)=>{
            if(orderBy.propertyIdentifier == formattedPropertyIdentifier){
                this.orderBy.splice(index,1);
                return true;
            }
        });
        return false;
    };
    
    public getPeriodColumnFromColumns(columns:any){
        for(var i in columns){
            var column = columns[i];
            if(column.isPeriod){
                return column;
            }            
        }
    }

    public setCurrentPage= (pageNumber):CollectionConfig =>{
        this.currentPage = pageNumber;
        return this;
    };

    public getCurrentPage= () =>{
        return this.currentPage;
    };

    public setPageShow= (NumberOfPages):CollectionConfig =>{
        this.pageShow = NumberOfPages;
        return this;
    };

    public getPageShow=():number=>{
        return this.pageShow;
    };

    public setAllRecords= (allFlag:boolean=false):CollectionConfig =>{
        this.allRecords = allFlag;
        return this;
    };

    public setDistinct = (flag:boolean=true)=>{
        this.isDistinct =  flag;
        return this;
    };

    public setDirtyRead = (flag:boolean=false)=>{
        this.dirtyRead = flag;
        return this;
    }

    public setKeywords= (keyword) =>{
        this.keywords = keyword;
        return this;
    };

    private setId=(id):CollectionConfig=>{
        this.id = id;
        return this;
    };

    private setEventID=(eventID):CollectionConfig=>{
        this.eventID = eventID;
        return this;
    };

    public hasFilters=():boolean=>{
        return (this.filterGroups.length && this.filterGroups[0].filterGroup.length);
    };

    public hasColumns=():boolean=>{
        return this.columns != null && this.columns.length > 0;
    };

    public clearFilters=():CollectionConfig =>{
        this.filterGroups = [{filterGroup:[]}];
        return this;
    };

    public getEntity=(id?)=>{
        if (angular.isDefined(id)){
            this.setId(id);
        }
        if(this.baseEntityNameType){
            return this.$hibachi.getEntity(this.baseEntityNameType, this.getOptions());
        }else{
            return this.$hibachi.getEntity(this.baseEntityName, this.getOptions());
        }
    };

    private validateFilter = (filter, currentGroup?)=>{
        
        if(angular.isUndefined(currentGroup)){
            currentGroup = filter;
        }
        if(angular.isArray(filter)){
            angular.forEach(filter,(key)=>{
                this.validateFilter(key, filter);
            })
        }else if(angular.isArray(filter.filterGroup)){
            this.validateFilter(filter.filterGroup,filter.filterGroup);
        }else{
            if(
                (
                    (!filter.comparisonOperator || !filter.comparisonOperator.length) 
                    && (!filter.propertyIdentifier || !filter.propertyIdentifier.length)
                ) 
            ){
                
                var index = currentGroup.indexOf(filter);
                if(index > -1) {
                    this.notify('filterItemAction', {
                        action: 'remove',
                        filterItemIndex: index
                    });
                    currentGroup.splice(index, 1);
                }
            }
        }
    };

    public getColumns=()=>{
        if(!this.columns){
            this.columns = [];
        }
        return this.columns;
    };

    public setColumns=(columns)=>{
        this.columns = columns;
        return this;
    }

    private notify(name, data){
        if(angular.isDefined(this.eventID)){
            this.observerService.notifyById(name, this.eventID, data);
        }else{
            this.observerService.notify(name, data);
        }
    }

}

export {
    Column,
    Filter,
    IFilter,
    CollectionFilter,
    Join,
    OrderBy,
    IOrderBy,
    CollectionConfig
};
