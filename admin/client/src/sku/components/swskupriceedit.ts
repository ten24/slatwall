/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceEditController{
    
    public skuId;
    public skuPriceId;
    public skuCode;
    public price; 
    public currencyCode;
    public bundledSkuSkuId; 
    public bundledSkuCurrencyCode;
   
    public sku; 
    public skuPrice;
    
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private collectionConfigService,
        private $hibachi
    ){
        if(angular.isUndefined(this.skuId) && angular.isDefined(this.bundledSkuSkuId)){
            this.skuId = this.bundledSkuSkuId;
        }
        if(angular.isUndefined(this.currencyCode) && angular.isDefined(this.bundledSkuCurrencyCode)){
            this.currencyCode = this.bundledSkuCurrencyCode;
        }
        if(angular.isUndefined(this.skuId) 
            && angular.isUndefined(this.sku)
            && angular.isUndefined(this.skuPriceId)
            && angular.isUndefined(this.skuPrice)
        ){
            throw("You must provide either a skuID or a skuPriceID or a sku or a skuPrice to SWSkuPriceSingleEditController");
        } else {
            
            if(angular.isDefined(this.skuId)){
                var skuData = {
                    skuID:this.skuId,
                    skuCode:this.skuCode,
                    currencyCode:this.currencyCode,
                    price:this.price 
                }
                this.sku = this.$hibachi.populateEntity("Sku", skuData); 
                console.log("price sku", this.sku, skuData);
            }


            if(angular.isDefined(this.skuPriceId) && angular.isUndefined(this.skuPrice)){
                this.$hibachi.getEntity("SkuPrice", this.skuPriceId).then(
                        (skuPrice)=>{
                            if(angular.isDefined(skuPrice)){
                                this.skuPrice = this.$hibachi.newEntity('Sku');
                                angular.extend(this.skuPrice.data, skuPrice);
                            } else { 
                                throw("There was a problem fetching the sku in SWSkuPriceSingleEditController");
                            }
                        },
                        (reason)=>{
                            throw("SWSkuPriceEdit had trouble fetchin its sku because" + reason);
                        }
                ); 
            }
        }
    }    

}

class SWSkuPriceEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        skuPriceId:"@",
        skuCode:"@",
        price:"@",
        bundledSkuSkuId:"@",
        bundledSkuCurrencyCode:"@",        
        currencyCode:"@",
        sku:"=?",
        skuPrice:"=?"
    };
    public controller = SWSkuPriceEditController;
    public controllerAs="swSkuPriceEdit";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPriceEdit(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupriceedit.html";
    }
}
export{
    SWSkuPriceEdit,
    SWSkuPriceEditController
}
