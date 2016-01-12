/*jshint browser:true */
//'use strict';
//require('./vendor.ts')();
//import {coremodule} from "./core/core.module";
import {BaseBootStrapper} from "./basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";
import {loggermodule} from "./logger/logger.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    
    constructor(){
        this.myApplication = [slatwalladminmodule.name, loggermodule.name];
        super().bootstrap();
    }
    
    
} 

export = new bootstrapper();



