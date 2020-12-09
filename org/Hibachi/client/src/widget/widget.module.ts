/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules
import {collectionmodule} from "../collection/collection.module";

//directives
import {SWStatWidget} from "./components/swstatwidget";
import {SWChartWidget} from "./components/swchartwidget";
import {SWReportConfigurationBar} from "./components/swreportconfigurationbar";



var widgetmodule = angular.module('hibachi.widget', [collectionmodule.name])
.run([function() {
}])

//directives
.directive('swStatWidget',SWStatWidget.Factory())
.directive('swChartWidget',SWChartWidget.Factory())
.directive('swReportConfigurationBar',SWReportConfigurationBar.Factory())

//constants
.constant('widgetPartialPath','widget/components/')
;

export{
	widgetmodule
}