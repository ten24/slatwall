/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var swPricingManagerHTML = require("html-loader!sku/components/pricingmanager");

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
        this.skuPriceCollectionConfig.setDisplayProperties("sku.skuCode,sku.calculatedSkuDefinition,minQuantity,maxQuantity,priceGroup.priceGroupCode,currencyCode");
        this.skuPriceCollectionConfig.addDisplayProperty("price", "" ,{isEditable:true});
        this.skuPriceCollectionConfig.addDisplayProperty("skuPriceID", "", {isVisible:false});
        this.skuPriceCollectionConfig.addDisplayProperty("sku.skuID", "", {isVisible:false});
        this.skuPriceCollectionConfig.addDisplayProperty("priceGroup.priceGroupID", "", {isVisible:false});
        this.skuPriceCollectionConfig.addFilter("sku.product.productID", this.productId, "=", "AND", true);
        this.skuPriceCollectionConfig.setOrderBy('sku.skuCode|ASC,minQuantity|ASC,priceGroup.priceGroupCode|ASC,currencyCode|ASC');
        
        // let editableColumns = "minQuantity,maxQuantity,price";
        
        // for(var i=0; i<this.skuPriceCollectionConfig.columns.length; i++){
        //     let indexOf = editableColumns.indexOf(this.skuPriceCollectionConfig.columns[i].propertyIdentifier.replace("_skuprice.", ""))
        //     if(indexOf > -1){
        //         this.skuPriceCollectionConfig.columns[i].hasCellView = "true";
                
        //         if(this.skuPriceCollectionConfig.columns[i].propertyIdentifier == "_skuprice.price"){
        //             this.skuPriceCollectionConfig.columns[i].cellView = "swSkuPricesEdit";
        //         }else if(this.skuPriceCollectionConfig.columns[i].propertyIdentifier == "_skuprice.minQuantity"
        //                 || this.skuPriceCollectionConfig.columns[i].propertyIdentifier == "_skuprice.maxQuantity"){
        //             let columnName = this.skuPriceCollectionConfig.columns[i].propertyIdentifier.replace("_skuprice.", "");
        //             columnName = columnName.slice(3);
        //             this.skuPriceCollectionConfig.columns[i].cellView = "swSkuPrice" + columnName + "Edit";
        //         }
        //     }
        // }
        
    }
}

class SWPricingManager implements ng.IDirective{
    public template;
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
    
    // @ngInject
    constructor(
        public $hibachi, 
		public skuPartialsPath,
	    public slatwallPathBuilder
    ){
        this.template = swPricingManagerHTML;
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }
}
export{
    SWPricingManager,
    SWPricingManagerController
}
