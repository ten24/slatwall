/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
import alertmodule = require('./alert/alert.module');
import coremodule = require('./core/core.module');
import paginationmodule = require('./pagination/pagination.module');

export = angular.module('hibachi',[
    alertmodule.name,
    coremodule.name,
    paginationmodule.name
]).config(()=>{
    console.log('moduleloaded');    
})
//.controller('appcontroller',controller.ProductCreateController);