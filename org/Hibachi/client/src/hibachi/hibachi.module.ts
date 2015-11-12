/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//import alertmodule = require('./alert/alert.module');
import {alertmodule} from "./alert/alert.module";
import {coremodule} from "./core/core.module";
import {paginationmodule} from "./pagination/pagination.module";
import {dialogmodule} from "./dialog/dialog.module";
import {collectionmodule} from "./collection/collection.module";

var hibachimodule = angular.module('hibachi',[
    alertmodule.name,
    coremodule.name,
    paginationmodule.name,
    dialogmodule.name,
    collectionmodule.name
]).config(()=>{
})

export{
    hibachimodule  
};
//.controller('appcontroller',controller.ProductCreateController);