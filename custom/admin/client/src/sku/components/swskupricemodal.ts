// var swEditSkuPriceModalLauncherHTML = require("html-loader!sku/components/editskupricemodallauncher");
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
        public scopeService,
        public $scope
    ){
        super(  
            $hibachi,
            entityService,
            formService,
            listingService,
            observerService, 
            skuPriceService,
            utilityService,
            scopeService,
            $scope
        );
        
        this.observerService.attach(this.initData, "EDIT_SKUPRICE");
    }
    
    public initData = (pageRecord?:any) =>{
        if(angular.isDefined(this.pageRecord)){ 
            if(angular.isDefined(this.pageRecord.skuPriceID) && this.pageRecord.skuPriceID.length){
            
                this.skuPrice.personalVolume = this.pageRecord.personalVolume;
                this.skuPrice.taxableAmount = this.pageRecord.taxableAmount;
                this.skuPrice.commissionableVolume = this.pageRecord.commissionableVolume;
                this.skuPrice.retailCommission = this.pageRecord.retailCommission;
                this.skuPrice.productPackVolume = this.pageRecord.productPackVolume;
                this.skuPrice.retailValueVolume = this.pageRecord.retailValueVolume;
                this.skuPrice.handlingFee = this.pageRecord.handlingFee;
            }
        }
    }
    
}

class SWSkuPriceModal extends SkuPriceModal implements ng.IDirective{
    
    public controller = SWSkuPriceModalController;
    
    public static Factory(){
        var directive = (
            $hibachi,
            entityService,
            observerService,
            scopeService,
            collectionConfigService,
            skuPartialsPath,
            slatwallPathBuilder
        )=> new SWSkuPriceModal(
            $hibachi, 
            entityService,
            observerService,
            scopeService,
            collectionConfigService,
            skuPartialsPath,
            slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'entityService',
            'observerService',
            'scopeService',
            'collectionConfigService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    
    constructor(
        public $hibachi, 
        public entityService,
        public observerService,
        public scopeService, 
        public collectionConfigService, 
        public skuPartialsPath,
        public slatwallPathBuilder
    ){
        super(
            $hibachi, 
            entityService,
            observerService,
            scopeService, 
            collectionConfigService, 
            skuPartialsPath,
            slatwallPathBuilder
        );
    }
}

export{
    SWSkuPriceModal,
    SWSkuPriceModalController
}
