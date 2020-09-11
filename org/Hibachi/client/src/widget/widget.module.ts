/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules
import {collectionmodule} from "../collection/collection.module";

//directives
import {SWStatWidget} from "./components/swstatwidget";



var widgetmodule = angular.module('hibachi.widget', [collectionmodule.name])
.run([function() {
}])

//directives
.directive('swStatWidget',SWStatWidget.Factory())

//constants
.constant('widgetPartialPath','widget/components/')
;

export{
	widgetmodule
}