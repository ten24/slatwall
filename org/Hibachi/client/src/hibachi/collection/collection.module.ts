/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {CollectionConfig} from "./services/collectionconfigservice";
import {CollectionService} from "./services/collectionservice";
import {CollectionController} from "./controllers/collections";
var collectionmodule = angular.module('hibachi.collection',[]).config(()=>{
})
//controllers
.controller('collections',CollectionController)
//services
.factory('collectionConfigService', ['$slatwall','utilityService', ($slatwall: any,utilityService) => new CollectionConfig($slatwall,utilityService)])
.service('collectionService', CollectionService)
//filters 
;  
export{
	collectionmodule
}