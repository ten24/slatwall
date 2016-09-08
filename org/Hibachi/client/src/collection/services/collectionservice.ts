/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*collection service is used to maintain the state of the ui*/
import {PageDialog} from "../../dialog/model/pagedialog";
import {IFilter} from "./collectionconfigservice";
import {BaseEntityService} from "../../core/services/baseentityservice";
class CollectionService extends BaseEntityService{
    private _pageDialogs;
    private _collection;
    private _collectionConfig;
    private _filterPropertiesList;
    private _filterCount;
    private _orderBy;


    //@ngInject
    constructor(
        public $injector:ng.auto.IInjectorService,
        public $hibachi,
        public utilityService,
        private $filter:ng.IFilterService,
        private $log:ng.ILogService
    ){
        super($injector,$hibachi,utilityService,'Collection');
        this.$filter = $filter;
        this.$log = $log;
        this._collection = null;
        this._collectionConfig = null;
        this._filterPropertiesList = {};
        this._filterCount = 0;
        this._orderBy = $filter('orderBy');
    }

    get = (): PageDialog[] =>{
        return this._pageDialogs || [];
    }

    //test
    setFilterCount = (count:number):void =>{
        this.$log.debug('incrementFilterCount');
        this._filterCount = count;
    }

    getFilterCount = ():number =>{
        return this._filterCount;
    }

    getColumns = ():any =>{
        return this._collection.collectionConfig.columns;
    }

    getFilterPropertiesList = ():any =>{
        return this._filterPropertiesList;
    }

    getFilterPropertiesListByBaseEntityAlias = (baseEntityAlias:string):any =>{
        return this._filterPropertiesList[baseEntityAlias];
    }

    setFilterPropertiesList = (value:any,key:string):void =>{
        if(angular.isUndefined(this._filterPropertiesList[key])){
            this._filterPropertiesList[key] = value;
        }
    }

    stringifyJSON = (jsonObject:any):string =>{
        var jsonString = angular.toJson(jsonObject);
        return jsonString;
    }

    removeFilterItem = (filterItem:any,filterGroup:any):void =>{
        filterGroup.pop(filterGroup.indexOf(filterItem));
    }

    selectFilterItem = (filterItem:any):void =>{
        if(filterItem.$$isClosed){
            for(var i in filterItem.$$siblingItems){
                filterItem.$$siblingItems[i].$$isClosed = true;
                filterItem.$$siblingItems[i].$$disabled = true;
            }
            filterItem.$$isClosed = false;
            filterItem.$$disabled = false;
            filterItem.setItemInUse(true);
        }else{
            for(var i in filterItem.$$siblingItems){
                filterItem.$$siblingItems[i].$$disabled = false;
            }
            filterItem.$$isClosed = true;
            filterItem.setItemInUse(false);
        }

    }

    selectFilterGroupItem = (filterGroupItem:any):void =>{
        if(filterGroupItem.$$isClosed){
            for(var i in filterGroupItem.$$siblingItems){
                filterGroupItem.$$siblingItems[i].$$disabled = true;
            }
            filterGroupItem.$$isClosed = false;
            filterGroupItem.$$disabled = false;
        }else{
            for(var i in filterGroupItem.$$siblingItems){
                filterGroupItem.$$siblingItems[i].$$disabled = false;
            }
            filterGroupItem.$$isClosed = true;
        }
        filterGroupItem.setItemInUse(!filterGroupItem.$$isClosed);
    }

    newFilterItem = (filterItemGroup:any,setItemInUse:any,prepareForFilterGroup:any) =>{
        if(angular.isUndefined(prepareForFilterGroup)){
            prepareForFilterGroup = false;
        }
        var filterItem:any = {
                displayPropertyIdentifier:"",
                propertyIdentifier:"",
                comparisonOperator:"",
                value:"",
                $$disabled:false,
                $$isClosed:true,
                $$isNew:true,
                $$siblingItems:filterItemGroup,
                setItemInUse:setItemInUse
            };
        if(filterItemGroup.length !== 0){
            filterItem.logicalOperator = "AND";
        }

        if(prepareForFilterGroup === true){
            filterItem.$$prepareForFilterGroup = true;
        }

        filterItemGroup.push(filterItem);


        this.selectFilterItem(filterItem);

        return (filterItemGroup.length - 1);
    };

    newFilterGroupItem = (filterItemGroup:any,setItemInUse:any):void =>{
        var filterGroupItem:any = {
            filterGroup:[],
            $$disabled:"false",
            $$isClosed:"true",
            $$siblingItems:filterItemGroup,
            $$isNew:"true",
            setItemInUse:setItemInUse
        };
        if(filterItemGroup.length !== 0){
            filterGroupItem.logicalOperator = "AND";
        }
        filterItemGroup.push(filterGroupItem);
        this.selectFilterGroupItem(filterGroupItem);

        this.newFilterItem(filterGroupItem.filterGroup,setItemInUse,undefined);
    }

    transplantFilterItemIntoFilterGroup = (filterGroup:any,filterItem:any):void =>{
        var filterGroupItem:any = {
            filterGroup:[],
            $$disabled:"false",
            $$isClosed:"true",
            $$isNew:"true"
        };
        if(angular.isDefined(filterItem.logicalOperator)){
            filterGroupItem.logicalOperator = filterItem.logicalOperator;
            delete filterItem.logicalOperator;
        }
        filterGroupItem.setItemInUse = filterItem.setItemInUse;
        filterGroupItem.$$siblingItems = filterItem.$$siblingItems;
        filterItem.$$siblingItems = [];


        filterGroup.pop(filterGroup.indexOf(filterItem));
        filterItem.$$prepareForFilterGroup = false;
        filterGroupItem.filterGroup.push(filterItem);
        filterGroup.push(filterGroupItem);
    }

    formatFilterPropertiesList = (filterPropertiesList:any,propertyIdentifier:string):void =>{
        this.$log.debug('format Filter Properties List arguments 2');
        this.$log.debug(filterPropertiesList);
        this.$log.debug(propertyIdentifier);
        var simpleGroup = {
                $$group:'simple',
                displayPropertyIdentifier:'-----------------'
        };

        filterPropertiesList.data.push(simpleGroup);
        var drillDownGroup = {
                $$group:'drilldown',
                displayPropertyIdentifier:'-----------------'
        };

        filterPropertiesList.data.push(drillDownGroup);

        var compareCollections = {
                $$group:'compareCollections',
                displayPropertyIdentifier:'-----------------'
        };

        filterPropertiesList.data.push(compareCollections);

        var attributeCollections = {
                $$group:'attribute',
                displayPropertyIdentifier:'-----------------'
        };

        filterPropertiesList.data.push(attributeCollections);

        for(var i in filterPropertiesList.data){
            if(angular.isDefined(filterPropertiesList.data[i].ormtype)){
                if(angular.isDefined(filterPropertiesList.data[i].attributeID)){
                    filterPropertiesList.data[i].$$group = 'attribute';
                }else{
                    filterPropertiesList.data[i].$$group = 'simple';
                }
            }
            if(angular.isDefined(filterPropertiesList.data[i].fieldtype)){
                if(filterPropertiesList.data[i].fieldtype === 'id'){
                    filterPropertiesList.data[i].$$group = 'simple';
                }
                if(filterPropertiesList.data[i].fieldtype === 'many-to-one'){
                    filterPropertiesList.data[i].$$group = 'drilldown';
                }
                if(filterPropertiesList.data[i].fieldtype === 'many-to-many' || filterPropertiesList.data[i].fieldtype === 'one-to-many'){
                    filterPropertiesList.data[i].$$group = 'compareCollections';
                }
            }

            filterPropertiesList.data[i].propertyIdentifier = propertyIdentifier + '.' +filterPropertiesList.data[i].name;
        }
        filterPropertiesList.data = this._orderBy(filterPropertiesList.data,['-$$group','propertyIdentifier'],false);
    }

    orderBy = (propertiesList:string,predicate:string,reverse:boolean):any =>{
        return this._orderBy(propertiesList,predicate,reverse);
    }
}
export{
    CollectionService
}



