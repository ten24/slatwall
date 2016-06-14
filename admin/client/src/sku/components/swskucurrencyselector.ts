/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuCurrencySelectorController{

    public product; 
    public currencyCodes=[];
    public baseEntityCollectionConfig;
    public baseEntityName:string; 
    public baseEntityId:string

    //@ngInject
    constructor(private collectionConfigService){
        //this should be an rbkey
        this.currencyCodes.push("All");
        if(angular.isDefined(this.baseEntityName) && angular.isDefined(this.baseEntityId)){
            this.baseEntityCollectionConfig = this.collectionConfigService.newCollectionConfig(this.baseEntityName);
            this.baseEntityCollectionConfig.addDisplayProperty("eligibleCurrencyCodeList");
            this.baseEntityCollectionConfig.addFilter("productID",this.baseEntityId,"=");
            this.baseEntityCollectionConfig.getEntity().then(
                (response)=>{
                    this.product = response.pageRecords[0]; 
                    this.currencyCodes = this.product.data.eligibleCurrencyCodeList.split(",");
                },
                (reason)=>{
                    //error callback
                }
            );
        }
    }    

}

class SWSkuCurrencySelector implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        baseEntityName:"@?",
        baseEntityId:"@?"
    };
    public controller = SWSkuCurrencySelectorController;
    public controllerAs="swSkuPriceEdit";
   
   
    public static Factory(){
        var directive = (
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuCurrencySelector(
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
		skuPartialsPath,
	    slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skucurrencyselector.html";
    }

    public link:ng.IDirectiveLinkFn = (scope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any, transcludeFn:ng.ITranscludeFunction) =>{
	}
}
export{
    SWSkuCurrencySelector,
    SWSkuCurrencySelectorController
}
