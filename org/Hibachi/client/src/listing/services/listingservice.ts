/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Subject, Observable} from 'rxjs';
import * as Store from '../../../../../../org/Hibachi/client/src/core/prototypes/swstore';

class ListingService{

    private listingDisplays = {};
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
    public listingDisplayStateReducer:Store.Reducer = (state:any, action:Store.Action<number>):Object => {
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
        if(this.getListing(listingID).collectionConfig != null){
            return this.getListing(listingID).collectionConfig.columns;
        }
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

    public getListingBaseEntityName = (listingID:string) =>{
        var baseEntityName = this.getListing(listingID).baseEntityName || this.getListing(listingID).collectionObject
        if(baseEntityName == null &&  this.getListing(listingID).collectionConfig != null){
            baseEntityName = this.getListing(listingID).collectionConfig.baseEntityName;
        }
        if(baseEntityName == null && this.getListing(listingID).collectionData != null){
            baseEntityName = this.getListing(listingID).collectionData.collectionObject;
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
        if( angular.isDefined(this.getListing(listingID)) &&
            angular.isDefined(this.getListing(listingID).collectionData) &&
            angular.isDefined(this.getListing(listingID).collectionData.pageRecords)
        ){
            return this.getListing(listingID).collectionData.pageRecords;
        }
    }

    public getCollection = (listingID:string) =>{
        return this.getListing(listingID).getCollection();
    }

    public getPageRecordsWithManualSortOrder = (listingID:string) =>{
        if( angular.isDefined(this.getListing(listingID)) && this.getListingPageRecords(listingID) != null ){
            var pageRecords = this.getListingPageRecords(listingID);
            var primaryIDPropertyName = this.getListingEntityPrimaryIDPropertyName(listingID);
            var primaryIDWithBaseAlias = this.getListing(listingID).collectionConfig.baseEntityAlias + '.' + primaryIDPropertyName;
            var pageRecordsWithManualSortOrder = {};
            this.$timeout(
                ()=>{
                    for(var j = 0; j < pageRecords.length; j++){
                        var pageRecord = pageRecords[j];
                        var primaryID = pageRecords[j][primaryIDPropertyName];
                        var sortOrder =  j + 1;
                        var primaryIDColumnIndex = this.getListingCollectionConfigColumnIndexByPropertyIdentifier(listingID, primaryIDWithBaseAlias);
                        if(angular.isDefined(primaryID)){
                            pageRecordsWithManualSortOrder[primaryID] = sortOrder;
                        } else if(primaryIDColumnIndex !== -1){
                            var column = this.getListingCollectionConfigColumns(listingID)[primaryIDColumnIndex];
                            if(angular.isDefined(column.fallbackPropertyIdentifiers)){
                                var fallbackPropertyArray = column.fallbackPropertyIdentifiers.split(",");
                                for(var i = 0; i < fallbackPropertyArray.length; i++ ){
                                    if(angular.isDefined(pageRecord[fallbackPropertyArray[i]])){
                                        pageRecordsWithManualSortOrder[pageRecord[fallbackPropertyArray[i]]] = sortOrder;
                                    }
                                }
                            }
                        }
                    }
                    this.getListing(listingID).pageRecordsWithManualSortOrder = angular.toJson(pageRecordsWithManualSortOrder);
                    return this.getListing(listingID).pageRecordsWithManualSortOrders;
                },
                0
            )

        } else {
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
            return this.utilityService.replaceAll(propertyIdentifierWithoutAlias,'.','_');
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

    public selectCurrentPageRecords=(listingID)=>{
        if(!this.getListing(listingID).collectionData.pageRecords) return;

        for(var i = 0; i < this.getListing(listingID).collectionData.pageRecords.length; i++){
            if( this.getListing(listingID).isCurrentPageRecordsSelected == true ){
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).tableID,
                                                                         this.getListingPageRecords(listingID)[i][this.getListingBaseEntityPrimaryIDPropertyName(listingID)]);
            } else {
                this.selectionService.removeSelection(this.getListing(listingID).tableID,  this.getListingPageRecords(listingID)[i][this.getListingBaseEntityPrimaryIDPropertyName(listingID)]);
            }
        }
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
        for(var i = 0; i < this.getListing(listingID).collectionData.pageRecords.length; i++){
            this.selectionService.removeSelection(this.getListing(listingID).tableID,  this.getListingPageRecords(listingID)[i][this.getListingBaseEntityPrimaryIDPropertyName(listingID)]);
        }
        this.getListing(listingID).collectionConfig.getEntity().then(data=>{
            this.updatePageRecords(listingID,data);
        });
    }
    
     public updatePageRecords = (listingID,data) =>{
        this.getListing(listingID).collectionData = data;
        this.setupDefaultCollectionInfo(listingID);
        if(this.getListing(listingID).collectionConfig != null && this.getListing(listingID).collectionConfig.hasColumns()){
            this.setupColumns(listingID, this.getListing(listingID).collectionConfig, this.getListing(listingID).collectionObject);
        }else{
            this.getListing(listingID).collectionConfig.loadJson(data.collectionConfig);
        }
        this.notifyListingPageRecordsUpdate(listingID);
        this.getListing(listingID).collectionData.pageRecords = this.getListing(listingID).collectionData.pageRecords ||
                                                                this.getListing(listingID).collectionData.records;

        this.getListing(listingID).paginator.setPageRecordsInfo( this.getListing(listingID).collectionData );
        this.getListing(listingID).searching = false;

        this.getListing(listingID).columnCount = this.getListing(listingID).columns.length + 1; 
        if(this.getListing(listingID).selectable || this.getListing(listingID).multiselectable || this.getListing(listingID).sortable){
            this.getListing(listingID).columnCount++; 
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

        if( this.getListing(listingID).collectionObject != null &&
            this.getListing(listingID).collectionConfig != null
        ){
            this.getListing(listingID).collectionObject = this.getListing(listingID).collectionConfig.baseEntityName;
        }

        this.initCollectionConfigData( listingID, this.getListing(listingID).collectionConfig );

        this.setupColumns( listingID, this.getListing(listingID).collectionConfig, this.getListing(listingID).collectionObject );

        listingDisplayScope.$watch('swListingDisplay.collectionPromise',(newValue,oldValue)=>{
            if(newValue){
                this.$q.when(this.getListing(listingID).collectionPromise).then((data)=>{
                    this.getListing(listingID).collectionData = data;
                    this.setupDefaultCollectionInfo(listingID);
                    if(this.getListing(listingID).collectionConfig != null && this.getListing(listingID).collectionConfig.hasColumns()){
                        this.setupColumns(listingID, this.getListing(listingID).collectionConfig, this.getListing(listingID).collectionObject);
                    }else{
                        this.getListing(listingID).collectionConfig.loadJson(data.collectionConfig);
                    }
                    this.notifyListingPageRecordsUpdate(listingID);
                    this.getListing(listingID).collectionData.pageRecords = this.getListing(listingID).collectionData.pageRecords ||
                                                                            this.getListing(listingID).collectionData.records;

                    this.getListing(listingID).paginator.setPageRecordsInfo( this.getListing(listingID).collectionData );
                    this.getListing(listingID).searching = false;

                    this.getListing(listingID).columnCount = this.getListing(listingID).columns.length + 1; 
                    if(this.getListing(listingID).selectable || this.getListing(listingID).multiselectable || this.getListing(listingID).sortable){
                        this.getListing(listingID).columnCount++; 
                    }   
                });
            }
        });
    };

    public setupInMultiCollectionConfigMode = (listingID:string) => {
        angular.forEach(this.getListing(listingID).collectionConfigs,(value,key)=>{
            this.getListing(listingID).collectionObjects[key] = value.baseEntityName;
        });
    };

    private setupDefaultCollectionInfo = (listingID:string) =>{
        if(this.getListing(listingID).hasCollectionPromise
            && angular.isDefined(this.getListing(listingID).collection)
            && this.getListing(listingID).collectionConfig == null
        ){
            this.getListing(listingID).collectionObject = this.getListing(listingID).collection.collectionObject;
            this.getListing(listingID).collectionConfig = this.collectionConfigService.newCollectionConfig(this.getListing(listingID).collectionObject);
            this.getListing(listingID).collectionConfig.loadJson(this.getListing(listingID).collection.collectionConfig);

        }
        if(this.getListing(listingID).multiSlot == false){
        	this.$timeout(()=>{
            this.getListing(listingID).collectionConfig.loadJson(this.getListing(listingID).collectionData.collectionConfig);
            this.getListing(listingID).columns = this.getListing(listingID).collectionConfig.columns;
        	});
        }

        if( this.getListing(listingID).paginator != null
            && this.getListing(listingID).collectionConfig != null
        ){
            this.getListing(listingID).collectionConfig.setPageShow(this.getListing(listingID).paginator.getPageShow());
            this.getListing(listingID).collectionConfig.setCurrentPage(this.getListing(listingID).paginator.getCurrentPage());
        }
    };



    public addColumn = (listingID:string, column) =>{
        if(this.getListing(listingID).collectionConfig != null && this.getListing(listingID).collectionConfig.baseEntityAlias != null){
            column.propertyIdentifier = this.getListing(listingID).collectionConfig.baseEntityAlias + "." + column.propertyIdentifier;
        } else if (this.getListingBaseEntityName(listingID) != null) {
            column.propertyIdentifier = '_' + this.getListingBaseEntityName(listingID).toLowerCase() + '.' + column.propertyIdentifier;
        }
        if(this.getListingColumnIndexByPropertyIdentifier(listingID, column.propertyIdentifier) === -1){
            if(column.aggregate){
                this.getListing(listingID).aggregates.push(column.aggregate);
            } else {
                this.getListing(listingID).columns.push(column);
            }
        }
    }

    public setupColumns = (listingID:string, collectionConfig, collectionObject) =>{
        //assumes no alias formatting

        if( this.getListing(listingID).columns.length == 0 &&
            collectionConfig != null
        ){
            if(collectionConfig.columns == null){
                collectionConfig.getEntity().then(
                    ()=>{
                        for(var j=0; j < collectionConfig.columns.length; j++){
                            var column = collectionConfig.columns[j];
                            if(column.isVisible){
                                this.getListing(listingID).columns.push(column);
                            }
                        }
                    },
                    ()=>{
                        throw("listing display couldn't initiate no columns");
                    }
                );
            } else {
                for(var j=0; j < collectionConfig.columns.length; j++){
                    var column = collectionConfig.columns[j];
                    if(column.isVisible){
                        this.getListing(listingID).columns.push(column);
                    }
                }
            }

        }

        for(var i=0; i < this.getListing(listingID).columns.length; i++){

            var column = this.getListing(listingID).columns[i];

            this.setupColumn(listingID,column,collectionConfig,collectionObject);
        }

        
    };

    public setupColumn=(listingID:string,column:any, collectionConfig, collectionObject)=>{
        if(this.getListing(listingID).collectionConfig != null && !column.hasCellView){
            this.getListing(listingID).collectionConfig.addColumn(column.propertyIdentifier,undefined,column);
        }

        if(!collectionConfig && this.getListing(listingID).collectionConfig != null){
            collectionConfig = this.getListing(listingID).collectionConfig != null;
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
                this.getListing(listingID).allpropertyidentifiers = this.utilityService.listAppend(this.getListing(listingID).allpropertyidentifiers,column.propertyIdentifier);
            }else if(column.processObjectProperty){
                column.searchable = false;
                column.sort = false;
                this.getListing(listingID).allprocessobjectproperties = this.utilityService.listAppend(this.getListing(listingID).allprocessobjectproperties, column.processObjectProperty);
            }

            if(column.tdclass){
                var tdclassArray = column.tdclass.split(' ');
                if(tdclassArray.indexOf("primary") >= 0 && this.getListing(listingID).expandable){
                    this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes,'data-expandsortproperty='+column.propertyIdentifier, " ")
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
            if(parsedProperties && parsedProperties.length){
                collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
            }
        }

        //if the passed in collection has columns perform some formatting
        if(this.getListing(listingID).hasCollectionPromise){
            var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(collectionObject,this.utilityService.listRest(column.propertyIdentifier,'.'));
            column.title = column.title || this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
            if(angular.isUndefined(column.isVisible)){
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

        if(collectionConfig != null){
            angular.forEach(this.getListing(listingID).filterGroups, (filterGroup)=>{
                collectionConfig.addFilterGroup(filterGroup);
            });

            angular.forEach(this.getListing(listingID).filters, (filter)=>{
                collectionConfig.addFilter( filter.propertyIdentifier,
                                            filter.comparisonValue,
                                            filter.comparisonOperator,
                                            filter.logicalOperator,
                                            filter.hidden
                                        );
            });

            angular.forEach(this.getListing(listingID).orderBys, (orderBy)=>{
                collectionConfig.addOrderBy(orderBy.orderBy);
            });

            angular.forEach(this.getListing(listingID).aggregates, (aggregate)=>{
                collectionConfig.addDisplayAggregate( aggregate.propertyIdentifier,
                                                      aggregate.aggregateFunction,
                                                      aggregate.aggregateAlias
                                                    );
            });

            //make sure we have necessary properties to make the actions
            angular.forEach(this.getListing(listingID).actions, (action)=>{
                if(angular.isDefined(action.queryString)){
                    var parsedProperties = this.utilityService.getPropertiesFromString(action.queryString);
                    if(parsedProperties && parsedProperties.length){
                        collectionConfig.addDisplayProperty( this.utilityService.arrayToList(parsedProperties),
                                                             "",
                                                             { isVisible : false }
                                                        );
                    }
                }
            });

            //also make sure we have necessary color filter properties
            angular.forEach(this.getListing(listingID).colorFilters,(colorFilter)=>{
                if(angular.isDefined(colorFilter.propertyToCompare)){
                    collectionConfig.addDisplayProperty( colorFilter.propertyToCompare,
                                                         "",
                                                         { isVisible : false }
                                                    );
                }
            });


            if(this.getListing(listingID).collectionConfig != null && this.getListing(listingID).collectionConfig.hasColumns()){
                collectionConfig.addDisplayProperty( this.getListingExampleEntity(listingID).$$getIDName(),
                                                     undefined,
                                                     { isVisible : false }
                                                );
            }

            collectionConfig.setPageShow(this.getListing(listingID).paginator.pageShow);
            collectionConfig.setCurrentPage(this.getListing(listingID).paginator.currentPage);

            if(this.getListing(listingID).multiselectable && (!this.getListing(listingID).columns || !this.getListing(listingID).columns.length)){
                //check if it has an active flag and if so then add the active flag
                if(this.getListing(listingID).exampleEntity.metaData.activeProperty && !this.getListing(listingID).hasCollectionPromise){
                    collectionConfig.addFilter('activeFlag',1,'=',undefined,true);
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

    public setupSelect = (listingID:string) =>{
        if(this.getListing(listingID).selectFieldName && this.getListing(listingID).selectFieldName.length){
            this.getListing(listingID).selectable = true;
            this.getListing(listingID).tableclass = this.utilityService.listAppend(this.getListing(listingID).tableclass,'table-select',' ');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes, 'data-selectfield="'+this.getListing(listingID).selectFieldName+'"', ' ');
        }
    };

    public setupMultiselect = (listingID:string) =>{
        if(this.getListing(listingID).multiselectFieldName && this.getListing(listingID).multiselectFieldName.length){
            this.getListing(listingID).multiselectable = true;
            this.getListing(listingID).tableclass = this.utilityService.listAppend(this.getListing(listingID).tableclass, 'table-multiselect',' ');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes,'data-multiselectpropertyidentifier="'+this.getListing(listingID).multiselectPropertyIdentifier+'"',' ');


            //attach observer so we know when a selection occurs
            this.getListing(listingID).observerService.attach(this.getListing(listingID).updateMultiselectValues,this.getListing(listingID).defaultSelectEvent,this.getListing(listingID).collectionObject);

            //attach observer so we know when a pagination change occurs
            this.getListing(listingID).observerService.attach(this.getListing(listingID).paginationPageChange,'swPaginationAction');
        }

        if(this.getListing(listingID).multiselectValues && this.getListing(listingID).multiselectValues.length){
            //select all owned ids
            var multiSelectValuesArray = this.getListing(listingID).multiselectValues.split(',');
            angular.forEach(multiSelectValuesArray,(value)=>{
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).tableID,value);
            });
        }

        if(this.getListing(listingID).multiselectIdPaths && this.getListing(listingID).multiselectIdPaths.length){

            angular.forEach(this.getListing(listingID).multiselectIdPaths.split(','),(value)=>{
                var id = this.getListing(listingID).utilityService.listLast(value,'/');
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).tableID,id);
            });
        }
    };

    public setupExampleEntity = (listingID:string) =>{
        this.getListing(listingID).exampleEntity = this.$hibachi.getEntityExample(this.getListingBaseEntityName(listingID));
        if(this.getListing(listingID).exampleEntity != null){
            //Look for Hierarchy in example entity
            if(!this.getListing(listingID).parentPropertyName || (this.getListing(listingID).parentPropertyName && !this.getListing(listingID).parentPropertyName.length) ){
                if(this.getListing(listingID).exampleEntity.metaData.hb_parentPropertyName){
                    this.getListing(listingID).parentPropertyName = this.getListing(listingID).exampleEntity.metaData.hb_parentPropertyName;
                }
            }
            if(!this.getListing(listingID).childPropertyName || (this.getListing(listingID).childPropertyName && !this.getListing(listingID).childPropertyName.length) ){
                if(this.getListing(listingID).exampleEntity.metaData.hb_childPropertyName){
                    this.getListing(listingID).childPropertyName = this.getListing(listingID).exampleEntity.metaData.hb_childPropertyName;
                }
            }
        }
    };

    public setupHierarchicalExpandable = (listingID:string, collectionConfig) =>{
        //Setup Hierachy Expandable
        if(this.getListing(listingID).parentPropertyName && this.getListing(listingID).parentPropertyName.length && this.getListing(listingID).expandable !=false){
            if(angular.isUndefined(this.getListing(listingID).expandable)){
                this.getListing(listingID).expandable = true;
            }

            this.getListing(listingID).tableclass = this.utilityService.listAppend(this.getListing(listingID).tableclass,'table-expandable',' ');

            //add parent property root filter
            if(!this.getListing(listingID).hasCollectionPromise){
                collectionConfig.addFilter(this.getListing(listingID).parentPropertyName+'.'+this.getListing(listingID).exampleEntity.$$getIDName(),'NULL','IS', undefined, true, false, false);
            }
            //this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName()+'Path',undefined,{isVisible:false});
            //add children column
            if(this.getListing(listingID).childPropertyName && this.getListing(listingID).childPropertyName.length) {
                if(this.getListing(listingID).getChildCount || !this.getListing(listingID).hasCollectionPromise){
                    collectionConfig.addDisplayAggregate(
                        this.getListing(listingID).childPropertyName,
                        'COUNT',
                        this.getListing(listingID).childPropertyName+'Count',
                        {isVisible:false, isSearchable:false}
                    );
                }
            }

            this.getListing(listingID).allpropertyidentifiers = this.utilityService.listAppend(this.getListing(listingID).allpropertyidentifiers,this.getListing(listingID).exampleEntity.$$getIDName()+'Path');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes, 'data-parentidproperty='+this.getListing(listingID).parentPropertyName+'.'+this.getListing(listingID).exampleEntity.$$getIDName(),' ');
        }
    };

    public updateColumnAndAdministrativeCount = (listingID:string) =>{
        //Setup a variable for the number of columns so that the none can have a proper colspan
        this.getListing(listingID).columnCount = (this.getListing(listingID).columns) ? this.getListing(listingID).columns.length : 0;

        if(this.getListing(listingID).selectable){
            this.getListing(listingID).columnCount++;
        }
        if(this.getListing(listingID).multiselectable){
            this.getListing(listingID).columnCount++;
        }
        if(this.getListing(listingID).sortable){
            this.getListing(listingID).columnCount++;
        }
        if(this.getListing(listingID).administrativeCount){
            this.getListing(listingID).administrativeCount++;
        }
    };

    public setupDefaultGetCollection = (listingID:string) =>{

        if(this.getListing(listingID).collectionConfigs.length == 0){
            if(this.getListing(listingID).collectionId){
            
                this.getListing(listingID).collectionConfig.baseEntityNameType = 'Collection';
                this.getListing(listingID).collectionConfig.id = this.getListing(listingID).collectionId;
            }
            this.getListing(listingID).collectionPromise = this.getListing(listingID).collectionConfig.getEntity();

            return () =>{
                this.getListing(listingID).collectionConfig.setCurrentPage(this.getListing(listingID).paginator.getCurrentPage());
                this.getListing(listingID).collectionConfig.setPageShow(this.getListing(listingID).paginator.getPageShow());
                if(this.getListing(listingID).multiSlot){
                	this.getListing(listingID).collectionConfig.getEntity().then(
                    (data)=>{
                        this.getListing(listingID).collectionData = data;
                        this.setupDefaultCollectionInfo(listingID);
                        this.getListing(listingID).collectionData.pageRecords = data.pageRecords || data.records;
                        this.getListing(listingID).paginator.setPageRecordsInfo(this.getListing(listingID).collectionData);
                    },
                    (reason)=>{
                        throw("Listing Service encounter a problem when trying to get collection. Reason: " + reason);
                    }
                );
                }else{
                	this.getListing(listingID).collectionPromise.then(
                    (data)=>{
                        this.getListing(listingID).collectionData = data;
                        this.setupDefaultCollectionInfo(listingID);
                        this.getListing(listingID).collectionData.pageRecords = data.pageRecords || data.records;
                        this.getListing(listingID).paginator.setPageRecordsInfo(this.getListing(listingID).collectionData);
                    },
                    (reason)=>{
                        throw("Listing Service encounter a problem when trying to get collection. Reason: " + reason);
                    }
                );
                }

            };

        } else {

            return () =>{
                this.getListing(listingID).collectionData = {};
                this.getListing(listingID).collectionData.pageRecords = [];
                var allGetEntityPromises = [];
                angular.forEach(this.getListing(listingID).collectionConfigs,(collectionConfig,key)=>{
                    allGetEntityPromises.push(collectionConfig.getEntity());
                });
                if(allGetEntityPromises.length){
                    this.$q.all(allGetEntityPromises).then(
                        (results)=>{
                            angular.forEach(results,(result,key)=>{
                                this.getListing(listingID).listingService.setupColumns(listingID,this.getListing(listingID).collectionConfigs[key], this.getListing(listingID).collectionObjects[key]);
                                this.getListing(listingID).collectionData.pageRecords = this.getListing(listingID).collectionData.pageRecords.concat(result.records);
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
        var isfound = false;
        if(this.getListing(listingID).collectionConfigs != null){
            angular.forEach(this.getListing(listingID).collectionConfig.orderBy, (orderBy, index)=>{
                if(column.propertyIdentifier == orderBy.propertyIdentifier){
                    isfound = true;
                    this.getListing(listingID).orderByStates[column.propertyIdentifier] = orderBy.direction;
                }
            });
        }
        if(!isfound){
            this.getListing(listingID).orderByStates[column.propertyIdentifier] = '';
        }
        return this.getListing(listingID).orderByStates[column.propertyIdentifier];
    };

    //for multi order by
    public columnOrderByIndex = (listingID:string, column) =>{
        var isfound = false;
        if(column.sorting && column.sorting.active && column.sorting.sortOrder){
            return column.sorting.sortOrder.toUpperCase();
        }
        if(this.getListing(listingID).collectionConfig != null){
            angular.forEach(this.getListing(listingID).collectionConfig.orderBy, (orderBy, index)=>{
                if(column.propertyIdentifier == orderBy.propertyIdentifier){
                    isfound = true;
                    this.getListing(listingID).orderByIndices[column.propertyIdentifier] = index + 1;
                }
            });
        }
        if(!isfound){
            this.getListing(listingID).orderByIndices[column.propertyIdentifier] = '';
        }

        return this.getListing(listingID).orderByIndices[column.propertyIdentifier];
    };

    //for single column order by
    public setSingleColumnOrderBy = (listingID:string, propertyIdentifier:string, direction:string, notify=true) =>{
        if(direction.toUpperCase() === "ASC"){
            var oppositeDirection = "DESC";
        } else {
            var oppositeDirection = "ASC";
        }
        if(this.getListing(listingID).collectionConfig != null){
            var found = false;
            angular.forEach(this.getListing(listingID).collectionConfig.orderBy, (orderBy, index)=>{
                if(propertyIdentifier == orderBy.propertyIdentifier){
                    orderBy.direction = direction;
                    found = true;
                } else {
                    orderBy.direction = oppositeDirection;
                }
            });
            if(!found){
                this.getListing(listingID).collectionConfig.addOrderBy(propertyIdentifier + "|" + direction);
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
            this.getListing(listingID).collectionConfig.toggleOrderBy(orderByPropertyIdentifier, true);
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
    
    public hasPersonalCollectionSelected=(baseEntityName:string):boolean=>{
        return this.localStorageService.hasItem('selectedPersonalCollection') 
            && this.localStorageService.getItem('selectedPersonalCollection')[baseEntityName.toLowerCase()];
    }
     public getPersonalCollectionByBaseEntityName=(baseEntityName:string):any=>{
        var personalCollection = this.collectionConfigService.newCollectionConfig('Collection');
        personalCollection.setDisplayProperties('collectionConfig');
        personalCollection.addFilter('collectionID',this.localStorageService.getItem('selectedPersonalCollection')[baseEntityName.toLowerCase()].collectionID);
        return personalCollection;
    }
        
    //End Personal Collections Functions

}
export{ListingService};
