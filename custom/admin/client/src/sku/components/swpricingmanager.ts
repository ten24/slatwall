import {SWPricingManagerController as PricingManagerController} from "../../../../../../admin/client/src/sku/components/swpricingmanager";
import {SWPricingManager as PricingManager} from "../../../../../../admin/client/src/sku/components/swpricingmanager";

class SWPricingManagerController extends PricingManagerController{
    
    constructor(public collectionConfigService){
        super(collectionConfigService);
        
        if(this.skuPriceCollectionConfig){
            
            this.skuPriceCollectionConfig.addDisplayProperty("personalVolume", "" ,{isEditable:true});
            this.skuPriceCollectionConfig.addDisplayProperty("taxableAmount", "" ,{isEditable:true});
            this.skuPriceCollectionConfig.addDisplayProperty("commissionableVolume", "" ,{isEditable:true});
            this.skuPriceCollectionConfig.addDisplayProperty("retailCommission", "" ,{isEditable:true});
            this.skuPriceCollectionConfig.addDisplayProperty("productPackVolume", "" ,{isEditable:true});
            this.skuPriceCollectionConfig.addDisplayProperty("retailValueVolume", "" ,{isEditable:true});
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