/// <reference path='../typings/slatwallTypescript.d.ts' />
/// <reference path='../typings/tsd.d.ts' />
/*jshint browser:true */
import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";
import {slatwalladminmodule} from "./slatwall/slatwalladmin.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;
    
    constructor(){
        var bootstraper:any = super(slatwalladminmodule.name);

        if(__DEBUG_MODE__){
            bootstraper.loading( () => {
                console.log("Boostraping Slatwall-Admin-module STARTED, will resolve dependencies(config, rb-keys)");
            })
            .done( () => {
                console.log("Bootstraping Slatwall-Admin-module COMPLETED");
            })
        }
        
        // strictDI ==> true/false, should be set to true to test if we can mangle the js
        bootstraper.bootstrap(false);
    }


}

export = new bootstrapper();



