/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import AlertService = require('./service/alertService');
export = angular.module('hibachi.alert',[])
.service('alertService',AlertService); 

