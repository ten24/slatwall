/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {UtilityService} from "./services/utilityservice";
import {SelectionService} from "./services/selectionservice";
import {ObserverService} from "./services/observerservice";
//filters
import {PercentageFilter} from "./filters/percentage";


var coremodule = angular.module('hibachi.core',[]).config(()=>{
})
//services
.service('utilityService',UtilityService)
.service('selectionService',SelectionService)
.service('observerService',ObserverService)  
//filters 
.filter('percentage',[PercentageFilter.Factory])
;  
export{
	coremodule
}