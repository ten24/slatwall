/*jshint browser:true */


import {BaseBootStrapper} from "../basebootstrap";
import {frontendmodule} from "./frontend.module";

//custom bootstrapper
class bootstrapper extends BaseBootStrapper{
    constructor(){
      this.myApplication = frontendmodule.name;
      var angular:any = super();
      angular.bootstrap()
    }
}

export = new bootstrapper();


