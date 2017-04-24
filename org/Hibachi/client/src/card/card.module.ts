/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules

//services

//components
import {SWTextCardView} from "./components/swtextcardview";

var cardmodule = angular.module('hibachi.card',[])
.run([function() {
}])

//directives
.component('swTextCardView', SWTextCardView.Factory());

export{
	cardmodule
}