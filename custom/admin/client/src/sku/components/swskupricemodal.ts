import {SWSkuPriceModal as SkuPriceModal} from "../../../../../../admin/client/src/sku/components/swskupricemodal";
import {SWSkuPriceModalController as SkuPriceModalController} from "../../../../../../admin/client/src/sku/components/swskupricemodal";

class SWSkuPriceModalController extends SkuPriceModalController{
    //@ngInject
    constructor(
        public $hibachi,
        public entityService,
        public formService,
        public listingService,
        public observerService, 
        public skuPriceService,
        public utilityService,
        public collectionConfigService,
        public scopeService,
        public $scope,
        public $timeout,
        public requestService
    ){
        super(  
            $hibachi,
            entityService,
            formService,
            listingService,
            observerService, 
            skuPriceService,
            utilityService,
            collectionConfigService,
            scopeService,
            $scope,
            $timeout,
            requestService
        );
        this.observerService.detachByEvent('EDIT_SKUPRICE'); // Detach core event
        this.observerService.attach(this.initData, "EDIT_SKUPRICE"); // Attach custom event
    }
    
    public initData = (pageRecord?:any) =>{
        super.initData(pageRecord);
        
        if(angular.isDefined(this.pageRecord) && angular.isDefined(this.pageRecord.skuPriceID) && this.pageRecord.skuPriceID.length){
            this.skuPrice.personalVolume = this.pageRecord.personalVolume;
            this.skuPrice.taxableAmount = this.pageRecord.taxableAmount;
            this.skuPrice.commissionableVolume = this.pageRecord.commissionableVolume;
            this.skuPrice.retailCommission = this.pageRecord.retailCommission;
            this.skuPrice.productPackVolume = this.pageRecord.productPackVolume;
            this.skuPrice.retailValueVolume = this.pageRecord.retailValueVolume;
            this.skuPrice.handlingFee = this.pageRecord.handlingFee;
            this.skuPrice.activeFlag = this.pageRecord.activeFlag;
        }
    }
    
    public $onDestroy = ()=>{
		this.observerService.detachByEvent('EDIT_SKUPRICE');
	}
    
}

class SWSkuPriceModal extends SkuPriceModal implements ng.IDirective{
    public template = require('./skupricemodal.html');
    public controller = SWSkuPriceModalController;
}

export{
    SWSkuPriceModal,
    SWSkuPriceModalController
}
