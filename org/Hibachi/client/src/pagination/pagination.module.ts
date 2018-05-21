/// <reference path="../../typings/tsd.d.ts" />
/// <reference path="../../typings/hibachiTypescript.d.ts" />
import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

//services
import {PaginationService} from "./services/paginationservice";
import {SWPaginationBar} from "./components/swpaginationbar";
import {coremodule} from '../core/core.module';
import {CoreModule} from '../core/core.module';

@NgModule({
    declarations: [],
    providers: [
        PaginationService
    ],  
    imports: [
        CommonModule,
        UpgradeModule,
        CoreModule
    ]  
})
export class Pagination{
    
}

var paginationmodule = angular.module('hibachi.pagination', [coremodule.name])
// .config(['$provide','baseURL',($provide,baseURL)=>{
// 	$provide.constant('paginationPartials', baseURL+basePartialsPath+'pagination/components/');
// }])
.run([()=> {
}])
//services
.service('paginationService', downgradeInjectable(PaginationService))
.directive('swPaginationBar', SWPaginationBar.Factory())
//constants
.constant('partialsPath','pagination/components/')
;

export{
	paginationmodule
}




