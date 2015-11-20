/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../core/core.module";
//services
import {ProductBundleService} from "./services/productbundleservice";

//directives
import {SWProductBundleGroupType} from "./components/swproductbundlegrouptype";
import {SWProductBundleGroups} from "./components/swproductbundlegroups";
import {SWProductBundleGroup} from "./components/swproductbundlegroup";
//filters


var productbundlemodule = angular.module('hibachi.productbundle',[coremodule.name]).config(()=>{
})
//services
.service('productBundleService',ProductBundleService)
//directives
.directive('swProductBundleGroupType',SWProductBundleGroupType.Factory())
.directive('swProductBundleGrups',SWProductBundleGroups.Factory())
.directive('swProductBundleGroup',SWProductBundleGroup.Factory())
//filters 

;  
export{
	productbundlemodule
}