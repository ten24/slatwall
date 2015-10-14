/*services return promises which can be handled uniquely based on success or failure by the controller*/
module slatwalladmin{
    export class SelectionService extends BaseService{
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
            this._selection[selectionid].push(selection);
        };
        setSelection=(seleciontid:string,selections:any[]):void =>{
            this._selection[selectionid] = selections;
        };
        removeSelection=(selectionid:string,selection:any):void =>{
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
    }
    angular.module('slatwalladmin').service('selectionService',SelectionService);
}
