/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";

import {SWCustomerAccountCard} from "./components/swcustomeraccountcard";


var accountmodule = angular.module('account',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('accountPartialsPath','account/components/')
//controllers
.directive('swCustomerAccountCard', SWCustomerAccountCard.Factory())
;
export{
	accountmodule
};