/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceQuantityEditController{
    
    public skuPriceId:string;
    public skuPrice:any; 
    public skuSkuId:any;
    public column:any; 
    public columnPropertyIdentifier:string; 
    public currencyCode:any;
    public filterOnCurrencyCode:string;
    public minQuantity:string; 
    public maxQuantity:string; 
    public skuPrices; 
    public relatedSkuPriceCollectionConfig;
    
    
    //@ngInject
    constructor(
        private $hibachi,
        private collectionConfigService
    ){
        
        if(angular.isUndefined(this.skuPrice)){
            var skuPriceData = {
                skuPriceID:this.skuPriceId, 
                minQuantity:this.minQuantity, 
                maxQuantity:this.maxQuantity,
                currencyCode:this.currencyCode
            }
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice",skuPriceData);
        }

        this.relatedSkuPriceCollectionConfig = this.collectionConfigService.newCollectionConfig("SkuPrice"); 
        this.relatedSkuPriceCollectionConfig.addDisplayProperty("skuPriceID,sku.skuID,minQuantity,maxQuantity,currencyCode,price");
        this.relatedSkuPriceCollectionConfig.addFilter("minQuantity",this.minQuantity,"=");
        this.relatedSkuPriceCollectionConfig.addFilter("maxQuantity",this.maxQuantity,"=");
        this.relatedSkuPriceCollectionConfig.addFilter("currencyCode",this.currencyCode,"!=");
        this.relatedSkuPriceCollectionConfig.addFilter("sku.skuID",this.skuSkuId,"=")
        this.relatedSkuPriceCollectionConfig.setAllRecords(true);
        this.relatedSkuPriceCollectionConfig.getEntity().then(
            (response)=>{
                angular.forEach(response.records, (value,key)=>{
                    this.skuPrices.push(this.$hibachi.populateEntity("SkuPrice", value));
                });  
            },
            (reason)=>{
            }
        );
    }    

     

}

class SWSkuPriceQuantityEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuPrice:"=?",
        skuPriceId:"@",
        currencyCode:"@",
        skuSkuId:"@",
        column:"=?",
        columnPropertyIdentifier:"@",
        minQuantity:"@",
        maxQuantity:"@"
    };
    public controller = SWSkuPriceQuantityEditController;
    public controllerAs="swSkuPriceQuantityEdit";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPriceQuantityEdit(
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
		skuPartialsPath,
	    slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupricequantityedit.html";
    }
}
export{
    SWSkuPriceQuantityEdit,
    SWSkuPriceQuantityEditController
}
