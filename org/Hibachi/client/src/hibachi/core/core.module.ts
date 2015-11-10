/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import UtilityService = require('./services/utilityservice');
import SelectionService = require('./services/selectionservice');
import ObserverService = require('./services/observerservice');
//filters
import PercentageFilter = require('./filters/percentage');


export = angular.module('hibachi.core',[]).config(()=>{
})
//services
.service('utilityService',UtilityService)
.service('selectionService',SelectionService)
.service('observerService',ObserverService)  
//filters 
.filter('percentage',[PercentageFilter.Factory])
;  
