/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class ListingService{
    
    private listingDisplays = {};
    
    //@ngInject
    constructor(private $q,
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

    public getListingPageRecords = (listingID) =>{
        return this.getListing(listingID).collectionData.pageRecords; 
    }

    public setupInSingleCollectionConfigMode = (listingID, scope) =>{
        
        if (angular.isUndefined(this.getListing(listingID).collectionObject) && angular.isDefined(this.getListing(listingID).collectionConfig)){
            this.getListing(listingID).collectionObject = this.getListing(listingID).collectionConfig.baseEntityName; 
        }
        
         //add filterGroups
        angular.forEach(this.getListing(listingID).filterGroups, (filterGroup)=>{
            this.getListing(listingID).collectionConfig.addFilterGroup(filterGroup);
        });

         //add filters
        this.setupColumns(listingID,this.getListing(listingID).collectionConfig, this.getListing(listingID).collectionObject);
        angular.forEach(this.getListing(listingID).filters, (filter)=>{
                this.getListing(listingID).collectionConfig.addFilter(filter.propertyIdentifier, filter.comparisonValue, filter.comparisonOperator, filter.logicalOperator, filter.hidden);
        }); 
        
        //add order bys
        angular.forEach(this.getListing(listingID).orderBys, (orderBy)=>{
            this.getListing(listingID).collectionConfig.addOrderBy(orderBy.orderBy);
        });
        
        angular.forEach(this.getListing(listingID).aggregates, (aggregate)=>{
            this.getListing(listingID).collectionConfig.addDisplayAggregate(aggregate.propertyIdentifier, aggregate.aggregateFunction, aggregate.aggregateAlias);
        });
        
        //make sure we have necessary properties to make the actions 
        angular.forEach(this.getListing(listingID).actions, (action)=>{
            if(angular.isDefined(action.queryString)){
                var parsedProperties = this.utilityService.getPropertiesFromString(action.queryString);
                if(parsedProperties && parsedProperties.length){
                    this.getListing(listingID).collectionConfig.addDisplayProperty(this.utilityService.arrayToList(parsedProperties), "", {isVisible:false});
                }
            }
        });
        
        //also make sure we have necessary color filter properties
        angular.forEach(this.getListing(listingID).colorFilters,(colorFilter)=>{
            if(angular.isDefined(colorFilter.propertyToCompare)){
                this.getListing(listingID).collectionConfig.addDisplayProperty(colorFilter.propertyToCompare, "", {isVisible:false});
            }
        });
        
        this.getListing(listingID).exampleEntity = this.$hibachi.getEntityExample(this.getListing(listingID).collectionObject);
        if(this.getListing(listingID).collectionConfig.hasColumns()){
            this.getListing(listingID).collectionConfig.addDisplayProperty(this.getListing(listingID).exampleEntity.$$getIDName(),undefined,{isVisible:false});
        }
        
        this.initCollectionConfigData(listingID,this.getListing(listingID).collectionConfig);
         
        //this.getCollection();
        
        scope.$watch('swMultiListingDisplay.collectionPromise',(newValue,oldValue)=>{
            if(newValue){
                this.$q.when(this.getListing(listingID).collectionPromise).then((data)=>{
                    this.getListing(listingID).collectionData = data;
                    this.getListing(listingID).setupDefaultCollectionInfo();
                    if(this.getListing(listingID).collectionConfig.hasColumns()){
                        this.setupColumns(listingID,this.getListing(listingID).collectionConfig, this.getListing(listingID).collectionObject);
                    }else{
                        this.getListing(listingID).collectionConfig.loadJson(data.collectionConfig);
                    }
                    this.getListing(listingID).collectionData.pageRecords = this.getListing(listingID).collectionData.pageRecords || this.getListing(listingID).collectionData.records;
                    this.getListing(listingID).paginator.setPageRecordsInfo(this.getListing(listingID).collectionData);
                    this.getListing(listingID).searching = false;
                });
            }
        });
    };

    public initCollectionConfigData = (listingID,collectionConfig) =>{

        collectionConfig.setPageShow(this.getListing(listingID).paginator.pageShow);
        collectionConfig.setCurrentPage(this.getListing(listingID).paginator.currentPage);

        //setup export action
        if(angular.isDefined(this.getListing(listingID).exportAction)){
            this.getListing(listingID).exportAction = this.$hibachi.buildUrl('main.collectionExport')+'&collectionExportID=';
        }

        //Setup Select
        if(this.getListing(listingID).selectFieldName && this.getListing(listingID).selectFieldName.length){
            this.getListing(listingID).selectable = true;
            this.getListing(listingID).tableclass = this.utilityService.listAppend(this.getListing(listingID).tableclass,'table-select',' ');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes, 'data-selectfield="'+this.getListing(listingID).selectFieldName+'"', ' ');
        }

        //Setup MultiSelect
        if(this.getListing(listingID).multiselectFieldName && this.getListing(listingID).multiselectFieldName.length){
            this.getListing(listingID).multiselectable = true;
            this.getListing(listingID).tableclass = this.utilityService.listAppend(this.getListing(listingID).tableclass, 'table-multiselect',' ');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes,'data-multiselectpropertyidentifier="'+this.getListing(listingID).multiselectPropertyIdentifier+'"',' ');


            //attach observer so we know when a selection occurs
            this.getListing(listingID).observerService.attach(this.getListing(listingID).updateMultiselectValues,this.getListing(listingID).defaultSelectEvent,this.getListing(listingID).collectionObject);

            //attach observer so we know when a pagination change occurs
            this.getListing(listingID).observerService.attach(this.getListing(listingID).paginationPageChange,'swPaginationAction');
        }
        if(this.getListing(listingID).multiselectable && (!this.getListing(listingID).columns || !this.getListing(listingID).columns.length)){
            //check if it has an active flag and if so then add the active flag
            if(this.getListing(listingID).exampleEntity.metaData.activeProperty && !this.getListing(listingID).hasCollectionPromise){
                collectionConfig.addFilter('activeFlag',1,'=',undefined,true);
            }
        }

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
                        this.getListing(listingID).childPropertyName+'Count'
                    );
                }
            }

            this.getListing(listingID).allpropertyidentifiers = this.utilityService.listAppend(this.getListing(listingID).allpropertyidentifiers,this.getListing(listingID).exampleEntity.$$getIDName()+'Path');
            this.getListing(listingID).tableattributes = this.utilityService.listAppend(this.getListing(listingID).tableattributes, 'data-parentidproperty='+this.getListing(listingID).parentPropertyName+'.'+this.getListing(listingID).exampleEntity.$$getIDName(),' ');
        }

        if(this.getListing(listingID).multiselectIdPaths && this.getListing(listingID).multiselectIdPaths.length){
            angular.forEach(this.getListing(listingID).multiselectIdPaths.split(','),(value)=>{
                var id = this.getListing(listingID).utilityService.listLast(value,'/');
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).name,id);
            });
        }

        if(this.getListing(listingID).multiselectValues && this.getListing(listingID).multiselectValues.length){
            //select all owned ids
            angular.forEach(this.getListing(listingID).multiselectValues,(value)=>{
                this.getListing(listingID).selectionService.addSelection(this.getListing(listingID).name,value);
            });
        }

        //set defaults if value is not specifies
        this.getListing(listingID).processObjectProperties = this.getListing(listingID).processObjectProperties || '';
        this.getListing(listingID).recordProcessButtonDisplayFlag = this.getListing(listingID).recordProcessButtonDisplayFlag || true;
        this.getListing(listingID).norecordstext = this.rbkeyService.getRBKey('entity.'+this.getListing(listingID).collectionObject+'.norecords');

        //Setup Sortability
        if(this.getListing(listingID).sortProperty && this.getListing(listingID).sortProperty.length){

        }

        //Setup the admin meta info
        this.getListing(listingID).administrativeCount = 0;

        //Detail
        if(this.getListing(listingID).recordDetailAction && this.getListing(listingID).recordDetailAction.length){
            this.getListing(listingID).administrativeCount++;
            this.getListing(listingID).adminattributes = this.getListing(listingID).getAdminAttributesByType('detail');
        }

        //Edit
        if(this.getListing(listingID).recordEditAction && this.getListing(listingID).recordEditAction.length){
            this.getListing(listingID).administrativeCount++;
            this.getListing(listingID).adminattributes = this.getListing(listingID).getAdminAttributesByType('edit');
        }

        //Delete
        if(this.getListing(listingID).recordDeleteAction && this.getListing(listingID).recordDeleteAction.length){
            this.getListing(listingID).administrativeCount++;
            this.getListing(listingID).adminattributes = this.getListing(listingID).getAdminAttributesByType('delete');
        }

        //Add
        if(this.getListing(listingID).recordAddAction && this.getListing(listingID).recordAddAction.length){
            this.getListing(listingID).administrativeCount++;
            this.getListing(listingID).adminattributes = this.getListing(listingID).getAdminAttributesByType('add');
        }

        //Setup the list of all property identifiers to be used later
        angular.forEach(this.getListing(listingID).columns,(column:any)=>{
            //If this is a standard propertyIdentifier
            if(column.propertyIdentifier){
                //Add to the all property identifiers
                this.getListing(listingID).allpropertyidentifiers = this.utilityService.listAppend(this.getListing(listingID).allpropertyidentifiers,column.propertyIdentifier);
                //Check to see if we need to setup the dynamic filters, etc
                //<cfif not len(column.search) || not len(column.sort) || not len(column.filter) || not len(column.range)>
                if(
                    !column.searchable || !!column.searchable.length || !column.sort || !column.sort.length
                    ){
                    //Get the entity object to get property metaData

                    var thisEntityName = this.$hibachi.getLastEntityNameInPropertyIdentifier(this.getListing(listingID).exampleEntity.metaData.className, column.propertyIdentifier);
                    var thisPropertyName = this.utilityService.listLast(column.propertyIdentifier,'.');
                    var thisPropertyMeta = this.$hibachi.getPropertyByEntityNameAndPropertyName(thisEntityName,thisPropertyName);
                }
            //Otherwise this is a processObject property
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

        });
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

        //Setup table class
        this.getListing(listingID).tableclass = this.getListing(listingID).tableclass || '';
        this.getListing(listingID).tableclass = this.utilityService.listPrepend(this.getListing(listingID).tableclass, 'table table-bordered table-hover', ' ');
    };
    //end initCollectionConfigData

    public setupColumns = (listingID, collectionConfig, collectionObject) =>{
    //assumes no alias formatting
        for(var i=0; i < this.getListing(listingID).columns.length; i++){
            var column = this.getListing(listingID).columns[i];
            var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(collectionConfig.baseEntityName,column.propertyIdentifier);

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
                this.columnOrderBy(listingID, column);
                
                //only want to do this if it's a singleCollectionConfig
                //collectionConfig.addDisplayProperty(column.propertyIdentifier,column.title,column);
        }
        //if the passed in collection has columns perform some formatting
        if(this.getListing(listingID).hasCollectionPromise){
            //assumes alias formatting from collectionConfig
            angular.forEach(collectionConfig.columns, (column)=>{

                var lastEntity = this.$hibachi.getLastEntityNameInPropertyIdentifier(collectionObject,this.utilityService.listRest(column.propertyIdentifier,'.'));
                column.title = column.title || this.rbkeyService.getRBKey('entity.'+lastEntity.toLowerCase()+'.'+this.utilityService.listLast(column.propertyIdentifier,'.'));
                if(angular.isUndefined(column.isVisible)){
                    column.isVisible = true;
                }
            });
        }
    };

    public setupDefaultGetCollection = (listingID) =>{
        if(this.getListing(listingID).collectionConfigs.length == 0){
            this.getListing(listingID).collectionPromise = this.getListing(listingID).collectionConfig.getEntity();

            return ()=>{
                this.getListing(listingID).collectionConfig.setCurrentPage(this.getListing(listingID).paginator.getCurrentPage());
                this.getListing(listingID).collectionConfig.setPageShow(this.getListing(listingID).paginator.getPageShow());
                this.getListing(listingID).collectionConfig.getEntity().then((data)=>{
                    this.getListing(listingID).collectionData = data;
                    this.getListing(listingID).setupDefaultCollectionInfo();
                    this.getListing(listingID).collectionData.pageRecords = this.getListing(listingID).collectionData.pageRecords || this.getListing(listingID).collectionData.records;
                    this.getListing(listingID).paginator.setPageRecordsInfo(this.getListing(listingID).collectionData);
                });
            };
        } else { 
            //Multi Collection Config Info Here
            return ()=>{
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
                           //error callback to be implemented
                        }
                    ); 
                } 
                //todo pagination logic
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
        } else { 
            //multicollection logic here
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
            return this.utilityService.replaceAll(propertyIdentifierWithoutAlias,'.','_')
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
                    switch (rule.filterComparisonOperator){
                        case "!=":
                            if(pageRecordValue != rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break; 
                        case ">":
                            if(pageRecordValue > rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break;
                        case ">=":  
                            if(pageRecordValue >= rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break;
                        case "<":
                            if(pageRecordValue < rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break; 
                        case "<=":
                            if(pageRecordValue <= rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break; 
                        case "is":
                            if(pageRecordValue == rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break;
                        case "is not": 
                            if(pageRecordValue != rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break; 
                        default: 
                            //= case
                            if(pageRecordValue == rule.filterComparisonValue){
                                disableRuleMatchedKey = key; 
                            }
                            break; 
                    }
                    if(disableRuleMatchedKey != -1){
                        return disableRuleMatchedKey;
                    }
                }
            }); 
        }  
        return disableRuleMatchedKey;
    }
    
    public getPageRecordMatchesDisableRule = (listingID, pageRecord)=>{
        var keyOfDisableRuleMet = this.getKeyOfMatchedDisableRule(listingID, pageRecord); 
        return keyOfDisableRuleMet != -1;  
    }

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
                    switch (rule.filterComparisonOperator){
                        case "!=":
                            if(pageRecordValue != rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                        case ">":
                            if(pageRecordValue > rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break;
                        case ">=":  
                            if(pageRecordValue >= rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break;
                        case "<":
                            if(pageRecordValue < rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                        case "<=":
                            if(pageRecordValue <= rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                        default: 
                            //= case
                            if(pageRecordValue == rule.filterComparisonValue){
                                expandableRuleMatchedKey = key; 
                            }
                            break; 
                    }
                    if(expandableRuleMatchedKey != -1){
                        return expandableRuleMatchedKey;
                    }
                }
            }); 
        }  
        return expandableRuleMatchedKey;
    }
    
    public getPageRecordMatchesExpandableRule = (listingID, pageRecord)=>{
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord); 
        return keyOfExpandableRuleMet != -1;  
    }

    public hasPageRecordRefreshChildrenEvent = (listingID, pageRecord)=>{
        return this.getPageRecordRefreshChildrenEvent(listingID,pageRecord) != null;
    }

    public getPageRecordRefreshChildrenEvent = (listingID, pageRecord)=>{
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord); 
        if(keyOfExpandableRuleMet != -1){
            return this.getListing(listingID).expandableRules[keyOfExpandableRuleMet].refreshChildrenEvent;
        }
    }
    
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
    }   
 
}
export{ListingService};

