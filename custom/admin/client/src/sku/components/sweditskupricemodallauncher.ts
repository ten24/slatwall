import {SWEditSkuPriceModalLauncher as EditSkuPriceModalLauncher} from "../../../../../../admin/client/src/sku/components/sweditskupricemodallauncher";
import {SWEditSkuPriceModalLauncherController as EditSkuPriceModalLauncherController} from "../../../../../../admin/client/src/sku/components/sweditskupricemodallauncher";

class SWEditSkuPriceModalLauncherController extends EditSkuPriceModalLauncherController{
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
            } else {
                return;
            }
        } else{ 
            throw("swEditSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
        } 
    }
    
}

class SWEditSkuPriceModalLauncher extends EditSkuPriceModalLauncher{
    public controller = SWEditSkuPriceModalLauncherController;
}

export{
    SWEditSkuPriceModalLauncher,
    SWEditSkuPriceModalLauncherController
}
