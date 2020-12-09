/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";

import {SWTermScheduleTable} from "./components/swtermscheduletable";
import {TermService} from "./services/termservice";
 
var termmodule = angular.module('term',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('termPartialsPath','term/components/')
//controllers
.directive('swTermScheduleTable', SWTermScheduleTable.Factory())
.service('termService',TermService)

export{
	termmodule
};