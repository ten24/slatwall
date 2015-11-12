/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//import alertmodule = require('./alert/alert.module');
import {alertmodule} from "./alert/alert.module";
import {coremodule} from "./core/core.module";
import {paginationmodule} from "./pagination/pagination.module";
import {dialogmodule} from "./dialog/dialog.module";

var hibachimodule = angular.module('hibachi',[
    alertmodule.name,
    coremodule.name,
    paginationmodule.name,
    dialogmodule.name
]).config(()=>{
})

export{
    hibachimodule  
};
//.controller('appcontroller',controller.ProductCreateController);