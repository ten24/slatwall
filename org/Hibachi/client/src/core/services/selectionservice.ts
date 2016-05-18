/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
/*services return promises which can be handled uniquely based on success or failure by the controller*/

import {BaseService} from "./baseservice";

class SelectionService extends BaseService{
    private _selection ={};
    //@ngInject
    constructor(
        public observerService
    ){
        super();
    }
    /* add current selectionid to main selection object*/
    createSelections=(selectionid)=>{
        this._selection[selectionid] = {
            allSelected: false,
            ids: []
        };
    };
    radioSelection=(selectionid:string,selection:any):void =>{
        this.createSelections(selectionid);
        this._selection[selectionid].ids.push(selection);
        this.observerService.notify('swSelectionToggleSelection',{action:'check',selectionid,selection});
    };
    addSelection=(selectionid:string,selection:any):void =>{
        /*if allSelected flag is true addSelection will remove selection*/
        if(this.isAllSelected(selectionid)){
            var index = this._selection[selectionid].ids.indexOf(selection);
            if (index > -1) {
                this._selection[selectionid].ids.splice(index, 1);
                this.observerService.notify('swSelectionToggleSelection',{action:'check',selectionid,selection});
            }
        }else if(!this.hasSelection(selectionid,selection)){
            this._selection[selectionid].ids.push(selection);
            this.observerService.notify('swSelectionToggleSelection',{action:'check',selectionid,selection});
        }

        console.info(this._selection[selectionid])
    };
    setSelection=(selectionid:string,selections:any[]):void =>{
        if(angular.isUndefined(this._selection[selectionid])){
            this.createSelections(selectionid);
        }
        this._selection[selectionid].ids = selections;
    };
    removeSelection=(selectionid?:string,selection?:any):void =>{
        if(angular.isUndefined(this._selection[selectionid])){
            return;
        }

        if(!this.isAllSelected(selectionid)){
            var index = this._selection[selectionid].ids.indexOf(selection);
            if (index > -1) {
                this._selection[selectionid].ids.splice(index, 1);
                this.observerService.notify('swSelectionToggleSelection',{action:'uncheck',selectionid,selection});
            }
        /*if allSelected flag is true removeSelection will add selection*/
        }else if(!this.hasSelection(selectionid,selection)) {
            this._selection[selectionid].ids.push(selection);
            this.observerService.notify('swSelectionToggleSelection', {action: 'uncheck', selectionid, selection});
        }
        console.info(this._selection[selectionid])
    };
    hasSelection=(selectionid:string,selection:any):boolean =>{
        if(angular.isUndefined(this._selection[selectionid])) {
            return false;
        }
        return this._selection[selectionid].ids.indexOf(selection) > -1;
    };
    getSelections=(selectionid:string):any =>{
        if(angular.isUndefined(this._selection[selectionid])){
            this.createSelections(selectionid);
        }
        return this._selection[selectionid].ids;
    };
    getSelectionCount=(selectionid:string):any =>{
        if(angular.isUndefined(this._selection[selectionid])){
            this.createSelections(selectionid);
        }
        return this._selection[selectionid].ids.length;
    };
    clearSelection=(selectionid):void=>{
        this.createSelections(selectionid);
        this.observerService.notify('swSelectionToggleSelection',{action:'clear'});
        console.info(this._selection[selectionid])
    };
    selectAll=(selectionid):void=>{
        this._selection[selectionid] = {
            allSelected: true,
            ids: []
        };
        this.observerService.notify('swSelectionToggleSelection',{action:'selectAll'});
        console.info(this._selection[selectionid])
    };
    isAllSelected=(selectionid)=>{
        if(angular.isUndefined(this._selection[selectionid])){
            this.createSelections(selectionid);
        }
        return this._selection[selectionid].allSelected;
    }
}
export {
    SelectionService
};