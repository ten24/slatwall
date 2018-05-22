/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
import {CoreModule} from "../../../../org/Hibachi/client/src/core/core.module";

import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

//controllers
//directives
import {SWFormResponseListing} from "./components/swformresponselisting"
//models


@NgModule({
    declarations : [],
    providers :[],
    imports :[
        CoreModule,
        CommonModule,
        UpgradeModule
    ]
})
export class FormBuilderModule {
    constructor() {
        
    }    
}

var formbuildermodule = angular.module('formbuilder',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('formBuilderPartialsPath','formbuilder/components/')
//controllers
//directives
.directive('swFormResponseListing',SWFormResponseListing.Factory())
;
export{
	formbuildermodule
};