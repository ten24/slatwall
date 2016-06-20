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

    public sku:any; 
    public skuPrice:any;
    public skuPrices:any;
    
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private observerService,
        private collectionConfigService,
        private utilityService, 
        private skuPriceService, 
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
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice",skuPriceData);
            this.skuPriceService.setSkuPrices(this.skuSkuId,[this.skuPrice]);
            this.relatedSkuPriceCollectionConfig = this.skuPriceService.getRelatedSkuPriceCollectionConfig(this.skuSkuId, this.currencyCode, this.minQuantity, this.maxQuantity);
            this.refreshSkuPrices(); 
            this.observerService.attach(this.refreshSkuPrices, "skuPricesUpdate");
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

    public refreshSkuPrices = () => {
         this.skuPriceService.loadSkuPricesForSku().finally(()=>{
            this.skuPrices = this.getSkuPrices(); 
         });
    }

    public hasSkuPrices = () =>{
        return this.skuPriceService.hasSkuPrices(this.skuSkuId);
    }

    public getSkuPrices = () =>{
        return this.skuPriceService.getSkuPricesForQuantityRange(this.skuSkuId,this.minQuantity,this.maxQuantity);
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
