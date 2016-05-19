/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPricesEditController{
    
    public skuId;
    public bundledSkuSkuId; 
   
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

class SWSkuPricesEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        bundledSkuSkuId:"@",
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
