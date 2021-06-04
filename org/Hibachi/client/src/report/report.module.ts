/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules
import {collectionmodule} from "../collection/collection.module";

//directives
import {SWReportMenu} from "./components/swreportmenu";



var reportmodule = angular.module('hibachi.report', [collectionmodule.name])
.run([function() {
}])

//directives
.directive('swReportMenu',SWReportMenu.Factory())

//constants
.constant('reportPartialPath','report/components/')
;

export{
	reportmodule
}