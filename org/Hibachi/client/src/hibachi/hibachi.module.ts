/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />
//import alertmodule = require('./alert/alert.module');
import {alertmodule} from "./alert/alert.module";
import {collectionmodule} from "./collection/collection.module";
import {contentmodule} from "./content/content.module";
import {coremodule} from "./core/core.module";
import {dialogmodule} from "./dialog/dialog.module";
import {orderitemmodule} from "./orderitem/orderitem.module";
import {paginationmodule} from "./pagination/pagination.module";
import {productmodule} from "./product/product.module";
import {productbundlemodule} from "./productbundle/productbundle.module";
import {workflowmodule} from "./workflow/workflow.module";

var hibachimodule = angular.module('hibachi',[
    alertmodule.name,
    coremodule.name,
    collectionmodule.name,
    contentmodule.name,
    dialogmodule.name,
    orderitemmodule.name,
    paginationmodule.name,
    productmodule.name,
    productbundlemodule.name,
    workflowmodule.name
])

;

export{
    hibachimodule
};
