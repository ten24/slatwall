/*jshint browser:true */
import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";
import {monatfrontendmodule} from "./monatfrontend/monatfrontend.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    
    constructor(){
        var bootstraper:any = super(monatfrontendmodule.name);
        
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
