/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class ListingService{
    
    private listingDisplays = {};
    
    //@ngInject
    constructor(private $q,
                private collectionConfigService,
                private filterService,
                private utilityService, 
                private rbkeyService, 
                private selectionService,
                private $hibachi
    ){

    }
    
    public setListingState = (listingID, state) =>{
        this.listingDisplays[listingID] = state; 
    }

    public getListing = (listingID) => {
        return this.listingDisplays[listingID];
    }

    public getListingPrimaryEntityName = (listingID) =>{
        return this.getListing(listingID).baseEntityName || 
               this.getListing(listingID).collectionObject || 
               this.getListing(listingID).collectionConfig.baseEntityName; 
    }

    public getListingEntityPrimaryIDPropertyName = (listingID) =>{
        return this.$hibachi.getPrimaryIDPropertyNameByEntityName(this.getListingPrimaryEntityName(listingID)); 
    }

    public getListingPageRecordIndexByPageRecord = (listingID, pageRecordToCompare) =>{
        var pageRecords = this.getListingPageRecords(listingID); 
        var primaryIDPropertyName = this.getListingEntityPrimaryIDPropertyName(listingID); 
        for(var j = 0; j<pageRecords.length; j++){
            var pageRecord = pageRecords[j]; 
            if( pageRecord[primaryIDPropertyName] == pageRecordToCompare[primaryIDPropertyName] ){
                return j; 
            }
        }
        return -1; 
    }

    public getListingPageRecords = (listingID) =>{
        if( angular.isDefined(this.getListing(listingID)) &&
            angular.isDefined(this.getListing(listingID).collectionData) && 
            angular.isDefined(this.getListing(listingID).collectionData.pageRecords)
        ){
            return this.getListing(listingID).collectionData.pageRecords; 
        }
    }

    //needs a consideration of strategy for doing this for other use cases
    public insertListingPageRecord = (listingID, pageRecord) =>{
        if( angular.isDefined(this.getListingPageRecords(listingID))){
            this.getListingPageRecords(listingID).push(pageRecord); 
        }
    }

    public removeListingPageRecord = (listingID, pageRecord) =>{
        var pageRecords = this.getListingPageRecords(listingID); 
        if(this.getListingPageRecordIndexByPageRecord(listingID, pageRecord) != -1){
            return pageRecords.splice(this.getListingPageRecordIndexByPageRecord(listingID, pageRecord), 1)[0];//this will always be an array of one element 
        }
    }

    public getCollection = (listingID) =>{
        return this.getListing(listingID).getCollection(); 
    }

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

    public markUnedited = (listingId, pageRecordIndex, propertyDisplayID) => {
        var pageRecords = this.getListingPageRecords(listingId); 
        if(angular.isDefined(pageRecords[pageRecordIndex].editedFields[propertyDisplayID])){
            delete pageRecords[pageRecordIndex].editedFields[propertyDisplayID];
        }
        return this.determineRowEdited(pageRecords,pageRecordIndex); 
    }

    public markEdited = (listingId, pageRecordIndex, propertyDisplayID, saveCallback) => {
        var pageRecords = this.getListingPageRecords(listingId); 
        if(angular.isUndefined(pageRecords[pageRecordIndex].editedFields) && !angular.isObject(pageRecords[pageRecordIndex].editedFields)){
            pageRecords[pageRecordIndex].editedFields = {}; 
        }
        pageRecords[pageRecordIndex].editedFields[propertyDisplayID] = saveCallback; 
        return this.determineRowEdited(pageRecords,pageRecordIndex); 
    }

    public markSaved = (listingId, pageRecordIndex) => {
        var pageRecords = this.getListingPageRecords(listingId); 
        for(var key in pageRecords[pageRecordIndex].editedFields){
            if(angular.isFunction(pageRecords[pageRecordIndex].editedFields[key])){
                pageRecords[pageRecordIndex].editedFields[key]();
            }
        }
        delete pageRecords[pageRecordIndex].editedFields;
        pageRecords[pageRecordIndex].edited = false; 
    }
    //End Row Save Functionality

    public setupInSingleCollectionConfigMode = (listingID, listingDisplayScope) =>{
        
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
                        this.setupColumns(listingID,this.getListing(listingID).collectionConfig, this.getListing(listingID).collectionObject);
                    }else{
                        this.getListing(listingID).collectionConfig.loadJson(data.collectionConfig);
                    }
                    this.getListing(listingID).collectionData.pageRecords = this.getListing(listingID).collectionData.pageRecords || 
                                                                            this.getListing(listingID).collectionData.records;

                    this.getListing(listingID).paginator.setPageRecordsInfo( this.getListing(listingID).collectionData );
                    this.getListing(listingID).searching = false;
                });
            }
        });
    };

    public setupInMultiCollectionConfigMode = (listingID) => {
        angular.forEach(this.getListing(listingID).collectionConfigs,(value,key)=>{
            this.getListing(listingID).collectionObjects[key] = value.baseEntityName;
        }); 
    };

    private setupDefaultCollectionInfo = (listingID) =>{
        if(this.getListing(listingID).hasCollectionPromise 
            && angular.isDefined(this.getListing(listingID).collection) 
            && this.getListing(listingID).collectionConfig == null
        ){
            this.getListing(listingID).collectionObject = this.getListing(listingID).collection.collectionObject;
            this.getListing(listingID).collectionConfig = this.collectionConfigService.newCollectionConfig(this.getListing(listingID).collectionObject);
            this.getListing(listingID).collectionConfig.loadJson(this.getListing(listingID).collection.collectionConfig);
        }
        if(this.getListing(listingID).paginator != null 
            && this.getListing(listingID).collectionConfig != null
        ){
            this.getListing(listingID).collectionConfig.setPageShow(this.getListing(listingID).paginator.getPageShow());
            this.getListing(listingID).collectionConfig.setCurrentPage(this.getListing(listingID).paginator.getCurrentPage());
        }
    };

    public addColumn = (listingID, column) =>{
        if(this.getListing(listingID).collectionConfig != null && this.getListing(listingID).collectionConfig.baseEntityAlias != null){
            column.propertyIdentifier = this.getListing(listingID).collectionConfig.baseEntityAlias + "." + column.propertyIdentifier;
        } else if (this.getListingBaseEntityName(listingID) != null) {
            column.propertyIdentifier = this.$hibachi.getBaseEntityAliasFromName(this.getListingBaseEntityName(listingID));
        }
        if(this.utilityService.ArrayFindByPropertyValue(this.getListing(listingID).columns,'propertyIdentifier',column.propertyIdentifier) === -1){
            if(column.aggregate){
                this.getListing(listingID).aggregates.push(column.aggregate);
            } else {
                this.getListing(listingID).columns.push(column);
            }
        }
    }

    public setupColumns = (listingID, collectionConfig, collectionObject) =>{
        //assumes no alias formatting
        if(this.getListing(listingID).columns.length == 0 && collectionConfig != null){
            this.getListing(listingID).columns = collectionConfig.columns;
        }
        for(var i=0; i < this.getListing(listingID).columns.length; i++){
            
            var column = this.getListing(listingID).columns[i];

            if(this.getListing(listingID).collectionConfig != null){
                this.getListing(listingID).collectionConfig.addColumn(column.propertyIdentifier,undefined,column);
            } 

            var baseEntityName =  this.getListingBaseEntityName(listingID);

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
                
                if(angular.isDefined(metadata) && angular.isDefined(metadata.hb_formattype)){
                    column.type = metadata.hb_formatType;
                } else { 
                    column.type = "none";
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
    };

    public initCollectionConfigData = (listingID,collectionConfig) =>{

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

        this.updateColumnAndAdministrativeCount(listingID);
    };
    //end initCollectionConfigData

    public setupSelect = (listingID) =>{
        if(this.getListing(listingID).selectFieldName && this.getListing(listingID).selectFieldName.length){
            this.getListing(listingID).selectable = true;
            this.getListing(listingID).tableclass = this.utilityService.listAppend(this.getListing(listingID).tableclass,'table-select',' ');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes, 'data-selectfield="'+this.getListing(listingID).selectFieldName+'"', ' ');
        }
    };

    public setupMultiselect = (listingID) =>{
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
            angular.forEach(this.getListing(listingID).multiselectValues,(value)=>{
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).name,value);
            });
        }

        if(this.getListing(listingID).multiselectIdPaths && this.getListing(listingID).multiselectIdPaths.length){
            angular.forEach(this.getListing(listingID).multiselectIdPaths.split(','),(value)=>{
                var id = this.getListing(listingID).utilityService.listLast(value,'/');
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).name,id);
            });
        }
    };

    public getListingExampleEntity = (listingID) =>{
        if(this.getListing(listingID).exampleEntity != null){
            return this.getListing(listingID).exampleEntity;
        } else {
            this.setupExampleEntity = (listingID);
        }
    }

    public getListingBaseEntityName = (listingID) =>{
        var baseEntityName = this.getListing(listingID).baseEntityName || this.getListing(listingID).collectionObject
        if(baseEntityName == null &&  this.getListing(listingID).collectionConfig != null){
            baseEntityName = this.getListing(listingID).collectionConfig.baseEntityName;
        }
        if(baseEntityName == null && this.getListing(listingID).collectionData != null){
            baseEntityName = this.getListing(listingID).collectionData.collectionObject; 
        }
        return baseEntityName;
    }

    public setupExampleEntity = (listingID) =>{
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

    public setupHierarchicalExpandable = (listingID, collectionConfig) =>{
        //Setup Hierachy Expandable
        if(this.getListing(listingID).parentPropertyName && this.getListing(listingID).parentPropertyName.length && this.getListing(listingID).expandable !=false){
            if(angular.isUndefined(this.getListing(listingID).expandable)){
                this.getListing(listingID).expandable = true;
            }

            this.getListing(listingID).tableclass = this.utilityService.listAppend(this.getListing(listingID).tableclass,'table-expandable',' ');

            //add parent property root filter
            if(!this.getListing(listingID).hasCollectionPromise){
                collectionConfig.addFilter(this.getListing(listingID).parentPropertyName+'.'+this.getListing(listingID).exampleEntity.$$getIDName(),'NULL','IS', undefined, true);
            }
            //this.collectionConfig.addDisplayProperty(this.exampleEntity.$$getIDName()+'Path',undefined,{isVisible:false});
            //add children column
            if(this.getListing(listingID).childPropertyName && this.getListing(listingID).childPropertyName.length) {
                if(this.getListing(listingID).getChildCount || !this.getListing(listingID).hasCollectionPromise){
                    collectionConfig.addDisplayAggregate(
                        this.getListing(listingID).childPropertyName,
                        'COUNT',
                        this.getListing(listingID).childPropertyName+'Count',
                        {isVisible:false}
                    );
                }
            }

            this.getListing(listingID).allpropertyidentifiers = this.utilityService.listAppend(this.getListing(listingID).allpropertyidentifiers,this.getListing(listingID).exampleEntity.$$getIDName()+'Path');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes, 'data-parentidproperty='+this.getListing(listingID).parentPropertyName+'.'+this.getListing(listingID).exampleEntity.$$getIDName(),' ');
        }
    };

    public updateColumnAndAdministrativeCount = (listingID) =>{
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

    public setupDefaultGetCollection = (listingID) =>{
        if(this.getListing(listingID).collectionConfigs.length == 0){
            this.getListing(listingID).collectionPromise = this.getListing(listingID).collectionConfig.getEntity();
            
            return () =>{
                this.getListing(listingID).collectionConfig.setCurrentPage(this.getListing(listingID).paginator.getCurrentPage());
                this.getListing(listingID).collectionConfig.setPageShow(this.getListing(listingID).paginator.getPageShow());
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

    public columnOrderBy = (listingID, column) => {
        var isfound = false;
        if(this.getListing(listingID).collectionConfigs.length == 0){
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

    public getPageRecordKey = (propertyIdentifier)=>{
        if(propertyIdentifier){
            var propertyIdentifierWithoutAlias = '';
            if(propertyIdentifier.indexOf('_') === 0){
                propertyIdentifierWithoutAlias = propertyIdentifier.substring(propertyIdentifier.indexOf('.')+1,propertyIdentifier.length);
            }else{
                propertyIdentifierWithoutAlias = propertyIdentifier;
            }
            return this.utilityService.replaceAll(propertyIdentifierWithoutAlias,'.','_');
        }
        return '';
    };

     public selectCurrentPageRecords=(listingID)=>{
        if(!this.getListing(listingID).collectionData.pageRecords) return;

        for(var i = 0; i < this.getListing(listingID).collectionData.pageRecords.length; i++){
            if(this.getListing(listingID).isCurrentPageRecordsSelected == true){
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).name, this.getListing(listingID).collectionData.pageRecords[i][this.getListing(listingID).exampleEntity.$$getIDName()]);
            }else{
                this.selectionService.removeSelection(this.getListing(listingID).name, this.getListing(listingID).collectionData.pageRecords[i][this.getListing(listingID).exampleEntity.$$getIDName()]);
            }
        }
     };

     private getColorFilterConditionString = (colorFilter, pageRecord)=>{
       if(angular.isDefined(colorFilter.comparisonProperty)){
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + pageRecord[colorFilter.comparisonProperty.replace('.','_')];
       } else { 
            return pageRecord[colorFilter.propertyToCompare.replace('.','_')] + colorFilter.comparisonOperator + colorFilter.comparisonValue;
       }
    };

    public getNGClassObjectForPageRecordRow = (listingID, pageRecord)=>{
        var classObjectString = "{"; 
        angular.forEach(this.getListing(listingID).colorFilters, (colorFilter, index)=>{
            classObjectString = classObjectString.concat("'" + colorFilter.colorClass + "':" + this.getColorFilterConditionString(colorFilter, pageRecord));
            classObjectString = classObjectString.concat(",");
        }); 
        classObjectString = classObjectString.concat("'s-child':" + this.getPageRecordIsChild(listingID, pageRecord)); 
        classObjectString = classObjectString.concat(",'s-disabled':" + this.getPageRecordMatchesDisableRule(listingID, pageRecord));
        classObjectString = classObjectString.concat(",'s-edited':pageRecord.edited");
        return classObjectString + "}"; 
    };
    
    public getPageRecordIsChild = (listingID, pageRecord)=>{
        var isChild = false;
        //todo implement
        return isChild;
    };
    

    //Disable Rule Logic
    public getKeyOfMatchedDisableRule = (listingID, pageRecord)=>{
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
    
    public getPageRecordMatchesDisableRule = (listingID, pageRecord)=>{
        return this.getKeyOfMatchedDisableRule(listingID, pageRecord) != -1;  
    };

    //Expandable Rule Logic
    public getKeyOfMatchedExpandableRule = (listingID, pageRecord)=>{
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
    
    public getPageRecordMatchesExpandableRule = (listingID, pageRecord)=>{
        return this.getKeyOfMatchedExpandableRule(listingID, pageRecord) != -1;  
    };

    public hasPageRecordRefreshChildrenEvent = (listingID, pageRecord)=>{
        return this.getPageRecordRefreshChildrenEvent(listingID,pageRecord) != null;
    };

    public getPageRecordRefreshChildrenEvent = (listingID, pageRecord)=>{
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord); 
        if(keyOfExpandableRuleMet != -1){
            return this.getListing(listingID).expandableRules[keyOfExpandableRuleMet].refreshChildrenEvent;
        }
    };
    
    public getPageRecordChildCollectionConfigForExpandableRule = (listingID, pageRecord) => {
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
 
}
export{ListingService};