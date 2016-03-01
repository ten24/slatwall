/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/

import {BaseService} from "./baseservice";

class SelectionService extends BaseService{
    private _selection ={};
    constructor(){
        super();
    }
    radioSelection=(selectionid:string,selection:any):void =>{
        this._selection[selectionid] = [];
        this._selection[selectionid].push(selection);
    };
    addSelection=(selectionid:string,selection:any):void =>{
        if(angular.isUndefined(this._selection[selectionid])){
            this._selection[selectionid] = [];
        }
        if(!this.hasSelection(selectionid,selection)){
            this._selection[selectionid].push(selection);
        }
    };
    setSelection=(selectionid:string,selections:any[]):void =>{
        this._selection[selectionid] = selections;
    };
    removeSelection=(selectionid?:string,selection?:any):void =>{
        if(angular.isUndefined(this._selection[selectionid])){
            this._selection[selectionid] = [];
        }
        var index = this._selection[selectionid].indexOf(selection);
        
        if (index > -1) {
            this._selection[selectionid].splice(index, 1);
        }
        
    };
    hasSelection=(selectionid:string,selection:any):boolean =>{
        if(angular.isUndefined(this._selection[selectionid])){
            return false;
        }
        var index = this._selection[selectionid].indexOf(selection);
        if (index > -1) {
            return true;
        }
    };
    getSelections=(selectionid:string):any =>{
        return this._selection[selectionid];
    };
    clearSelection=(selectionid):void=>{
        this._selection[selectionid] = [];
    };
}
export {
    SelectionService
};