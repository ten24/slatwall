/*jshint browser:true */
import {BaseBootStrapper} from "../../../../org/Hibachi/client/src/basebootstrap";
import {monatadminmodule} from "./monatadmin/monatadmin.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;
    constructor(){
        var bootstraper:any = super(monatadminmodule.name);
        
        if(__DEBUG_MODE__){
            bootstraper.loading( () => {
                console.log("Boostraping Monat-frontend-module STARTED, will resolve dependencies(config, rb-keys)");
            })
            .done( () => {
                console.log("Bootstraping Monat-frontend-module COMPLETED");
            })
        }
        
        // strictDI ==> true/false, should be set to true to test if we can mangle the js
        bootstraper.bootstrap(false) 
    }

}

export = new bootstrapper();
