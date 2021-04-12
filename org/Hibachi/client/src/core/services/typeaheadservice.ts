/// <reference path="../../../../../../node_modules/typescript/lib/lib.es6.d.ts" />
/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import * as TypeaheadStore from '../prototypes/swstore';
import {Observable, Subject} from 'rxjs';


class TypeaheadService {
    
    public typeaheadData = {};
    
    public typeaheadPromises = {};
    
    //The state of the store
    private typeaheadStates = {};
    
    private state:Object = {
        typeaheadInstances: this.typeaheadStates
    };

    /**
     * The reducer is responsible for modifying the state of the state object into a new state.
     */
    public typeaheadStateReducer = (state, action:TypeaheadStore.Action<string>):Object => {
        switch(action.type) {
            case 'TYPEAHEAD_QUERY':
                //modify the state.
                return {
                    ...state, action
                };
            case 'TYPEAHEAD_USER_SELECTION':
                //passthrough - no state change. anyone subscribed can handle this.
                return {
                    ...state, action
                };
            default:
                return state;
        }
    }

    /**
     *  Store stream. Set the initial state of the typeahead using startsWith and then scan. 
     *  Scan, is an accumulator function. It keeps track of the last result emitted, and combines
     * it with the newest result. 
     */
    public typeaheadStore:any;


    //@ngInject
    constructor(public $timeout, public observerService){
        this.typeaheadStore = new TypeaheadStore.IStore(this.state, this.typeaheadStateReducer);//.combineLatest(this.loggerEpic)
    }
    
    public getTypeaheadSelectionUpdateEvent = (key:string) =>{
        return "typeaheadSelectionUpdated" + key; 
    }
    
    public getTypeaheadClearSearchEvent = (key:string) =>{
        return key + "clearSearch"; 
    }

    public attachTypeaheadSelectionUpdateEvent = (key:string, callback) =>{
        let eventKey = this.getTypeaheadSelectionUpdateEvent(key);
        this.observerService.attach(callback, eventKey);
    }

    public notifyTypeaheadSelectionUpdateEvent = (key:string, data:any) =>{
        let eventKey = this.getTypeaheadSelectionUpdateEvent(key);
        this.observerService.notify(eventKey, data); 
    }
    
    public notifyTypeaheadClearSearchEvent = (key:string, data:any) =>{
        let eventKey = this.getTypeaheadClearSearchEvent(key);
        this.observerService.notify(eventKey, data); 
    }

    public setTypeaheadState = (key:string, state:any) =>{
        this.typeaheadStates[key] = state;
    }

    public getTypeaheadState = (key:string) =>{
        return this.typeaheadStates[key];
    }

    public getTypeaheadPrimaryIDPropertyName = (key:string) =>{
        return this.getTypeaheadState(key).primaryIDPropertyName;
    }

    public getIndexOfSelection = (key:string, newSelection:any) =>{
        const oldSelections = this.getData(key);
        const primaryIdKey = this.getTypeaheadPrimaryIDPropertyName(key);
        
        for(var j = 0; j < oldSelections.length; j++ ){
            const oldSelection = oldSelections[j];
            if( angular.isDefined( newSelection[primaryIdKey] ) && newSelection[primaryIdKey] == oldSelection[primaryIdKey] ){
                return j;
            } else if ( this.checkAgainstFallbackProperties(key, oldSelection, newSelection) ){
                return j;
            }
        }
        return -1; 
    }
    
    public addSelection = (key:string, data:any) => {
        if(angular.isUndefined(this.typeaheadData[key])){
            this.typeaheadData[key] = [];
        }
        this.typeaheadData[key].push(data); 
        this.notifyTypeaheadSelectionUpdateEvent(key,data); 
       
    } 

    public removeSelection = (key:string, index:number, data?:any) => {
        if( angular.isUndefined(index) &&
            angular.isDefined(data)
        ){
            index = this.getIndexOfSelection(key, data);
        }
        if( angular.isDefined(index) && 
            angular.isDefined(this.typeaheadData[key]) && 
            index != -1
        ){
            this.updateSelections(key);
            var removedItem = this.typeaheadData[key].splice(index,1)[0];//this will always be an array of 1 element
            this.notifyTypeaheadSelectionUpdateEvent(key,removedItem); 
            return removedItem; 
        }
    }

    public initializeSelections = (key:string, selectedCollectionConfig) => {
        selectedCollectionConfig.setAllRecords(true);
        this.typeaheadPromises[key] = selectedCollectionConfig.getEntity();
        this.typeaheadPromises[key].then(
            (data)=>{
                for(var j=0; j< data.records.length; j++){
                    this.addSelection(key, data.records[j]); 
                }
            },
            (reason)=>{
                throw("typeaheadservice had trouble intializing selections for " + key + " because " + reason); 
            }
        );
    }

    public updateSelections = (key:string) => {
        
        const oldSelections = this.getData(key);
        const state = this.getTypeaheadState(key);
        const results = state.results;
        const primaryIdKey = this.getTypeaheadPrimaryIDPropertyName(key);
        
        results.forEach( (result, resultIndex) =>{
            oldSelections.find( (selection, selectionIndex) => {
                
                if(selection[primaryIdKey] == result[primaryIdKey] ){
                    this.markResultSelected(result, selectionIndex);
                    return true;
                }
                
                var found = this.checkAgainstFallbackProperties( key, selection, result, selectionIndex );
                if(found){
                    return true;
                }
                
            });
        });
    }

    private markResultSelected = (result, index) => {
        result.selected = true;
        result.selectedIndex = index; 
    }   

    private checkAgainstFallbackProperties = (key:string, selection:any, result:any, selectionIndex?:number) =>{
        const primaryIdKey = this.getTypeaheadPrimaryIDPropertyName(key);
        const resultPrimaryID = result[primaryIdKey];
        const state = this.getTypeaheadState(key);
        
        //is there a singular property to compare against
        if(state?.propertyToCompare?.length){
            const propertyToCompare = state.propertyToCompare;
            let found = false;
            
            if( 
                angular.isDefined(selection[propertyToCompare]) &&
                selection[propertyToCompare] == resultPrimaryID
            ){
                found = true;
            }

            if( !found &&
                angular.isDefined(selection[propertyToCompare]) &&
                angular.isDefined(result[propertyToCompare]) &&
                selection[propertyToCompare] == result[propertyToCompare]
            ){
                found = true;
            }
            
            if(found){
                if(angular.isDefined(selectionIndex) ){
                    this.markResultSelected(result, selectionIndex); 
                }
                return true; 
            }
        }
        
        //check the defined fallback properties to see if theres a match
        if( state?.fallbackPropertyArray?.length ){
            const fallbackPropertyArray = state.fallbackPropertyArray;
            
            for(let j=0; j < fallbackPropertyArray.length; j++ ){
                const fallbackProperty = fallbackPropertyArray[j]; 
                if( angular.isDefined(selection[fallbackProperty]) ){
                    let found = false;
                    if( selection[fallbackProperty] == resultPrimaryID ){
                        found = true;
                    }
                    
                    if( 
                        !found &&
                        angular.isDefined(result[fallbackProperty]) &&
                        selection[fallbackProperty] == result[fallbackProperty]
                    ){
                        found = true;
                    }
                    
                    if(found){
                        if(angular.isDefined(selectionIndex) ){
                            this.markResultSelected(result, selectionIndex); 
                        }
                        return true; 
                    }
                }
            }
        }
        
        return false; 
    }

    public updateSelectionList = (key:string)=>{
        let selectionIDArray = [];
        const oldSelections = this.getData(key) || [];
        const state = this.getTypeaheadState(key);
        const propertyToCompare = state.propertyToCompare;

        for(let j = 0; j < oldSelections.length; j++){
            const selection = oldSelections[j]; 
            const primaryIdKey = this.getTypeaheadPrimaryIDPropertyName(key);
            
            const primaryID = selection[primaryIdKey];

            if(primaryID){
                selectionIDArray.push(primaryID);
                
            } else if( propertyToCompare && angular.isDefined(selection[propertyToCompare]) ){
                
                selectionIDArray.push(selection[propertyToCompare]);
                
            } else if( angular.isDefined(state.fallbackPropertyArray) ){
                
                var fallbackPropertyArray = state.fallbackPropertyArray;
                for(var i=0; i < fallbackPropertyArray.length; i++){
                    var fallbackProperty = fallbackPropertyArray[i]; 
                    if( angular.isDefined(selection[fallbackProperty]) ){
                        selectionIDArray.push( selection[fallbackProperty] );
                        break; 
                    }
                }
            }
            
        }
        
        return selectionIDArray.join(",");
    }
    
    getData = (key:string) => {
        if(key in this.typeaheadPromises){
            //wait until it's been intialized
            this.typeaheadPromises[key].then().finally(()=>{
                return this.typeaheadData[key] || [];
            }); 
            delete this.typeaheadPromises[key];
        } else {
            return this.typeaheadData[key] || [];
        }
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
