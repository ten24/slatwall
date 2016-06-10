/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class ListingService{
    
    private listingDisplays = {};
    
    //@ngInject
    constructor(private utilityService){}
    
    public setListingState = (listingID, state) =>{
        this.listingDisplays[listingID] = state; 
    }

    //Disable Rule Logic
    public getKeyOfMatchedDisableRule = (listingID, pageRecord)=>{
        var disableRuleMatchedKey = -1; 
        if(angular.isDefined(this.listingDisplays[listingID].disableRules)){
            angular.forEach(this.listingDisplays[listingID].disableRules, (rule, key)=>{
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
        if(angular.isDefined(this.listingDisplays[listingID].expandableRules)){
            angular.forEach(this.listingDisplays[listingID].expandableRules, (rule, key)=>{
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
    
    public getPageRecordChildCollectionConfigForExpandableRule = (listingID, pageRecord) => {
        var keyOfExpandableRuleMet = this.getKeyOfMatchedExpandableRule(listingID, pageRecord); 
        if(angular.isDefined(pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]) 
            && angular.isDefined(this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]])
        ){
            return this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]];
        }
        if(keyOfExpandableRuleMet != -1){
           var childCollectionConfig = this.listingDisplays[listingID].expandableRules[keyOfExpandableRuleMet].childrenCollectionConfig.clone();
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
           console.log("childCollectionConfig",childCollectionConfig);
           this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]] = childCollectionConfig; 
           return this.listingDisplays[listingID].childCollectionConfigs[pageRecord[this.listingDisplays[listingID].exampleEntity.$$getIDName()]];
        } 
    }    
}
export{ListingService};

