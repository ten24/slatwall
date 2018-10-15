/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />

//modules
import {coremodule} from '../core/core.module';
import {CoreModule} from '../core/core.module';

import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import { UpgradeModule, downgradeInjectable, downgradeComponent } from '@angular/upgrade/static';
import { FormsModule } from '@angular/forms';

//services
import {PaginationService} from "./services/paginationservice";
import {SWPaginationBar,SwPaginationBar} from "./components/swpaginationbar";

@NgModule({
    declarations: [
        SwPaginationBar
    ],
    providers: [
        PaginationService
    ],  
    imports: [
        CoreModule,
        CommonModule,
        FormsModule,
        UpgradeModule
    ],
    entryComponents: [
        SwPaginationBar
    ]  
})

export class PaginationModule{
    
}

var paginationmodule = angular.module('hibachi.pagination', [coremodule.name])
// .config(['$provide','baseURL',($provide,baseURL)=>{
// 	$provide.constant('paginationPartials', baseURL+basePartialsPath+'pagination/components/');
// }])
.run([()=> {
}])
//services
.service('paginationService', downgradeInjectable(PaginationService))
//.directive('swPaginationBar', SWPaginationBar.Factory())
.directive('swPaginationBar', downgradeComponent({ component: SwPaginationBar }) as angular.IDirectiveFactory)
//constants
.constant('partialsPath','pagination/components/')
;

export{
	paginationmodule
}
