/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceSingleEditController{
    
    public skuId;
    public currencyCode;
    public bundledSkuSkuId; 
    public bundledSkuCurrencyCode;
   
    public sku; 
    
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
        if(angular.isUndefined(this.skuId) && angular.isUndefined(this.sku)){
            throw("You must provide a skuID to SWSkuPriceSingleEditController");
        }
        if(angular.isUndefined(this.sku)){
            this.collectionConfig = this.collectionConfigService.newCollectionConfig("Sku"); 
            this.collectionConfig.addFilter("skuID", this.skuId, "=");
            this.collectionConfig.setAllRecords(true);
            this.collectionConfig.getEntity().then(
                (response)=>{
                    if(angular.isDefined(response.records) && angular.isDefined(response.records[0])){
                        this.sku = this.$hibachi.newEntity('Sku');
                        angular.extend(this.sku.data, response.records[0]);
                    } else { 
                        throw("There was a problem fetching the sku in SWSkuPriceSingleEditController")
                    }
                },
                (reason)=>{
                    //there was an error 
                }
           ); 
        }
    }    

}

class SWSkuPriceSingleEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        bundledSkuSkuId:"@",
        bundledSkuCurrencyCode:"@",        
        currencyCode:"@",
        sku:"=?"
    };
    public controller = SWSkuPriceSingleEditController;
    public controllerAs="swSkuPriceSingleEdit";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPriceSingleEdit(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupricesingleedit.html";
    }
}
export{
    SWSkuPriceSingleEdit,
    SWSkuPriceSingleEditController
}
