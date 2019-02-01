/*jshint browser:true */


import {BaseBootStrapper} from "../basebootstrap";
import {frontendmodule} from "./frontend.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    constructor(){

      var angular:any = super(frontendmodule.name);
      angular.bootstrap()
    }
}

export = new bootstrapper();


