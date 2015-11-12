/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {AlertService} from "./service/alertService";
var alertmodule = angular.module('hibachi.alert',[])
.service('alertService',AlertService); 
export{
	alertmodule
};
