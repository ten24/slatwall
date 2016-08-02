/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services

//filters

//directives
import {SWContentBasic} from "./components/swcontentbasic";
import {SWContentEditor} from "./components/swcontenteditor";
import {SWContentList} from "./components/swcontentlist";
import {SWContentNode} from "./components/swcontentnode";
import {SWAssignedProducts} from "./components/swassignedproducts";
import {SWSiteSelector} from "./components/swsiteselector";

var contentmodule = angular.module('hibachi.content',[coremodule.name]).config(()=>{

})
.constant('contentPartialsPath','content/components/')
//services

//filters

//directives
.directive('swContentBasic',SWContentBasic.Factory())
.directive('swContentEditor',SWContentEditor.Factory())
.directive('swContentList',SWContentList.Factory())
.directive('swContentNode',SWContentNode.Factory())
.directive('swAssignedProducts', SWAssignedProducts.Factory())
.directive('swSiteSelector', SWSiteSelector.Factory())
;
export{
	contentmodule
}