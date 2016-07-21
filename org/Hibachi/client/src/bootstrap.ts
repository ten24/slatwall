/// <reference path='../typings/hibachiTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import {BaseBootStrapper} from "./basebootstrap";
import {hibachimodule} from "./hibachi/hibachi.module";
import {loggermodule} from "./logger/logger.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;
    constructor(){
        var angular:any = super([hibachimodule.name, loggermodule.name]);
        angular.bootstrap()
    }


}

export = new bootstrapper();



