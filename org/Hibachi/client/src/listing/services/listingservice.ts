/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Subject, Observable} from 'rxjs';
import * as Store from '../../../../../../org/Hibachi/client/src/core/prototypes/swstore';

class ListingService{

    private listingDisplays = {};
    private pageRecordKeys = {};
    private state = {};
    public listingDisplayStore: Store.IStore;

    //@ngInject
    constructor(private $timeout,
                private $q,
                private collectionConfigService,
                private filterService,
                private historyService,
                private observerService,
                private rbkeyService,
                private selectionService,
                private utilityService,
                private $hibachi,
                private localStorageService
    ){
        //Setup a store so that controllers can listing for state changes and fire action requests.
        //To create a store, we instantiate it using the object that holds the state variables,
        //and the reducer. We can also add a middleware to the end if you need.
        this.listingDisplayStore = new Store.IStore( this.state, this.listingDisplayStateReducer );

    }

    /**
     * The reducer is responsible for modifying the state of the state object into a new state for listeners.
     */
    public listingDisplayStateReducer:Store.Reducer = (state:any, action:Store.Action<string>):Object => {
        switch(action.type) {
            case 'LISTING_PAGE_RECORDS_UPDATE':
                return {
                    ...state, action
                };
            case 'CURRENT_PAGE_RECORDS_SELECTED':
                return {
                    ...state, action
                };
            case 'ADD_SELECTION':
                return {
                    ...state, action
                };
            default:
                return state;
        }
    }

    //Event Functions
    public getListingPageRecordsUpdateEventString = (listingID:string) => {
        return listingID + "pageRecordsUpdated";
    }

    public getListingOrderByChangedEventString = (listingID:string) => {
        return listingID + "orderByChanged";
    }

    public getListingInitiatedEventString = (listingID:string) =>{
        return listingID + "initiated";
    }

    public notifyListingPageRecordsUpdate = (listingID:string) =>{
        //This is how we would dispatch so that controllers can get the updated state.
        this.listingDisplayStore.dispatch({
            type: "LISTING_PAGE_RECORDS_UPDATE",
            payload: {listingID: listingID, listingPageRecordsUpdateEventString: this.getListingPageRecordsUpdateEventString(listingID) }
        });

        this.observerService.notify(this.getListingPageRecordsUpdateEventString(listingID), listingID);
    }

    public attachToListingPageRecordsUpdate = (listingID:string, callback, id:string) =>{
        this.observerService.attach(callback, this.getListingPageRecordsUpdateEventString(listingID), id);
    }

    public attachToOrderByChangedUpdate = (listingID:string, callback, id:string) =>{
        this.observerService.attach(callback, this.getListingOrderByChangedEventString(listingID), id);
    }

    public attachToListingInitiated = (listingID:string, callback) =>{
        this.observerService.attach(callback, this.getListingInitiatedEventString(listingID));
        if(this.historyService.hasHistory(this.getListingInitiatedEventString(listingID))){
            callback();
        }
    }
    //End Event Functions

    //core getters and setters
    public setListingState = (listingID:string, state) =>{
        this.listingDisplays[listingID] = state;
        this.observerService.notifyAndRecord(this.getListingInitiatedEventString(listingID));
    }

    public getListing = (listingID:string) => {
        return this.listingDisplays[listingID];
    }

    public getListingColumns = (listingID:string) =>{
        return this.getListing(listingID).columns || this.getListingCollectionConfigColumns(listingID);
    }

    public getListingCollectionConfigColumns = (listingID:string) =>{
        return this.getListing(listingID)?.collectionConfig?.columns;
    }

    public getListingExampleEntity = (listingID:string) =>{
        if(this.getListing(listingID).exampleEntity != null){
            return this.getListing(listingID).exampleEntity;
        } else {
            this.setupExampleEntity(listingID);
        }
    }

    public getListingCollectionConfigColumnIndexByPropertyIdentifier = (listingID:string, propertyIdentifier) =>{
        var columns = this.getListingCollectionConfigColumns(listingID);
        return this.utilityService.ArrayFindByPropertyValue(columns,'propertyIdentifier',propertyIdentifier);
    }

    public getListingColumnIndexByPropertyIdentifier = (listingID:string, propertyIdentifier) =>{
        var columns = this.getListingColumns(listingID);
        return this.utilityService.ArrayFindByPropertyValue(columns,'propertyIdentifier',propertyIdentifier);
    }

    public getListingBaseEntityName = (listingID:string) => {
        let currentListing = this.getListing(listingID);
        var baseEntityName = currentListing.baseEntityName || currentListing.collectionObject
        
        if( baseEntityName == null &&  currentListing.collectionConfig != null){
            baseEntityName = currentListing.collectionConfig.baseEntityName;
        }
        
        if(baseEntityName == null && currentListing.collectionData != null){
            baseEntityName = currentListing.collectionData.collectionObject;
        }
        return baseEntityName;
    }

    public getListingBaseEntityPrimaryIDPropertyName = (listingID:string) =>{
        if(this.getListingExampleEntity(listingID) != null){
            return this.getListingExampleEntity(listingID).$$getIDName();
        }
    }

    public getListingPrimaryEntityName = (listingID:string) =>{
        return this.getListing(listingID).baseEntityName ||
                this.getListing(listingID).collectionObject ||
                this.getListing(listingID).collectionConfig.baseEntityName;
    }

    public getListingEntityPrimaryIDPropertyName = (listingID:string) =>{
        return this.$hibachi.getPrimaryIDPropertyNameByEntityName(this.getListingPrimaryEntityName(listingID));
    }

    public getListingPageRecords = (listingID:string) =>{
        return this.getListing(listingID)?.collectionData?.pageRecords;
    }

    public getCollection = (listingID:string) =>{
        return this.getListing(listingID).getCollection();
    }

    public getPageRecordsWithManualSortOrder = (listingID:string) => {
        let currentListing = this.getListing(listingID);
        let pageRecords = this.getListingPageRecords(listingID);
        
        if(pageRecords) {
            let primaryIDPropertyName  = this.getListingEntityPrimaryIDPropertyName(listingID);
            let primaryIDWithBaseAlias = currentListing.collectionConfig.baseEntityAlias + '.' + primaryIDPropertyName;
            let primaryIDColumnIndex   = this.getListingCollectionConfigColumnIndexByPropertyIdentifier(listingID, primaryIDWithBaseAlias);

            let pageRecordsWithManualSortOrder = {};

            this.$timeout( () => {
                pageRecords.forEach( (record, index) => {
                    let primaryID = record[primaryIDPropertyName];
                    if(primaryID){
                        pageRecordsWithManualSortOrder[primaryID] = index + 1;
                    } 
                    else if(primaryIDColumnIndex !== -1){
                        let column = this.getListingCollectionConfigColumns(listingID)[primaryIDColumnIndex];
                        column?.fallbackPropertyIdentifiers?.split(",").forEach( propertyIdentifier => {
                            if( record[propertyIdentifier] ){
                               pageRecordsWithManualSortOrder[ record[propertyIdentifier] ] = index + 1;
                            }
                        });
                    }
                });
                
                currentListing.pageRecordsWithManualSortOrder = angular.toJson(pageRecordsWithManualSortOrder);
                return currentListing.pageRecordsWithManualSortOrders;
                
            }, 0);
        } 
        else {
            return angular.toJson({});
        }
    }

    //Begin Listing Page Record Functions
    public getListingPageRecordIndexByPageRecord = (listingID:string, pageRecordToCompare:any) =>{
        var pageRecords = this.getListingPageRecords(listingID);
        var primaryIDPropertyName = this.getListingEntityPrimaryIDPropertyName(listingID);
        for(var j = 0; j < pageRecords.length; j++){
            var pageRecord = pageRecords[j];
            if( pageRecord[primaryIDPropertyName] == pageRecordToCompare[primaryIDPropertyName] ){
                return j;
            }
        }
        return -1;
    }

    public insertListingPageRecord = (listingID:string, pageRecord:any) =>{
        pageRecord.newFlag = true;
        if( angular.isDefined(this.getListingPageRecords(listingID))){
            this.notifyListingPageRecordsUpdate(listingID);
            this.getListingPageRecords(listingID).unshift(pageRecord);//insert at beginning be default
        }
    }

    public removeListingPageRecord = (listingID:string, pageRecord) =>{
        var pageRecords = this.getListingPageRecords(listingID);
        if(this.getListingPageRecordIndexByPageRecord(listingID, pageRecord) != -1){
            this.notifyListingPageRecordsUpdate(listingID);
            return pageRecords.splice(this.getListingPageRecordIndexByPageRecord(listingID, pageRecord), 1)[0];//this will always be an array of one element
        }
    }

    public getPageRecordKey = (propertyIdentifier)=>{
        if(this.pageRecordKeys[propertyIdentifier] != null){
            return this.pageRecordKeys[propertyIdentifier];
        }
        if(propertyIdentifier){
            var propertyIdentifierWithoutAlias = '';
            if(propertyIdentifier.indexOf('_') === 0){
                 var underscoreCount = (propertyIdentifier.match(new RegExp("_", "g")||[])).length;
                 if(underscoreCount > 1){
                     var properSubStr = propertyIdentifier.substring(1);
                     propertyIdentifierWithoutAlias = properSubStr.substring(properSubStr.indexOf('_')+1,properSubStr.length);
                 }else{
                    propertyIdentifierWithoutAlias = propertyIdentifier.substring(propertyIdentifier.indexOf('.')+1);
                 }
            }else{
                propertyIdentifierWithoutAlias = propertyIdentifier;
            }
           this.pageRecordKeys[propertyIdentifier] = this.utilityService.replaceAll(propertyIdentifierWithoutAlias,'.','_');
           return this.pageRecordKeys[propertyIdentifier];
        }
        return '';
    };

    public getPageRecordValueByColumn = (pageRecord, column) =>{
        
        var pageRecordValue = pageRecord[this.getPageRecordKey(column.propertyIdentifier)] || "";

        //try to find the property again if we need to...
        if (pageRecordValue == ""){
            for (var property in pageRecord){
                if (property.indexOf(this.getPageRecordKey(column.propertyIdentifier).trim()) != -1){
                    //use this record
                    pageRecordValue = pageRecord[property];
                }
            }
        }
        //last change to find the value

        if( ( angular.isUndefined(pageRecordValue) ||
            ( angular.isString(pageRecordValue) && pageRecordValue.trim().length == 0) ) &&
              angular.isDefined(column.fallbackPropertyIdentifiers)
        ){
            var fallbackPropertyArray = column.fallbackPropertyIdentifiers.replace('.','_').split(",");
            for(var i=0; i<fallbackPropertyArray.length; i++){
                if(angular.isDefined(pageRecord[this.getPageRecordKey(fallbackPropertyArray[i])])){
                    pageRecordValue = pageRecord[this.getPageRecordKey(fallbackPropertyArray[i])];
                    break;
                }
            }
        }
        return pageRecordValue;
    }

    public selectCurrentPageRecords = (listingID) => {
        let currentListing = this.getListing(listingID);
        let primatyIdPropertyName = this.getListingBaseEntityPrimaryIDPropertyName(listingID);

        currentListing?.collectionData?.pageRecords?.forEach( (record, index) => {
            if( currentListing.isCurrentPageRecordsSelected == true ) {
                this.selectionService.addSelection( currentListing.tableID, record[primatyIdPropertyName]);
            } else {
                this.selectionService.removeSelection(currentListing.tableID, record[primatyIdPropertyName] );
            }
        });
    };

    /** returns the index of the item in the listing pageRecord by checking propertyName == recordID */
    public getSelectedBy = (listingID, propertyName, value) => {
        if (!listingID || !propertyName || !value){ return -1;};
        return this.getListing(listingID).collectionData.pageRecords.findIndex((record)=>{return record[propertyName] == value});
    }

    /** returns the index of the item in the listing pageRecord by checking propertyName == recordID */
    public getAllSelected = (listingID) => {
        if (!listingID) return -1;
        for(var i = 0; i < this.getListing(listingID).collectionData.pageRecords.length; i++){
            this.selectionService.getSelections(this.getListing(listingID).tableID,  this.getListingPageRecords(listingID)[i][this.getListingBaseEntityPrimaryIDPropertyName(listingID)]);
        }
    }

    public clearAllSelections = (listingID) => {
        if (!listingID) return -1;
        if(this.getListing(listingID)){
            for(var i = 0; i < this.getListing(listingID).collectionData.pageRecords.length; i++){
                this.selectionService.removeSelection(this.getListing(listingID).tableID,  this.getListingPageRecords(listingID)[i][this.getListingBaseEntityPrimaryIDPropertyName(listingID)]);
            }
            this.getListing(listingID).collectionConfig.getEntity().then(data=>{
                this.updatePageRecords(listingID,data);
            });
        }
    }
    
     public updatePageRecords = (listingID,data) =>{
         
        let currentListing = this.getListing(listingID);

        currentListing.setCollectionData(data);
        this.setupDefaultCollectionInfo(listingID);
        
        if(currentListing.collectionConfig != null && currentListing.collectionConfig.hasColumns()){
            this.setupColumns(listingID, currentListing.collectionConfig, currentListing.collectionObject);
        }else{
            currentListing.collectionConfig.loadJson(data.collectionConfig);
        }
        this.notifyListingPageRecordsUpdate(listingID);
        currentListing.collectionData.pageRecords = currentListing.collectionData.pageRecords ||
                                                                currentListing.collectionData.records;

        currentListing.paginator.setPageRecordsInfo( currentListing.collectionData );
        currentListing.searching = false;

        currentListing.columnCount = currentListing.columns.length + 1; 
        if(currentListing.selectable || currentListing.multiselectable || currentListing.sortable){
            currentListing.columnCount++; 
        }
    }

    public getNGClassObjectForPageRecordRow = (listingID:string, pageRecord)=>{
        var classObjectString = "{";
        angular.forEach(this.getListing(listingID).colorFilters, (colorFilter, index)=>{
            classObjectString = classObjectString.concat("'" + colorFilter.colorClass + "':" + this.getColorFilterConditionString(colorFilter, pageRecord));
            classObjectString = classObjectString.concat(",");
        });
        classObjectString = classObjectString.concat(" 's-child':" + this.getPageRecordIsChild(listingID, pageRecord));
        var newFlag = false;
        if(pageRecord && pageRecord.newFlag != null && typeof pageRecord.newFlag === 'string' && pageRecord.newFlag.trim() !== ''){
            newFlag = pageRecord.newFlag;
        }
        classObjectString = classObjectString.concat(",'s-selected-row':" + newFlag);
        classObjectString = classObjectString.concat(",'s-disabled':" + this.getPageRecordMatchesDisableRule(listingID, pageRecord));
        classObjectString = classObjectString.concat(",'s-edited':pageRecord.edited");
        return classObjectString + "}";
    };

    public getPageRecordIsChild = (listingID:string, pageRecord)=>{
        var isChild = false;
        //todo implement
        return isChild;
    };
    //End Listing Page Record Functions

    //Row Save Functionality
    private determineRowEdited = (pageRecords, pageRecordIndex) =>{
        var fieldCount = 0;
        for(var key in pageRecords[pageRecordIndex].editedFields){
            fieldCount++;
            if(fieldCount > 1){
                pageRecords[pageRecordIndex].edited = true;
                return true;
            }
        }
        pageRecords[pageRecordIndex].edited = false;
        return false;
    }

    public markUnedited = (listingID:string, pageRecordIndex, propertyDisplayID) => {
        var pageRecords = this.getListingPageRecords(listingID);
        if(angular.isDefined(pageRecords[pageRecordIndex].editedFields[propertyDisplayID])){
            delete pageRecords[pageRecordIndex].editedFields[propertyDisplayID];
        }
        return this.determineRowEdited(pageRecords,pageRecordIndex);
    }

    public markEdited = (listingID:string, pageRecordIndex, propertyDisplayID, saveCallback) => {
        var pageRecords = this.getListingPageRecords(listingID);
        if(angular.isUndefined(pageRecords[pageRecordIndex].editedFields) && !angular.isObject(pageRecords[pageRecordIndex].editedFields)){
            pageRecords[pageRecordIndex].editedFields = {};
        }
        pageRecords[pageRecordIndex].editedFields[propertyDisplayID] = saveCallback;
        return this.determineRowEdited(pageRecords,pageRecordIndex);
    }

    public markSaved = (listingID:string, pageRecordIndex) => {
        var pageRecords = this.getListingPageRecords(listingID);
        var savePromises = [];
        for(var key in pageRecords[pageRecordIndex].editedFields){
            if(angular.isFunction(pageRecords[pageRecordIndex].editedFields[key])){
                savePromises.push(pageRecords[pageRecordIndex].editedFields[key]());
            }
        }
        this.$q.all(savePromises).then(
            ()=>{
                delete pageRecords[pageRecordIndex].editedFields;
                pageRecords[pageRecordIndex].edited = false;
            }
        )
    }
    //End Row Save Functionality

    //Setup Functions
    public setupInSingleCollectionConfigMode = (listingID:string, listingDisplayScope) =>{
        
        let currentListing = this.getListing(listingID);

        if( currentListing.collectionObject != null && currentListing.collectionConfig != null ){
            currentListing.collectionObject = currentListing.collectionConfig.baseEntityName;
        }

        this.initCollectionConfigData( listingID, currentListing.collectionConfig );
        
        this.setupColumns( listingID, currentListing.collectionConfig, currentListing.collectionObject );

        listingDisplayScope.$watch('swListingDisplay.collectionPromise',(newValue,oldValue)=>{
            if(newValue){
                
                this.$q.when(currentListing.collectionPromise).then((data)=>{
                    
                    currentListing.setCollectionData(data);
                    
                    this.setupDefaultCollectionInfo(listingID);
                    
                    if(currentListing.collectionConfig != null && currentListing.collectionConfig.hasColumns()){
                        this.setupColumns(listingID, currentListing.collectionConfig, currentListing.collectionObject);
                    }
                    else{
                        currentListing.collectionConfig.loadJson(data.collectionConfig);
                    }
                    
                    this.notifyListingPageRecordsUpdate(listingID);
                    currentListing.collectionData.pageRecords = currentListing.collectionData.pageRecords ||
                                                                            currentListing.collectionData.records;

                    currentListing.paginator.setPageRecordsInfo( currentListing.collectionData );
                    currentListing.searching = false;

                    currentListing.columnCount = currentListing.columns.length + 1; 
                    if(currentListing.selectable || currentListing.multiselectable || currentListing.sortable){
                        currentListing.columnCount++; 
                    }   
                });
            }
        });
    };

    public setupInMultiCollectionConfigMode = (listingID:string) => {
        let currentListing = this.getListing(listingID);
        angular.forEach(currentListing.collectionConfigs,(value,key)=>{
            currentListing.collectionObjects[key] = value.baseEntityName;
        });
    };

    private setupDefaultCollectionInfo = (listingID:string) =>{
        let currentListing = this.getListing(listingID);

        if(currentListing.hasCollectionPromise
            && angular.isDefined(currentListing.collection)
            && currentListing.collectionConfig == null
        ){
            currentListing.collectionObject = currentListing.collection.collectionObject;
            currentListing.collectionConfig = this.collectionConfigService.newCollectionConfig(currentListing.collectionObject);
            currentListing.collectionConfig.loadJson(currentListing.collection.collectionConfig);
        }
        
        if(currentListing.multiSlot == false){
        	this.$timeout(()=>{
            currentListing.collectionConfig.loadJson(currentListing.collectionData.collectionConfig);
                //only override columns if they were not specified programmatically (editable listing displays, with non-persistent columns)
                if(currentListing.listingColumns == null){
                    currentListing.columns = currentListing.collectionConfig.columns;
                }
        	});
        }

        if( currentListing.paginator != null
            && currentListing.collectionConfig != null
        ){
            currentListing.collectionConfig.setPageShow(currentListing.paginator.getPageShow());
            currentListing.collectionConfig.setCurrentPage(currentListing.paginator.getCurrentPage());
        }
    };


    public addColumn = (listingID:string, column) =>{
        let currentListing = this.getListing(listingID);

        if(currentListing.collectionConfig != null && currentListing.collectionConfig.baseEntityAlias != null){
            column.propertyIdentifier = currentListing.collectionConfig.baseEntityAlias + "." + column.propertyIdentifier;
        } else if (this.getListingBaseEntityName(listingID) != null) {
            column.propertyIdentifier = '_' + this.getListingBaseEntityName(listingID).toLowerCase() + '.' + column.propertyIdentifier;
        }
        
        if(this.getListingColumnIndexByPropertyIdentifier(listingID, column.propertyIdentifier) === -1){
            if(column.aggregate){
                currentListing.aggregates.push(column.aggregate);
            } else {
                currentListing.columns.push(column);
            }
        }
    }

    public setupColumns = (listingID:string, collectionConfig, collectionObject) => {
        //assumes no alias formatting
        let currentListing = this.getListing(listingID);
        
        if( currentListing.columns.length == 0 && collectionConfig != null ){

            let pushVisibleColumnsToCurrentListing = () => {
                collectionConfig.columns.forEach( column => {
                    if(column.isVisible){
                        currentListing.columns.push(column);
                        this.setupColumn(listingID, column, collectionConfig, collectionObject);
                    }
                });
            }
            
            if(collectionConfig.columns == null){
                collectionConfig.getEntity().then(  
                    () => pushVisibleColumnsToCurrentListing(),
                    () => { throw("listing display couldn't initiate no columns") }
                );
            } 
            else {
                pushVisibleColumnsToCurrentListing();
            }
        } 
        else {
            currentListing.columns.forEach( column => {
                this.setupColumn(listingID, column, collectionConfig, collectionObject);
            });
        }
    };

    public setupColumn = (listingID:string,column:any, collectionConfig, collectionObject) => {
        
        let currentListing = this.getListing(listingID);
        
        // if(currentListing.collectionConfig != null && !column.hasCellView){
        //     //Q: doesn't make sense
        //     currentListing.collectionConfig.addColumn(column.propertyIdentifier, undefined, column);
        // }

        if( !collectionConfig && currentListing.collectionConfig != null ){
            collectionConfig = currentListing.collectionConfig;
        }

        var baseEntityName =  this.getListingBaseEntityName(listingID);
        if(!collectionObject){
            collectionObject = baseEntityName;
        }
        //if we have entity information we can make some inferences about the column
        if(baseEntityName != null){
            var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(baseEntityName,column.propertyIdentifier);

            if(angular.isUndefined(column.title)){
                column.title = this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
            }
            if(angular.isUndefined(column.isVisible)){
                column.isVisible = true;
            }


            var metadata = this.$hibachi.getPropertyByEntityNameAndPropertyName(lastEntity, this.utilityService.listLast(column.propertyIdentifier,'.'));
            if(metadata && angular.isDefined(metadata.persistent)){
                column.persistent = metadata.persistent;
            }

            if(metadata && angular.isDefined(metadata.ormtype)){
                column.ormtype = metadata.ormtype;
            }
            if(angular.isUndefined(column.type) || column.type == 'none'){
                if(angular.isDefined(metadata) && angular.isDefined(metadata.hb_formattype)){
                    column.type = metadata.hb_formattype;
                } else {
                    column.type = "none";
                }
            }

            if(column.propertyIdentifier){
                currentListing.allpropertyidentifiers = this.utilityService.listAppend(currentListing.allpropertyidentifiers,column.propertyIdentifier);
            }else if(column.processObjectProperty){
                column.searchable = false;
                column.sort = false;
                currentListing.allprocessobjectproperties = this.utilityService.listAppend(currentListing.allprocessobjectproperties, column.processObjectProperty);
            }

            if(column.tdclass){
                var tdclassArray = column.tdclass.split(' ');
                if(tdclassArray.indexOf("primary") >= 0 && currentListing.expandable){
                    currentListing.tableattributes = this.utilityService.listAppend(currentListing.tableattributes,'data-expandsortproperty='+column.propertyIdentifier, " ")
                    column.sort = false;
                }
            }
        }

        if(angular.isDefined(column.tooltip)){
            var parsedProperties = this.utilityService.getPropertiesFromString(column.tooltip);
            if(parsedProperties && parsedProperties.length){
                collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
            }
        } else {
            column.tooltip = '';
        }

        if(angular.isDefined(column.queryString)){
            var parsedProperties = this.utilityService.getPropertiesFromString(column.queryString);
            if( parsedProperties && parsedProperties.length ){
                collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
            }
        }

        //if the passed in collection has columns perform some formatting
        if(currentListing.hasCollectionPromise){
            var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(collectionObject,this.utilityService.listRest(column.propertyIdentifier,'.'));
            column.title = column.title || this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
            if( angular.isUndefined(column.isVisible) ){
                column.isVisible = true;
            }
        }

        this.columnOrderBy(listingID, column);
    }

    public initCollectionConfigData = (listingID:string,collectionConfig) =>{
        //kick off other essential setup
        this.setupSelect(listingID);
        this.setupMultiselect(listingID);
        this.setupExampleEntity(listingID);
        
        let currentListing = this.getListing(listingID);

        if( collectionConfig != null ){
            
            currentListing.filterGroups.forEach( (filterGroup) => {
                collectionConfig.addFilterGroup(filterGroup);
            });

            currentListing.filters.forEach( (filter) => {
                collectionConfig.addFilter( 
                    filter.propertyIdentifier,
                    filter.comparisonValue,
                    filter.comparisonOperator,
                    filter.logicalOperator,
                    filter.hidden
                );
            });

            currentListing.orderBys.forEach( (orderBy) => {
                collectionConfig.addOrderBy(orderBy.orderBy);
            });

            currentListing.aggregates.forEach( (aggregate) => {
                collectionConfig.addDisplayAggregate( 
                    aggregate.propertyIdentifier,
                    aggregate.aggregateFunction,
                    aggregate.aggregateAlias
                );
            });

            //make sure we have necessary properties to make the actions
            currentListing.actions.forEach( (action) => {
                
                if( angular.isDefined(action.queryString) ){
                    var parsedProperties = this.utilityService.getPropertiesFromString(action.queryString);
                    
                    if( parsedProperties?.length){
                        collectionConfig.addDisplayProperty( 
                            this.utilityService.arrayToList(parsedProperties),
                            "",
                            { isVisible : false }
                        );
                    }
                }
            });

            //also make sure we have necessary color filter properties
            currentListing.colorFilters.forEach( (colorFilter) => {
                
                if( angular.isDefined(colorFilter.propertyToCompare) ){
                    collectionConfig.addDisplayProperty( 
                        colorFilter.propertyToCompare,
                        "",
                        { isVisible : false }
                    );
                }
            });


            if( currentListing.collectionConfig?.hasColumns() ){
                
                collectionConfig.addDisplayProperty( 
                    this.getListingExampleEntity(listingID).$$getIDName(),
                    undefined,
                    { isVisible : false }
                );
            }

            collectionConfig.setPageShow(currentListing.paginator.pageShow);
            collectionConfig.setCurrentPage(currentListing.paginator.currentPage);

            if(currentListing.multiselectable && currentListing.columns?.length ){
                //check if it has an active flag and if so then add the active flag
                if(currentListing.exampleEntity.metaData?.activeProperty && !currentListing.hasCollectionPromise){
                    collectionConfig.addFilter('activeFlag', 1, '=', undefined, true);
                }
            }

            this.setupHierarchicalExpandable(listingID, collectionConfig);
        }

        this.setupSortable(listingID);
        this.updateColumnAndAdministrativeCount(listingID);
    };

    public setupSortable = (listingID:string) =>{
        this.attachToListingPageRecordsUpdate(listingID, this.getPageRecordsWithManualSortOrder, this.utilityService.createID(32));
    }

     public setupSelect = (listingID:string) => {
        let currentListing = this.getListing(listingID);

        if(currentListing.selectFieldName?.length){
            currentListing.selectable = true;
            currentListing.tableclass = this.utilityService.listAppend(currentListing.tableclass, 'table-select', ' ');
            currentListing.tableattributes = this.utilityService.listAppend(currentListing.tableattributes, 'data-selectfield="'+currentListing.selectFieldName+'"', ' ');
        }
    };

    public setupMultiselect = (listingID:string) =>{
        let currentListing = this.getListing(listingID);

        if(currentListing.multiselectFieldName?.length){
            currentListing.multiselectable = true;
            currentListing.tableclass = this.utilityService.listAppend(currentListing.tableclass, 'table-multiselect',' ');
            currentListing.tableattributes = this.utilityService.listAppend(currentListing.tableattributes,'data-multiselectpropertyidentifier="'+currentListing.multiselectPropertyIdentifier+'"',' ');

            //attach observer so we know when a selection occurs
            currentListing.observerService.attach(currentListing.updateMultiselectValues, currentListing.defaultSelectEvent, currentListing.collectionObject);
            //attach observer so we know when a pagination change occurs
            currentListing.observerService.attach(currentListing.paginationPageChange,'swPaginationAction');
        }

        //select all owned ids
        currentListing.multiselectValues?.split(',').forEach( value => {
            if(value.trim().length){
                currentListing.selectionService.addSelection(currentListing.tableID,value);
            }
        });

        currentListing.multiselectIdPaths?.split(',').forEach( value => {
            var id = currentListing.utilityService.listLast(value,'/');
            currentListing.selectionService.addSelection(currentListing.tableID,id);
        });
    };

    public setupExampleEntity = (listingID:string) => {
        let currentListing = this.getListing(listingID);

        currentListing.exampleEntity = this.$hibachi.getEntityExample(this.getListingBaseEntityName(listingID));
        if(currentListing.exampleEntity != null){
            //Look for Hierarchy in example entity
            if( !currentListing.parentPropertyName?.length ){
                if(currentListing.exampleEntity.metaData.hb_parentPropertyName){
                    currentListing.parentPropertyName = currentListing.exampleEntity.metaData.hb_parentPropertyName;
                }
            }
            if( !currentListing.childPropertyName?.length ){
                if(currentListing.exampleEntity.metaData.hb_childPropertyName){
                    currentListing.childPropertyName = currentListing.exampleEntity.metaData.hb_childPropertyName;
                }
            }
        }
    };
    
    public setupHierarchicalExpandable = (listingID:string, collectionConfig) =>{
        let currentListing = this.getListing(listingID);
        
        //Setup Hierachy Expandable
        if(currentListing.parentPropertyName?.length && currentListing.expandable != false){
            
            currentListing.tableclass = this.utilityService.listAppend(currentListing.tableclass,'table-expandable',' ');

            //add parent property root filter
            if(!currentListing.hasCollectionPromise){
                collectionConfig.addFilter(currentListing.parentPropertyName+'.'+currentListing.exampleEntity.$$getIDName(),'NULL','IS', undefined, true, false, false);
            }
            //this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName()+'Path',undefined,{isVisible:false});
            //add children column
            if(currentListing.childPropertyName?.length) {
                if(currentListing.getChildCount || !currentListing.hasCollectionPromise){
                    collectionConfig.addDisplayAggregate(
                        currentListing.childPropertyName,
                        'COUNT',
                        currentListing.childPropertyName+'Count',
                        {isVisible:false, isSearchable:false}
                    );
                }
            }

            currentListing.allpropertyidentifiers = this.utilityService.listAppend(currentListing.allpropertyidentifiers,currentListing.exampleEntity.$$getIDName()+'Path');
            currentListing.tableattributes = this.utilityService.listAppend(currentListing.tableattributes, 'data-parentidproperty='+currentListing.parentPropertyName+'.'+currentListing.exampleEntity.$$getIDName(),' ');
        }
    }

    public updateColumnAndAdministrativeCount = (listingID:string) =>{
        let currentListing = this.getListing(listingID);

        //Setup a variable for the number of columns so that the none can have a proper colspan
        currentListing.columnCount = (currentListing.columns) ? currentListing.columns.length : 0;

        if(currentListing.selectable){
            currentListing.columnCount++;
        }
        if(currentListing.multiselectable){
            currentListing.columnCount++;
        }
        if(currentListing.sortable){
            currentListing.columnCount++;
        }
        if(currentListing.administrativeCount){
            currentListing.administrativeCount++;
        }
    };

    public setupDefaultGetCollection = (listingID:string) =>{
        let currentListing = this.getListing(listingID);

        if(currentListing.collectionConfigs.length == 0){
            
            if(currentListing.collectionId){
                currentListing.collectionConfig.baseEntityNameType = 'Collection';
                currentListing.collectionConfig.id = currentListing.collectionId;
            }
            currentListing.collectionPromise = currentListing.collectionConfig.getEntity();

            return () => {
                currentListing.collectionConfig.setCurrentPage(currentListing.paginator.getCurrentPage());
                currentListing.collectionConfig.setPageShow(currentListing.paginator.getPageShow());
                
                let setCollectionData = (data) => {
                    currentListing.setCollectionData(data);
                    this.setupDefaultCollectionInfo(listingID);
                    currentListing.collectionData.pageRecords = data.pageRecords || data.records;
                    currentListing.paginator.setPageRecordsInfo(currentListing.collectionData);
                }
                
                if(currentListing.multiSlot){
                	currentListing.collectionConfig.getEntity().then(
                        (data) => { setCollectionData(data) },
                        (reason) => { throw("Listing Service encounter a problem when trying to get collection. Reason: " + reason) }
                    );
                }
                else {
                	currentListing.collectionPromise.then(
                        (data) => { setCollectionData(data) },
                        (reason) => { throw("Listing Service encounter a problem when trying to get collection. Reason: " + reason) }
                    );
                }
            };

        } else {
            return () => {
                currentListing.collectionData = {};
                currentListing.collectionData.pageRecords = [];
                var allGetEntityPromises = [];
                
                angular.forEach(currentListing.collectionConfigs,(collectionConfig,key)=>{
                    allGetEntityPromises.push(collectionConfig.getEntity());
                });
                
                if(allGetEntityPromises.length){
                    this.$q.all(allGetEntityPromises).then(
                        (results) => {
                            angular.forEach(results,(result,key) => {
                                currentListing.listingService.setupColumns(
                                    listingID,
                                    currentListing.collectionConfigs[key], 
                                    currentListing.collectionObjects[key]
                                );
                                currentListing.collectionData.pageRecords = currentListing.collectionData.pageRecords.concat(result.records);
                            });
                        },
                        (reason)=>{
                           throw("listing service had trouble getting collection data because: " + reason);
                        }
                    );
                }
            }
        }
    };
    //End Setup Functions

    //Order By Functions
    //for multi order by
    public columnOrderBy = (listingID:string, column) => {
        let currentListing = this.getListing(listingID);
        var isfound = false;
        if(currentListing.collectionConfigs != null){
            angular.forEach(currentListing.collectionConfig.orderBy, (orderBy, index)=>{
                if(column.propertyIdentifier == orderBy.propertyIdentifier){
                    isfound = true;
                    currentListing.orderByStates[column.propertyIdentifier] = orderBy.direction;
                }
            });
        }
        if(!isfound){
            currentListing.orderByStates[column.propertyIdentifier] = '';
        }
        return currentListing.orderByStates[column.propertyIdentifier];
    };

    //for multi order by
    public columnOrderByIndex = (listingID:string, column) =>{
        let currentListing = this.getListing(listingID);
        
        var isfound = false;
        
        if(column.sorting && column.sorting.active && column.sorting.sortOrder){
            return column.sorting.sortOrder.toUpperCase();
        }
        
        if(currentListing.collectionConfig != null){
            angular.forEach(currentListing.collectionConfig.orderBy, (orderBy, index)=>{
                if(column.propertyIdentifier == orderBy.propertyIdentifier){
                    isfound = true;
                    currentListing.orderByIndices[column.propertyIdentifier] = index + 1;
                }
            });
        }
        
        if(!isfound){
            currentListing.orderByIndices[column.propertyIdentifier] = '';
        }

        return currentListing.orderByIndices[column.propertyIdentifier];
    };

    //for single column order by
    public setSingleColumnOrderBy = (listingID:string, propertyIdentifier:string, direction:string, notify=true) =>{
        let currentListing = this.getListing(listingID);
        
        if(direction.toUpperCase() === "ASC"){
            var oppositeDirection = "DESC";
        } else {
            var oppositeDirection = "ASC";
        }
        
        if(currentListing.collectionConfig != null){
            var found = false;
            let _formattedPropertyIdentifier = currentListing.collectionConfig.formatPropertyIdentifier(propertyIdentifier);
            angular.forEach(currentListing.collectionConfig.orderBy, (orderBy, index)=>{
                if( _formattedPropertyIdentifier == orderBy.propertyIdentifier){
                    orderBy.direction = direction;
                    found = true;
                } else {
                    orderBy.direction = oppositeDirection;
                }
            });
            if(!found){
                currentListing.collectionConfig.addOrderBy(propertyIdentifier + "|" + direction, true, true);
            }
            if(notify){
                this.observerService.notify(this.getListingOrderByChangedEventString(listingID));
            }
            this.getCollection(listingID);
        }
    }

    //for manual sort
    public setManualSort = (listingID:string, toggle:boolean) =>{
        this.getListing(listingID).sortable = toggle;
        if(toggle){
            this.setSingleColumnOrderBy(listingID, "sortOrder", "ASC");
        }
    }

    //for single column order by
    public toggleOrderBy = (listingID:string, column) => {
        if(this.getListing(listingID).hasSingleCollectionConfig()){
            let orderByPropertyIdentifier = column.propertyIdentifier;
            if(column.aggregate && column.aggregate.aggregateFunction){
                orderByPropertyIdentifier = column.aggregate.aggregateFunction + '('+column.propertyIdentifier+')';
            }
            this.getListing(listingID).collectionConfig.toggleOrderBy(orderByPropertyIdentifier, true); //single column mode true, format propIdentifier false
        }

    };
    //End Order By Functions



    private getColorFilterConditionString = (colorFilter, pageRecord)=>{
       if(angular.isDefined(colorFilter.comparisonProperty)){
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + pageRecord[colorFilter.comparisonProperty.replace('.','_')];
       } else {
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + colorFilter.comparisonValue;
       }
    };

    //Disable Row Functions
    public getKeyOfMatchedDisableRule = (listingID:string, pageRecord)=>{
        var disableRuleMatchedKey = -1;
        if(angular.isDefined(this.getListing(listingID).disableRules)){
            angular.forEach(this.getListing(listingID).disableRules, (rule, key)=>{
                if(angular.isDefined(pageRecord[rule.filterPropertyIdentifier])){
                    if(angular.isString(pageRecord[rule.filterPropertyIdentifier])){
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier].trim();
                    } else {
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier];
                    }
                    if(rule.filterComparisonValue == "null"){
                        rule.filterComparisonValue = "";
                    }
                    if(this.filterService.filterMatch(pageRecordValue, rule.filterComparisonOperator, rule.filterComparisonValue)){
                        disableRuleMatchedKey = key;
                    }
                    if(disableRuleMatchedKey != -1){
                        return disableRuleMatchedKey;
                    }
                }
            });
        }
        return disableRuleMatchedKey;
    };

    public getPageRecordMatchesDisableRule = (listingID:string, pageRecord)=>{
        return this.getKeyOfMatchedDisableRule(listingID, pageRecord) != -1;
    };
    //End disable rule functions

    //Expandable Functions
    public setExpandable = (listingID:string, value:boolean)=>{
        if(angular.isDefined( this.getListing(listingID) )){
            this.getListing(listingID).expandable = value;
        }
    }

    public getKeyOfMatchedExpandableRule = (listingID:string, pageRecord)=>{
        var expandableRuleMatchedKey = -1;
        if(angular.isDefined(this.getListing(listingID)) &&
           angular.isDefined(this.getListing(listingID).expandableRules)
        ){
            angular.forEach(this.getListing(listingID).expandableRules, (rule, key)=>{
                if(angular.isDefined(pageRecord[rule.filterPropertyIdentifier])){
                    if(angular.isString(pageRecord[rule.filterPropertyIdentifier])){
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier].trim();
                    } else {
                        var pageRecordValue = pageRecord[rule.filterPropertyIdentifier];
                    }
                    if(this.filterService.filterMatch(pageRecordValue, rule.filterComparisonOperator, rule.filterComparisonValue)){
                        expandableRuleMatchedKey = key;
                    }
                    if(expandableRuleMatchedKey != -1){
                        return expandableRuleMatchedKey;
                    }
                }
            });
        }
        return expandableRuleMatchedKey;
    };

    public getExampleEntityForExpandableRecord = (listingID:string, pageRecord) =>{
        var childCollectionConfig = this.getListing(listingID).getPageRecordChildCollectionConfigForExpandableRule(pageRecord);
        if(angular.isDefined(childCollectionConfig)){
            return this.$hibachi.getEntityExample(this.getListing(listingID).getPageRecordChildCollectionConfigForExpandableRule(pageRecord).baseEntityName);
        }
        return this.getListing(listingID).exampleEntity;
    }

    public getPageRecordMatchesExpandableRule = (listingID:string, pageRecord)=>{
        return this.getKeyOfMatchedExpandableRule(listingID, pageRecord) != -1;
    };

    public hasPageRecordRefreshChildrenEvent = (listingID:string, pageRecord)=>{
        return this.getPageRecordRefreshChildrenEvent(listingID,pageRecord) != null;
    };

    public getPageRecordRefreshChildrenEvent = (listingID:string, pageRecord)=>{
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord);
        if(keyOfExpandableRuleMet != -1){
            return this.getListing(listingID).expandableRules[keyOfExpandableRuleMet].refreshChildrenEvent;
        }
    };

    public getPageRecordChildCollectionConfigForExpandableRule = (listingID:string, pageRecord) => {
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord);
        if(this.getListing(listingID) != null &&
           angular.isFunction(this.getListing(listingID).exampleEntity.$$getIDName) &&
           angular.isDefined(pageRecord[this.getListing(listingID).exampleEntity.$$getIDName()]) &&
           angular.isDefined(this.getListing(listingID).childCollectionConfigs[pageRecord[this.getListing(listingID).exampleEntity.$$getIDName()]])
        ){
            return this.getListing(listingID).childCollectionConfigs[pageRecord[this.getListing(listingID).exampleEntity.$$getIDName()]];
        }
        if(keyOfExpandableRuleMet != -1){
           var childCollectionConfig = this.getListing(listingID).expandableRules[keyOfExpandableRuleMet].childrenCollectionConfig.clone();
           angular.forEach(childCollectionConfig.filterGroups[0], (filterGroup, key)=>{
                angular.forEach(filterGroup, (filter,key)=>{
                    if(angular.isString(filter.value)
                        && filter.value.length
                        && filter.value.charAt(0) == '$'
                    ){
                        filter.value = this.utilityService.replaceStringWithProperties(filter.value, pageRecord);
                    }
                });
           });
           this.getListing(listingID).childCollectionConfigs[pageRecord[this.getListing(listingID).exampleEntity.$$getIDName()]] = childCollectionConfig;
           return this.getListing(listingID).childCollectionConfigs[pageRecord[this.getListing(listingID).exampleEntity.$$getIDName()]];
        }
    };
    //End Expandable Functions
    
    //Begin Personal Collections Functions
    
    public hasPersonalCollectionSelected=(personalCollectionKey:string):boolean=>{
        return this.localStorageService.hasItem('selectedPersonalCollection') 
            && this.localStorageService.getItem('selectedPersonalCollection')[personalCollectionKey];
    }
     public getPersonalCollectionByBaseEntityName=(personalCollectionKey:string):any=>{
        var personalCollection = this.collectionConfigService.newCollectionConfig('Collection');
        personalCollection.setDisplayProperties('collectionConfig');
        personalCollection.addFilter('collectionID',this.localStorageService.getItem('selectedPersonalCollection')[personalCollectionKey].collectionID);
        return personalCollection;
    }
        
    //End Personal Collections Functions

}
export{ListingService};
