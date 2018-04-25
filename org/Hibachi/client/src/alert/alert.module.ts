/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
import {NgModule} from '@angular/core';
import { CommonModule } from '@angular/common';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';
//controllers
import {AlertController} from "./controllers/alertcontroller";
//services
import {AlertService} from "./service/alertservice";

@NgModule({
  declarations: [],
  providers: [
    // Register an Angular provider whose value is the "upgraded" AngularJS service
    AlertService
  ],
  // All components that are to be "downgraded" must be declared as `entryComponents`
  // We must import `UpgradeModule` to get access to the AngularJS core services
  imports: [CommonModule, UpgradeModule]
})
export class AlertModule{
    constructor(){
        
    }
}

var alertmodule = angular.module('hibachi.alert',[])
//controllers
.controller('alertController',AlertController)
//services
.service('alertService',downgradeInjectable(AlertService))
;
export{
	alertmodule
};
