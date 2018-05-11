/// <reference path='../../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import {PageDialog} from "../model/pagedialog";
import {Injectable} from "@angular/core";

@Injectable()
export class DialogService{
    private pageDialogs;
    constructor(
         //private hibachiPathBuilder
    ){
        this.pageDialogs = [];
        //this.hibachiPathBuilder = hibachiPathBuilder;
    }

    get(): PageDialog[] {
        return this.pageDialogs || [];
    };

   addPageDialog( name:string, params?:any ):void {
        var newDialog = {
            'path' : name + '.html',
            'params' : params
        };
        this.pageDialogs.push( newDialog );
        //this.pageDialogs.push(new PageDialog(name+".html",params));
    };

    removePageDialog( index:number ):void {
        this.pageDialogs.splice(index, 1);
    };

    getPageDialogs():any {
        return this.pageDialogs;
    };

    removeCurrentDialog():void {
        this.pageDialogs.splice(this.pageDialogs.length -1, 1);
    };

    getCurrentDialog():any {
        return this.pageDialogs[this.pageDialogs.length -1];
    };
}