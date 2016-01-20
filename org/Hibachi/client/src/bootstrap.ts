/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import {BaseBootStrapper} from "./basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
import {loggermodule} from "./logger/logger.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{

    constructor(){
        this.myApplication = [slatwalladminmodule.name, loggermodule.name];
        var angular:any = super();
        angular.bootstrap()
    }


}

export = new bootstrapper();



