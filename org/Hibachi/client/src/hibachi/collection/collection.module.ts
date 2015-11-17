/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//modules
import {coremodule} from '../core/core.module';
//services

import {CollectionConfig} from "./services/collectionconfigservice";
import {CollectionService} from "./services/collectionservice";
import {CollectionController} from "./controllers/collections";
//directives
import {SWCollection} from "./components/swcollection";
import {SWAddFilterButtons} from "./components/swaddfilterbuttons";
import {SWDisplayOptions} from "./components/swdisplayoptions";
import {SWDisplayItem} from "./components/swdisplayitem";



var collectionmodule = angular.module('hibachi.collection',[coremodule.name]).config([()=>{
	
}])
//controllers
.controller('collections',CollectionController)
//services
.factory('collectionConfigService', ['$slatwall','utilityService', ($slatwall: any,utilityService) => new CollectionConfig($slatwall,utilityService)])
.service('collectionService', CollectionService)
//directives
.directive('swCollection',SWCollection.Factory())
.directive('swAddFilterButtons',SWAddFilterButtons.Factory())
.directive('swDisplayOptions',SWDisplayOptions.Factory())
.directive('swDisplayItem',SWDisplayItem.Factory())
//filters  
//constants
.constant('collectionPartialsPath','collection/components/')
;  
export{
	collectionmodule
}