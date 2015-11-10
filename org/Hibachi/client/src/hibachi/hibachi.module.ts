/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
import alertmodule = require('./alert/alert.module');
import coremodule = require('./core/core.module');

export = angular.module('hibachi',[alertmodule.name,coremodule.name]).config(()=>{
    console.log('moduleloaded');    
})
//.controller('appcontroller',controller.ProductCreateController);