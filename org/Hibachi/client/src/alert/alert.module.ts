/// <reference path='../../typings/hibachiTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
import {NgModule, Component} from '@angular/core';
import {BrowserModule} from '@angular/platform-browser';
import {UpgradeModule,downgradeInjectable} from '@angular/upgrade/static';
//controllers
import {AlertController} from "./controllers/alertcontroller";
//services
import {AlertService} from "./service/alertservice";


var alertmodule = angular.module('hibachi.alert',[])
//controllers
.controller('alertController',AlertController)
//services
.factory('alertService',downgradeInjectable(AlertService))
;
export{
	alertmodule
};
