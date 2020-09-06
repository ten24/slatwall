/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {PageDialog} from "../model/pagedialog";

interface IDialogService {
    get (): PageDialog[];
}

class DialogService{
    public static $inject = [
        'hibachiPathBuilder'
    ];
    private _pageDialogs;
    constructor(
         private hibachiPathBuilder
    ){
        this._pageDialogs = [];
        this.hibachiPathBuilder = hibachiPathBuilder;
    }

    get = (): PageDialog[] =>{
        return this._pageDialogs || [];
    };

    addPageDialog = ( name:string, params?:any ):void =>{
        var newDialog = {
            'path' : name + '.html',
            'params' : params
        };
        this._pageDialogs.push( newDialog );
    };

    removePageDialog = ( index:number ):void =>{
        this._pageDialogs.splice(index, 1);
    };

    getPageDialogs = ():any =>{
        return this._pageDialogs;
    };

    removeCurrentDialog = ():void =>{
        this._pageDialogs.splice(this._pageDialogs.length -1, 1);
    };

    getCurrentDialog = ():any =>{
        return this._pageDialogs[this._pageDialogs.length -1];
    };
}
export {
    DialogService,
    IDialogService
};
