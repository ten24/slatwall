/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules
import {coremodule} from '../core/core.module';
import {CoreModule} from "../core/core.module";

import { NgModule } from '@angular/core';
import { CommonModule } from '@angular/common';
import { UpgradeModule,downgradeInjectable } from '@angular/upgrade/static';

//services

//components
import {SWCardLayout} from "./components/swcardlayout";
import {SWCardView} from "./components/swcardview";
import {SWCardHeader} from "./components/swcardheader";
import {SWCardBody} from "./components/swcardbody";
import {SWCardIcon} from "./components/swcardicon";
import {SWCardProgressBar} from "./components/swcardprogressbar";
import {SWCardListItem} from "./components/swcardlistitem";

@NgModule({
    declarations :[],
    providers :[],
    imports :[
        CoreModule,
        CommonModule,
        UpgradeModule
    ]
})
export class CardModule {
    constructor() {
        
    }    
}


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