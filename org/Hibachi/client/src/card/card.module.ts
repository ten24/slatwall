/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules

//services

//components
import {SWCardView} from "./components/swcardview";
import {SWCardHeader} from "./components/swcardheader";
import {SWCardBody} from "./components/swcardbody";

var cardmodule = angular.module('hibachi.card',[])
.run([function() {
}])

//components
.component('swTextCardView', SWCardView.Factory())
.component('swCardBody', SWCardBody.Factory())
.component('swCardHeader', SWCardHeader.Factory());
export{
	cardmodule
}