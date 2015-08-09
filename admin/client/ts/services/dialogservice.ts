/// <reference path='../../../../client/typings/slatwallTypescript.d.ts' />
/// <reference path='../../../../client/typings/tsd.d.ts' />

module slatwalladmin{
    export interface IDialogService {
        get (): PageDialog[];
    }
    
    export class DialogService extends BaseService{
        public static $inject = [
            'partialsPath'
        ];    
        private _pageDialogs;
        constructor(
             private partialsPath
        ){
            super();
            this._pageDialogs = [];
        }
        
        get = (): PageDialog[] =>{
            return this._pageDialogs || [];
        }
        
        addPageDialog = ( name:PageDialog ):void =>{
            var newDialog = {
                'path' : this.partialsPath + name + '.html'
            };
            this._pageDialogs.push( newDialog );
        }
        
        removePageDialog = ( index:number ):void =>{
            this._pageDialogs.splice(index, 1);
        }
        
        getPageDialogs = ():any =>{
            return this._pageDialogs;
        }
    }
    angular.module('slatwalladmin').service('dialogService', DialogService);
}

