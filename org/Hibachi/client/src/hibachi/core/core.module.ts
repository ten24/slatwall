/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {UtilityService} from "./services/utilityservice";
import {SelectionService} from "./services/selectionservice";
import {ObserverService} from "./services/observerservice";
import {FormService} from "./services/formservice";
import {MetaDataService} from "./services/metadataservice";
//filters
import {PercentageFilter} from "./filters/percentage";


var coremodule = angular.module('hibachi.core',[]).config(()=>{
})
//services
.service('utilityService',UtilityService)
.service('selectionService',SelectionService)
.service('observerService',ObserverService)  
.service('formService',FormService)
.service('metadataService',MetaDataService)
//filters 
.filter('percentage',[PercentageFilter.Factory])
;  
export{
	coremodule
}