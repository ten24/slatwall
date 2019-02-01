/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class ExpandableService{
    
    public recordStates = {};
    
    //ngInject
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
        if(angular.isUndefined(this.recordStates[recordID])){
            this.recordStates[recordID] = {}; 
        }
        for(var key in state){
            this.recordStates[recordID][key] = state[key];
        }
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