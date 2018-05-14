/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
import {CoreModule} from "../../../../org/Hibachi/client/src/core/core.module";
//controllers
//directives
import {SWAddOptionGroup} from "./components/swaddoptiongroup";
import {SWOptionsForOptionGroup} from "./components/swoptionsforoptiongroup";
//models
import {optionWithGroup} from "./components/swaddoptiongroup";

@NgModule({
    declarations :[],
    providers: [],
    imports : [
        CoreModule
    ]
})
export class OptionGroupModule{
    constructor() {
        
    }    
}


var optiongroupmodule = angular.module('optiongroup',[coremodule.name])
.config([()=>{

}]).run([()=>{

}])
//constants
.constant('optionGroupPartialsPath','optiongroup/components/')
//controllers
//directives
.directive('swAddOptionGroup', SWAddOptionGroup.Factory())
.directive('swOptionsForOptionGroup', SWOptionsForOptionGroup.Factory())
;
export{
	optiongroupmodule
};