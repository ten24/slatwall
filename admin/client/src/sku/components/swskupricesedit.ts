/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPricesEditController{
    
    public Id:string; 
    public skuId:string;
    public skuSkuId:string;
    public skuPriceId:string;
    public minQuantity:string;
    public maxQuantity:string; 
    public price:string; 
    public filterOnCurrencyCode:string; 
    public baseEntityId:string; 
    public baseEntityName:string="Product";
    public currencyCode:string;
    public bundledSkuSkuId:string; 
    public selectCurrencyCodeEventName:string;
    public showPriceEdit:boolean; 
    public relatedSkuPriceCollectionConfig:any; 

    public sku; 
    public skuPrices;
    
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private observerService,
        private collectionConfigService,
        private utilityService, 
        private $hibachi
    ){
        this.Id = this.utilityService.createID(32);
        if(angular.isUndefined(this.skuPrices)){
            this.skuPrices = []; 
        }
        if(angular.isDefined(this.skuPriceId)){
            var skuPriceData = {
                skuPriceID:this.skuPriceId, 
                minQuantity:this.minQuantity,
                maxQuantity:this.maxQuantity, 
                currencyCode:this.currencyCode,
                price:this.price
            }
            this.skuPrices.push(this.$hibachi.populateEntity("SkuPrice",skuPriceData));
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
        if(angular.isDefined(this.skuId)){
            var skuData = {
                skuID:this.skuId,
                currencyCode:this.currencyCode,
                price:this.price
            }
            this.sku = this.$hibachi.populateEntity("Sku",skuData);
        }  
    }    
}

class SWSkuPricesEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        skuSkuId:"@",
        skuPriceId:"@",
        minQuantity:"@",
        maxQuantity:"@",
        currencyCode:"@",
        price:"@",
        bundledSkuSkuId:"@",
        baseEntityName:"@?",
        baseEntityId:"@?",
        sku:"=?"
    };
    public controller = SWSkuPricesEditController;
    public controllerAs="swSkuPricesEdit";
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPricesEdit(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupricesedit.html";
    }
}
export{
    SWSkuPricesEdit,
    SWSkuPricesEditController
}
