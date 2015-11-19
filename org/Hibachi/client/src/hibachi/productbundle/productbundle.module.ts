/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services


//directives
import {SWProductBundleGroupType} from "./components/swproductbundlegrouptype";
import {SWProductBundleGroups} from "./components/swproductbundlegroups";
import {SWProductBundleGroup} from "./components/swproductbundlegroup";
//filters


var productbundlemodule = angular.module('hibachi.productbundle',[]).config(()=>{
})
//services

//directives
.directive('swProductBundleGroupType',SWProductBundleGroupType.Factory())
.directive('swProductBundleGrups',SWProductBundleGroups.Factory())
.directive('swProductBundleGroup',SWProductBundleGroup.Factory())
//filters 

;  
export{
	productbundlemodule
}