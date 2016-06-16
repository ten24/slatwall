/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class ListingService{
    
    private listingDisplays = {};
    
    //@ngInject
    constructor(private utilityService, private rbkeyService, private $hibachi){}
    
    public setListingState = (listingID, state) =>{
        this.listingDisplays[listingID] = state; 
    }

    public getListing = (listingID) => {
        return this.listingDisplays[listingID];
    }

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
    }

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

