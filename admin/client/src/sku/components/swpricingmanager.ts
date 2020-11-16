
class SWPricingManagerController{
    
    public productId;
    public product; 
    public productCollectionConfig;
    public trackInventory; 
    public skuPriceCollectionConfig;
    
    //temporary var
    public singleEditTest; 
    public testScope; 
    
    //@ngInject
    constructor(
        public collectionConfigService
    ){
        this.productCollectionConfig = this.collectionConfigService.newCollectionConfig("Product"); 
        this.productCollectionConfig.addFilter("productID", this.productId, "=",'AND',true);
        this.productCollectionConfig.addDisplayProperty("productID,defaultSku.currencyCode");
        this.productCollectionConfig.getEntity().then(
            (response)=>{
                this.product = response.pageRecords[0]; 
            },
            (reason)=>{

            }
        );
        
        this.skuPriceCollectionConfig = this.collectionConfigService.newCollectionConfig("SkuPrice");
        this.skuPriceCollectionConfig.setDisplayProperties("sku.skuName,sku.skuCode,sku.calculatedSkuDefinition,activeFlag,priceGroup.priceGroupName,currencyCode");
        this.skuPriceCollectionConfig.addDisplayProperty("price", "" ,{isEditable:true});
        this.skuPriceCollectionConfig.addDisplayProperty("listPrice", "" ,{isEditable:true});
        this.skuPriceCollectionConfig.addDisplayProperty("minQuantity", "" ,{isEditable:true});
        this.skuPriceCollectionConfig.addDisplayProperty("maxQuantity", "" ,{isEditable:true});
        this.skuPriceCollectionConfig.addDisplayProperty("skuPriceID", "", {isVisible:false,isSearchable:false});
        this.skuPriceCollectionConfig.addDisplayProperty("sku.skuID", "", {isVisible:false,isSearchable:false});
        this.skuPriceCollectionConfig.addDisplayProperty("sku.imagePath", "", {isVisible:false,isSearchable:false});
        this.skuPriceCollectionConfig.addDisplayProperty("priceGroup.priceGroupID", "", {isVisible:false,isSearchable:false});
        this.skuPriceCollectionConfig.addFilter("sku.product.productID", this.productId, "=", "AND", true);
        this.skuPriceCollectionConfig.setOrderBy('sku.skuCode|ASC,minQuantity|ASC,priceGroup.priceGroupCode|ASC,currencyCode|ASC');
    }
}

class SWPricingManager implements ng.IDirective{
    public template = require("./pricingmanager.html");
    
    public restrict = 'EA';
    public priority = 1000;
    
    public scope = {}; 
    public bindToController = {
        productId:"@",
        trackInventory:"=?"
    };
    
    public controller = SWPricingManagerController;
    public controllerAs="swPricingManager";
   
    public static Factory(){
        return () => new this();
    }
}
export{
    SWPricingManager,
    SWPricingManagerController
}
