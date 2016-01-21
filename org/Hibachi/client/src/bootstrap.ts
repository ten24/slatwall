/// <reference path='../typings/hibachiTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import {BaseBootStrapper} from "./basebootstrap";
import {hibachimodule} from "./hibachi/hibachi.module";
import {loggermodule} from "./logger/logger.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{

    constructor(){
        this.myApplication = [hibachimodule.name, loggermodule.name];
        var angular:any = super();
        angular.bootstrap()
    }


}

export = new bootstrapper();



