/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

import {alertmodule} from "../alert/alert.module";
import {AlertModule} from "../alert/alert.module";
import {ExceptionHandler} from "./services/exceptionhandler";

@NgModule({
    declarations : [],
    providers: [],
    imports:[
        CommonModule, 
        UpgradeModule,
        AlertModule
    ]    
})
export class LoggerModule {
    constructor(){
        
    }    
}

var loggermodule = angular.module('logger', [alertmodule.name])
.run([function() {
}])
//.factory('$exceptionHandler', ['$injector', ($injector) => new ExceptionHandler($injector)]);;

export{
	loggermodule
}