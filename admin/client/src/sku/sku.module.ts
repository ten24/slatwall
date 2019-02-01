/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services
import {DefaultSkuService} from "./services/defaultskuservice";
import {SkuPriceService} from "./services/skupriceservice";
//controllers

//directives
import {SWPricingManager} from "./components/swpricingmanager";
import {SWImageDetailModalLauncher} from "./components/swimagedetailmodallauncher";
import {SWAddSkuPriceModalLauncher} from "./components/swaddskupricemodallauncher";
import {SWDeleteSkuPriceModalLauncher} from "./components/swdeleteskupricemodallauncher";
import {SWSkuStockAdjustmentModalLauncher} from "./components/swskustockadjustmentmodallauncher";
import {SWDefaultSkuRadio} from "./components/swdefaultskuradio"; 
import {SWSkuCurrencySelector} from "./components/swskucurrencyselector";
import {SWSkuPriceEdit} from "./components/swskupriceedit";
import {SWSkuCodeEdit} from "./components/swskucodeedit"; 
import {SWSkuPricesEdit} from "./components/swskupricesedit";
import {SWSkuPriceQuantityEdit} from "./components/swskupricequantityedit";
import {SWSkuThumbnail} from "./components/swskuthumbnail";
//filters


var skumodule = angular.module('hibachi.sku',[coremodule.name]).config(()=>{
})
//constants
.constant('skuPartialsPath','sku/components/')
//services
.service('defaultSkuService', DefaultSkuService)
.service('skuPriceService',SkuPriceService)
//controllers

//directives
.directive('swPricingManager', SWPricingManager.Factory())
.directive('swImageDetailModalLauncher', SWImageDetailModalLauncher.Factory())
.directive('swAddSkuPriceModalLauncher', SWAddSkuPriceModalLauncher.Factory()) 
.directive('swDeleteSkuPriceModalLauncher', SWDeleteSkuPriceModalLauncher.Factory())
.directive('swSkuStockAdjustmentModalLauncher', SWSkuStockAdjustmentModalLauncher.Factory())
.directive('swDefaultSkuRadio', SWDefaultSkuRadio.Factory())
.directive('swSkuCurrencySelector', SWSkuCurrencySelector.Factory())
.directive('swSkuPriceEdit', SWSkuPriceEdit.Factory())
.directive('swSkuCodeEdit', SWSkuCodeEdit.Factory())
.directive('swSkuPricesEdit', SWSkuPricesEdit.Factory())
.directive('swSkuPriceQuantityEdit', SWSkuPriceQuantityEdit.Factory())
.directive('swSkuThumbnail', SWSkuThumbnail.Factory())
//filters

;
export{
	skumodule
}