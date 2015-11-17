/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
//services
import {DialogService} from "./services/dialogservice";

var dialogmodule = angular.module('hibachi.dialog',[]).config(()=>{
})
//services
.service('dialogService', DialogService)
//filters 
//constants
.constant('dialogPartials','dialog/components/')
;  
export{
	dialogmodule
}