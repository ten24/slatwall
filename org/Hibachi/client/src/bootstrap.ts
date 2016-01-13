/*jshint browser:true */
import {BaseBootStrapper} from "./basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
import {loggermodule} from "./logger/logger.module";
import {coremodule} from "./core/core.module";
//custom bootstrapper
class bootstrapper extends BaseBootStrapper{

    constructor(){
        this.myApplication = [coremodule.name];
        var angular:any = super();
        angular.bootstrap()
    }


}

export = new bootstrapper();



