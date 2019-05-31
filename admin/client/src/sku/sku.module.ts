/// <reference path='../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../typings/tsd.d.ts' />

//modules
import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
//services
import {DefaultSkuService} from "./services/defaultskuservice";
import {SkuPriceService} from "./services/skupriceservice";
//controllers

//directives
import {SWPricingManager} from "sku/components/swpricingmanager";
import {SWImageDetailModalLauncher} from "./components/swimagedetailmodallauncher";
import {SWAddSkuPriceModalLauncher} from "sku/components/swaddskupricemodallauncher";
import {SWDeleteSkuPriceModalLauncher} from "./components/swdeleteskupricemodallauncher";
import {SWEditSkuPriceModalLauncher} from "sku/components/sweditskupricemodallauncher";
import {SWSkuPriceModal} from "sku/components/swskupricemodal";
import {SWSkuStockAdjustmentModalLauncher} from "./components/swskustockadjustmentmodallauncher";
import {SWDefaultSkuRadio} from "./components/swdefaultskuradio"; 
import {SWSkuImage} from "./components/swskuimage";
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
.directive('swEditSkuPriceModalLauncher', SWEditSkuPriceModalLauncher.Factory())
.directive('swSkuPriceModal', SWSkuPriceModal.Factory())
.directive('swSkuStockAdjustmentModalLauncher', SWSkuStockAdjustmentModalLauncher.Factory())
.directive('swDefaultSkuRadio', SWDefaultSkuRadio.Factory())
.directive('swSkuCurrencySelector', SWSkuCurrencySelector.Factory())
.directive('swSkuPriceEdit', SWSkuPriceEdit.Factory())
.directive('swSkuCodeEdit', SWSkuCodeEdit.Factory())
.directive('swSkuImage', SWSkuImage.Factory())
.directive('swSkuPricesEdit', SWSkuPricesEdit.Factory())
.directive('swSkuPriceQuantityEdit', SWSkuPriceQuantityEdit.Factory())
.directive('swSkuThumbnail', SWSkuThumbnail.Factory())
//filters

;
export{
	skumodule
}