/*jshint browser:true */
import { BaseBootStrapper } from "../../../org/Hibachi/client/src/basebootstrap";
import { slatwalladminmodule } from "./slatwall/slatwalladmin.module";

//custom bootstrapper
export class bootstrapper extends BaseBootStrapper {
  public myApplication;
  constructor() {
    var angular: any = super(slatwalladminmodule.name);
    angular.bootstrap();
  }
}