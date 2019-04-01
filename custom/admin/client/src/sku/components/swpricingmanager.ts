import {SWPricingManagerController as PricingManagerController} from "../../../../../../admin/client/src/sku/components/swpricingmanager";
import {SWPricingManager as PricingManager} from "../../../../../../admin/client/src/sku/components/swpricingmanager";

class SWPricingManagerController extends PricingManagerController{
    
    constructor(public collectionConfigService){
        super(collectionConfigService);
        
        if(this.skuPriceCollectionConfig){
            this.skuPriceCollectionConfig.setDisplayProperties(
                "sku.skuCode,"+
                "sku.calculatedSkuDefinition,"+
                "minQuantity,"+
                "maxQuantity,"+
                "price,"+
                "priceGroup.priceGroupCode,"+
                "personalVolume,"+
                "taxableAmount,"+
                "commissionableVolume,"+
                "sponsorVolume,"+
                "productPackVolume,"+
                "retailValueVolume,"+
                "handlingFee"
            );
        }
    }
}

class SWPricingManager extends PricingManager{
    
    public controller = SWPricingManagerController;
    
    public static Factory(){
        var directive = (
            $hibachi, 
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWPricingManager(
            $hibachi, 
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    constructor(
        public $hibachi, 
		public skuPartialsPath,
	    public slatwallPathBuilder
    ){
        super(
            $hibachi,
            skuPartialsPath,
            slatwallPathBuilder
        );
        
    }
}

export{
    SWPricingManagerController,
    SWPricingManager
}