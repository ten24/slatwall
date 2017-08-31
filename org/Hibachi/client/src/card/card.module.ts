/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules
import {coremodule} from '../core/core.module';
//services

//components
import {SWCardLayout} from "./components/swcardlayout";
import {SWCardView} from "./components/swcardview";
import {SWCardHeader} from "./components/swcardheader";
import {SWCardBody} from "./components/swcardbody";
import {SWCardIcon} from "./components/swcardicon";
import {SWCardProgressBar} from "./components/swcardprogressbar";
import {SWCardListItem} from "./components/swcardlistitem";
var cardmodule = angular.module('hibachi.card',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('cardPartialsPath','card/components/')

//components
.directive('swCardLayout', SWCardLayout.Factory())
.directive('swCardView', SWCardView.Factory())
.directive('swCardHeader', SWCardHeader.Factory())
.directive('swCardBody', SWCardBody.Factory())
.directive('swCardIcon', SWCardIcon.Factory())
.directive('swCardProgressBar', SWCardProgressBar.Factory())
.directive('swCardListItem', SWCardListItem.Factory())
export{
	cardmodule
}