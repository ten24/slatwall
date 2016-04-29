/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class TypeaheadService{
    
    public typeaheadData = {};
    
    constructor(
        
    ){
        
    }
    
    addRecord = (key:string, data:any) => {
        this.typeaheadData[key] = data; 
    } 
    
    getData = (key:string) => {
        var dataToReturn = this.typeaheadData[key];
        if(angular.isDefined(dataToReturn)){
            return dataToReturn;
        }
        return false; 
    }
}

export{
    TypeaheadService
};