/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPricesEditController{
    
    public Id:string; 
    public listingDisplayId:string; 
    public skuId:string;
    public skuSkuId:string;
    public skuPriceId:string;
    public minQuantity:string;
    public maxQuantity:string; 
    public price:string; 
    public eligibleCurrencyCodes; 
    public eligibleCurrencyCodeList:string; 
    public skuEligibleCurrencyCodeList:string; 
    public filterOnCurrencyCode:string; 
    public baseEntityId:string; 
    public baseEntityName:string="Product";
    public currencyCode:string;
    public bundledSkuSkuId:string; 
    public selectCurrencyCodeEventName:string;
    public showPriceEdit:boolean; 
    public relatedSkuPriceCollectionConfig:any; 
    public loadingPromise:any;
    public masterPriceObject:any; 
    public priceGroupPriceGroupId:string;

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
        if(angular.isDefined(this.skuEligibleCurrencyCodeList)){
            this.eligibleCurrencyCodeList = this.skuEligibleCurrencyCodeList;
        }
        if(angular.isDefined(this.eligibleCurrencyCodeList)){
            this.eligibleCurrencyCodes = this.eligibleCurrencyCodeList.split(",");
        }
        if(angular.isUndefined(this.skuPrices)){
            this.skuPrices = []; 
        }
        if(angular.isDefined(this.skuSkuId)){
            this.skuId = this.skuSkuId; 
        } else {
            //inflate the sku
            this.sku = this.$hibachi.populateEntity("Sku", { skuID:this.skuId, price:this.price });
        }
        if(angular.isDefined(this.skuPriceId)){
            var skuPriceData = {
                skuPriceID:this.skuPriceId, 
                minQuantity:this.minQuantity,
                maxQuantity:this.maxQuantity, 
                currencyCode:this.currencyCode,
                price:this.price,
                priceGroup_priceGroupID:this.priceGroupPriceGroupId
            }
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice", skuPriceData);
        }  
        if(angular.isDefined(this.skuSkuId) && angular.isDefined(this.skuPrice)){
            this.masterPriceObject = this.skuPrice; 
        } else if(angular.isDefined(this.sku)) {
            this.masterPriceObject = this.sku; 
        }
        this.refreshSkuPrices(); 
        this.observerService.attach(this.refreshSkuPrices, "skuPricesUpdate");
    }   

    public refreshSkuPrices = () => {
         this.skuPriceService.loadSkuPricesForSku(this.skuId).finally(()=>{
            this.getSkuPrices(); 
         });
    }

    public hasSkuPrices = () =>{
        return this.skuPriceService.hasSkuPrices(this.skuId);
    }

    public getSkuPrices = () =>{
        if(angular.isDefined(this.skuSkuId)){
             this.loadingPromise = this.skuPriceService.getSkuPricesForQuantityRange( 
                                                                                 this.skuId,
                                                                                 this.minQuantity,
                                                                                 this.maxQuantity,
                                                                                 this.eligibleCurrencyCodes,
                                                                                 this.priceGroupPriceGroupId
                                                                               );

        } else if(angular.isDefined(this.skuId)) {
             this.loadingPromise = this.skuPriceService.getBaseSkuPricesForSku(
                                                                                this.skuId,
                                                                                this.eligibleCurrencyCodes
                                                                              );
        }
        this.loadingPromise.then(
            (data)=>{
                this.skuPrices = data;
            },
            (reason)=>{
                throw("swSkuPrices was unable to fetch skuPrices because: " + reason); 
            }
        );
        return this.loadingPromise; 
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
        listingDisplayId:"@?",
        eligibleCurrencyCodeList:"@?",
        skuEligibleCurrencyCodeList:"@?",
        sku:"=?",
        priceGroupPriceGroupId:"@?"
    };
    public controller = SWSkuPricesEditController;
    public controllerAs="swSkuPricesEdit";
   
    public static Factory(){
        var directive = (
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPricesEdit(
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'scopeService',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }

    constructor(
        private scopeService,
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupricesedit.html";
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
    SWSkuPricesEdit,
    SWSkuPricesEditController
}
