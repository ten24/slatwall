/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";

import {SWAddressFormPartial} from "./components/swaddressformpartial";

var addressmodule = angular.module('address',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('addressPartialsPath','address/components/')
//components
.directive('swAddressFormPartial', SWAddressFormPartial.Factory())
;
export{
	addressmodule
};