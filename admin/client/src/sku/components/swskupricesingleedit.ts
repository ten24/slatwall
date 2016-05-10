/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceSingleEditController{
    
    public skuId;
    
    public sku; 
    
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private collectionConfigService
    ){
        if(angular.isUndefined(this.skuId) && angular.isUndefined(this.sku)){
            throw("You must provide a skuID to SWSkuPriceSingleEditController");
        }
        if(angular.isUndefined(this.sku)){
            this.collectionConfig = this.collectionConfigService.newCollectionConfig("Sku"); 
            this.collectionConfig.addFilter("skuID", this.skuId, "=");
            this.collectionConfig.setAllRecords(true);
            this.collectionConfig.getEntity().then((response)=>{
                if(angular.isDefined(response.records[0])){
                    this.sku = response.records[0];
                } else { 
                    throw("There was a problem fetching the sku in SWSkuPriceSingleEditController")
                }
            }); 
        }
    }    

}

class SWSkuPriceSingleEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        sku:"=?"
    };
    public controller = SWSkuPriceSingleEditController;
    public controllerAs="SWSkuPriceSingleEdit";
   
   
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
