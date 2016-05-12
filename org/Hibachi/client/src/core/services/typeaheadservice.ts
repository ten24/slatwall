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
    }
    
    //strips out dangerous directives that cause infinite compile errors
    stripTranscludedContent = (transcludedContent) => {
        for(var i=0; i < transcludedContent.length; i++){
            if(angular.isDefined(transcludedContent[i].localName) && 
            transcludedContent[i].localName == 'ng-transclude'
            ){
                transcludedContent = transcludedContent.children();
            }
        }
        
        //prevent collection config from being recompiled
        for(var i=0; i < transcludedContent.length; i++){
            if(angular.isDefined(transcludedContent[i].localName) && 
            transcludedContent[i].localName == 'sw-collection-config'
            ){
                transcludedContent.splice(i,1);
            }
        }
        
        return transcludedContent; 
    }
}

export{
    TypeaheadService
};
