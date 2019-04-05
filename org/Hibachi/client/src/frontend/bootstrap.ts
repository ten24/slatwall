/*jshint browser:true */

import { BaseBootStrapper } from "../basebootstrap";
import { frontendmodule } from "./frontend.module";

//custom bootstrapper
export class bootstrapper extends BaseBootStrapper {
  constructor() {
    var angular: any = super(frontendmodule.name);
    angular.bootstrap();
  }
}
