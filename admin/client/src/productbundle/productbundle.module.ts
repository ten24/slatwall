/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services
import {ProductBundleService} from "./services/productbundleservice";
//controllers
import {CreateBundleController} from "./controllers/create-bundle-controller";
//directives
import {SWProductBundleGroupType} from "./components/swproductbundlegrouptype";
import {SWProductBundleGroups} from "./components/swproductbundlegroups";
import {SWProductBundleGroup} from "./components/swproductbundlegroup";
import {SWProductBundleCollectionFilterItemTypeahead} from "./components/swproductbundlecollectionfilteritemtypeahead";
//filters


var productbundlemodule = angular.module('hibachi.productbundle',[coremodule.name]).config(()=>{
})
//constants
.constant('productBundlePartialsPath','productbundle/components/')
//services
.service('productBundleService',ProductBundleService)
//controllers
.controller('create-bundle-controller',CreateBundleController)
//directives
.directive('swProductBundleGroupType',SWProductBundleGroupType.Factory())
.directive('swProductBundleGroups',SWProductBundleGroups.Factory())
.directive('swProductBundleGroup',SWProductBundleGroup.Factory())
.directive('swProductBundleCollectionFilterItemTypeahead',SWProductBundleCollectionFilterItemTypeahead.Factory())
//filters

;
export{
	productbundlemodule
}