/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//import alertmodule = require('./alert/alert.module');
import {alertmodule} from "./alert/alert.module";
import {coremodule} from "./core/core.module";
import {paginationmodule} from "./pagination/pagination.module";
import {dialogmodule} from "./dialog/dialog.module";
import {collectionmodule} from "./collection/collection.module";
import {workflowmodule} from "./workflow/workflow.module";
import {productbundlemodule} from "./productbundle/productbundle.module";
import {productmodule} from "./product/product.module";

var hibachimodule = angular.module('hibachi',[
    alertmodule.name,
    coremodule.name,
    paginationmodule.name,
    dialogmodule.name,
    collectionmodule.name,
    workflowmodule.name,
    productbundlemodule.name
])

;

export{
    hibachimodule  
};
