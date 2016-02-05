/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{

    constructor(){
        this.myApplication = slatwalladminmodule.name;
        var angular:any = super();
        angular.bootstrap()
    }


}

export = new bootstrapper();



