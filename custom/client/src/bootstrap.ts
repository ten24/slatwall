/*jshint browser:true */
import {BaseBootStrapper} from "../../../org/Hibachi/client/src/basebootstrap";
import {monatfrontendmodule} from "./monatfrontend/monatfrontend.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;
    constructor(){
        var angular:any = super(monatfrontendmodule.name);
        angular.bootstrap()
    }


}

export = new bootstrapper();
