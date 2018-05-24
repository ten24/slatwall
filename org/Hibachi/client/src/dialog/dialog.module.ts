/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

//services
import {DialogService} from "./services/dialogservice";

//controllers
import {PageDialogController} from "./controllers/pagedialog";

@NgModule({
    declarations: [],
    providers:[
        DialogService
    ],
    imports:[
        CommonModule,
        UpgradeModule
    ]
})

export class DialogModule{
    constructor(){
    
    }    
}

var dialogmodule = angular.module('hibachi.dialog',[]).config(()=>{
})
//services
.service('dialogService', downgradeInjectable(DialogService))
//controllers
.controller('pageDialog',PageDialogController)
//filters
//constants
.constant('dialogPartials','dialog/components/')
;
export{
	dialogmodule
}