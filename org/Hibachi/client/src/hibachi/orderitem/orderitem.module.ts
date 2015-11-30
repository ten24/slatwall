/// <reference path="../../../typings/tsd.d.ts" />
/// <reference path="../../../typings/slatwallTypeScript.d.ts" />
import {coremodule} from '../core/core.module';
//directives
import {SWChildOrderItem} from "./components/swchildorderitem";
var orderitemmodule = angular.module('hibachi.orderitem', [coremodule.name])
// .config(['$provide','baseURL',($provide,baseURL)=>{
// 	$provide.constant('paginationPartials', baseURL+basePartialsPath+'pagination/components/');
// }])
.run([()=> {
}])
//directives
.directive('swChildOrderItem',SWChildOrderItem.Factory())

//constants
.constant('orderItemPartialsPath','orderitem/components/')
;

export{
	orderitemmodule
}




