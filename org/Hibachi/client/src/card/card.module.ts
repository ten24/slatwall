/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules

//services

//components
import {SWCardView} from "./components/swcardview";
import {SWCardHeader} from "./components/swcardheader";
import {SWCardBody} from "./components/swcardbody";
import {SWCardIcon} from "./components/swcardicon";
import {SWCardProgressBar} from "./components/swcardprogressbar";
import {SWCardListItem} from "./components/swcardlistitem";
var cardmodule = angular.module('hibachi.card',[])
.run([function() {
}])

//components
.component('swCardView', SWCardView.Factory())
.component('swCardHeader', SWCardHeader.Factory())
.component('swCardBody', SWCardBody.Factory())
.component('swCardIcon', SWCardIcon.Factory())
.component('swCardProgressBar', SWCardProgressBar.Factory())
.component('swCardListItem', SWCardListItem.Factory())
export{
	cardmodule
}