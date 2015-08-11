/*services return promises which can be handled uniquely based on success or failure by the controller*/
module slatwalladmin{
    export class SelectionService extends BaseService{
        constructor(){
            this._selection = {};    
        }
        addSelection=(selectionid:string,selection:any):void =>{
            if(angular.isUndefined(this._selection[selectionid])){
                this._selection[selectionid] = [];    
            }
            this._selection[selectionid].push(selection);
        }
        removeSelection=(selectionid:string,selection:any):void =>{
            if(angular.isUndefined(this._selection[selectionid])){
                this._selection[selectionid] = [];    
            }
            var index = this._selection[selectionid].indexOf(selection);
            if (index > -1) {
                this._selection[selectionid].splice(index, 1);
            }
        }
        hasSelection=(selectionid:string,selection:any):boolean =>{
            if(angular.isUndefined(this._selection[selectionid])){
                return false;    
            }
            var index = this._selection[selectionid].indexOf(selection);
            if (index > -1) {
                return true;   
            }
        }
        getSelections=(selectionid:string):any =>{
            return this._selection[selectionid];    
        }
    }
    angular.module('slatwalladmin').service('selectionService',SelectionService);
}
//angular.module('slatwalladmin')
//.factory('selectionService',[ 
//	function(
//	){
//		//declare public and private variables
//		
//		//selections have a unique identifier for the instance they are related to 
//		var  = {};
//		//declare service we are returning
//		var selectService = { 
//			addSelection: function(selectionid,selection){
//                if(angular.isUndefined(_selection[selectionid])){
//                    _selection[selectionid] = [];    
//                }
//                _selection[selectionid].push(selection);
//            },
//            removeSelection: function(selectionid,selection){
//                if(angular.isUndefined(_selection[selectionid])){
//                    _selection[selectionid] = [];    
//                }
//                var index = _selection[selectionid].indexOf(selection);
//                if (index > -1) {
//                    _selection[selectionid].splice(index, 1);
//                }
//            },
//            hasSelection: function(selectionid,selection){
//                if(angular.isUndefined(_selection[selectionid])){
//                    return false;    
//                }
//                var index = _selection[selectionid].indexOf(selection);
//                if (index > -1) {
//                    return true;   
//                }
//            },
//            getSelections: function(selectionid){
//                return _selection[selectionid];    
//            }
//		};
//		
//		return selectService;
//	}
//]);
