/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class ExpandableService{
    
    public recordStates = {};
    
    constructor(
        
    ){
        
    }
    
    addRecord = (recordID:string, state?:any) => {
        if(angular.isUndefined(state)){
            state = {isLoaded:true};
        }
        this.recordStates[recordID] = state; 
    } 
    
    updateState = (recordID:string, state:any) => {
        this.recordStates[recordID] = state; 
    }
    
    getState = (recordID:string, key?:string) => {
        if(angular.isDefined(this.recordStates[recordID]) && angular.isDefined(key)){
            var dataToReturn = this.recordStates[recordID][key];
        } else {
            var dataToReturn = this.recordStates[recordID];
        }
        if(angular.isDefined(dataToReturn)){
            return dataToReturn;
        }
        return false; 
    }
}

export{
    ExpandableService
};