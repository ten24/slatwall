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
        private attributeSetObject?:string
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
    // @ngInject
    constructor(
        private rbkeyService:any,
        private $hibachi:any,
        private utilityService,
        public  baseEntityName?:string,
        public  baseEntityAlias?:string,
        public columns?:Column[],
        private filterGroups:Array<any>=[{filterGroup: []}],
        private joins?:Join[],
        private orderBy?:OrderBy[],
        private groupBys?:string,
        private id?:number,
        private currentPage:number = 1,
        private pageShow:number = 10,
        private keywords:string = '',
        private allRecords:boolean = false,
        private isDistinct:boolean = false

    ){
        console.log('abc');
        console.log(rbkeyService);
        console.log($hibachi);
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
        return this;
    };

    public newCollectionConfig=(baseEntityName?:string,baseEntityAlias?:string):CollectionConfig=>{
        return new CollectionConfig(this.rbkeyService, this.$hibachi, this.utilityService, baseEntityName, baseEntityAlias);
    };

    public loadJson= (jsonCollection):any =>{
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
        this.isDistinct = jsonCollection.isDistinct; 
        return this;
    };

public loadFilterGroups= (filterGroupsConfig:Array<any>=[{filterGroup: []}]):CollectionConfig =>{
        this.filterGroups = filterGroupsConfig;
        return this;
    };

    public loadColumns= (columns:Column[]):CollectionConfig =>{
        this.columns = columns;
        return this; 
    };

public getCollectionConfig= ():any =>{
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
            isDistinct: this.isDistinct
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
            allRecords: this.allRecords,
            isDistinct: this.isDistinct
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

            if (current_collection.metaData[propertyIdentifierParts[i]].cfc) {
                current_collection = this.$hibachi.getEntityExample(current_collection.metaData[propertyIdentifierParts[i]].cfc);
                _propertyIdentifier += '_' + propertyIdentifierParts[i];
                this.addJoin(new Join(
                    _propertyIdentifier.replace(/_/g, '.').substring(1),
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
        if(!this.columns || this.utilityService.ArrayFindByPropertyValue(this.columns,'propertyIdentifier',column) === -1){
            var isVisible = true,
                isDeletable = true,
                isSearchable = true,
                isExportable = true,
                persistent ,
                ormtype = 'string',
                lastProperty=column.split('.').pop()
                ;
            var lastEntity = this.$hibachi.getEntityExample(this.$hibachi.getLastEntityNameInPropertyIdentifier(this.baseEntityName,column));
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
        return this; 
    };


    public setDisplayProperties= (propertyIdentifier: string, title: string = '', options:any = {}):CollectionConfig =>{
        this.addDisplayProperty(propertyIdentifier, title, options);
        return this; 
    };

    public addDisplayAggregate=(propertyIdentifier:string,aggregateFunction:string,aggregateAlias:string,options?):CollectionConfig=>{
        var column = {
            propertyIdentifier:this.formatPropertyIdentifier(propertyIdentifier, true),
            title : this.rbkeyService.getRBKey("entity."+this.baseEntityName+"."+propertyIdentifier),
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
        this.groupBys = this.utilityService.listAppend(this.groupBys,groupByAlias);
        return this; 
    };

    public addDisplayProperty= (propertyIdentifier: string, title: string = '', options:any = {}):CollectionConfig =>{
        var _DividedColumns = propertyIdentifier.trim().split(',');
        var _DividedTitles = title.trim().split(',');
        _DividedColumns.forEach((column:string, index)  => {
            column = column.trim();
            if(angular.isDefined(_DividedTitles[index]) && _DividedTitles[index].trim() != '') {
                title = _DividedTitles[index].trim();
            }else {
                title = this.rbkeyService.getRBKey("entity."+this.baseEntityName+"."+column);
            }
            this.addColumn(this.formatPropertyIdentifier(column),title, options);
        });
        return this; 
    };

    public addFilter= (propertyIdentifier: string, value: any, comparisonOperator: string = '=', logicalOperator?: string):CollectionConfig =>{

        //if filterGroups does not exists then set a default
        if(!this.filterGroups){
            this.filterGroups = [{filterGroup:[]}];
        }

        //if filterGroups is longer than 0 then we at least need to default the logical Operator to AND
        if(this.filterGroups[0].filterGroup.length && !logicalOperator) logicalOperator = 'AND';

            if(propertyIdentifier.split('.').length < 2){
            var join = false; 
            } else { 
            var join = true;
            }

        //create filter group
        var filter = new Filter(
            this.formatPropertyIdentifier(propertyIdentifier, join),
            value,
            comparisonOperator,
            logicalOperator,
            propertyIdentifier.split('.').pop(),
            value
        );

        this.filterGroups[0].filterGroup.push(filter);
        return this; 
    };
    
    public removeFilter = (propertyIdentifier: string, value: any, comparisonOperator: string = '=')=>{
        this.removeFilterHelper(this.filterGroups, propertyIdentifier, value, comparisonOperator);
        return this; 
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

    public setCurrentPage= (pageNumber):CollectionConfig =>{
        this.currentPage = pageNumber;
        return this; 
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

    public setKeywords= (keyword):CollectionConfig =>{
        this.keywords = keyword;
        return this; 
    };

    private setId=(id):CollectionConfig=>{
        this.id = id;
        return this; 
    };

    public hasFilters=():boolean=>{
        return (this.filterGroups.length && this.filterGroups[0].filterGroup.length);
    };

    public clearFilters=():CollectionConfig =>{
        this.filterGroups = [{filterGroup:[]}];
        return this;
    };

    public getEntity=(id?)=>{
        if (angular.isDefined(id)){
            this.setId(id);
        }
        return this.$hibachi.getEntity(this.baseEntityName, this.getOptions());
    };

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
