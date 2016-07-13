/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class TypeaheadService{
    
    public typeaheadData = {};
    
    constructor(
        
    ){
        
    }
    
    addSelection = (key:string, data:any) => {
        if(angular.isUndefined(this.typeaheadData[key])){
            this.typeaheadData[key] = [];
        }
        this.typeaheadData[key].push(data); 
    } 

    removeSelection = (key:string, index:number) => {
        if(angular.isDefined(this.typeaheadData[key])){
            this.typeaheadData[key].splice(index,1);
        }
    }
    
    getData = (key:string) => {
        return this.typeaheadData[key] || [];
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
