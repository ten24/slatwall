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
            return this.typeaheadData[key].splice(index,1)[0];//this will always be an array of 1 element
        }
    }
    
    getData = (key:string) => {
        return this.typeaheadData[key] || [];
    }
    
    //strips out dangerous directives that cause infinite compile errors 
    // - this probably belongs in a different service but is used for typeahead only at the moment
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
