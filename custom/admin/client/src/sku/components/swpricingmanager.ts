import {SWPricingManagerController as PricingManagerController} from "../../../../../../admin/client/src/sku/components/swpricingmanager";
import {SWPricingManager as PricingManager} from "../../../../../../admin/client/src/sku/components/swpricingmanager";

class SWPricingManagerController extends PricingManagerController{
    
    constructor(public collectionConfigService){
        super(collectionConfigService);
        
        if(this.skuPriceCollectionConfig){
            
            this.skuPriceCollectionConfig.addDisplayProperty("personalVolume");
            this.skuPriceCollectionConfig.addDisplayProperty("taxableAmount");
            this.skuPriceCollectionConfig.addDisplayProperty("commissionableVolume");
            this.skuPriceCollectionConfig.addDisplayProperty("retailCommission");
            this.skuPriceCollectionConfig.addDisplayProperty("productPackVolume");
            this.skuPriceCollectionConfig.addDisplayProperty("retailValueVolume");
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