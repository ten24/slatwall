/*jshint browser:true */
import {BaseBootStrapper} from "../../../../org/Hibachi/client/src/basebootstrap";
import {monatadminmodule} from "./monatadmin/monatadmin.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    public myApplication;
    constructor(){
        var angular:any = super(monatadminmodule.name);
        angular.bootstrap();
    }

}

export = new bootstrapper();
