/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuCurrencySelectorController{

    public product; 
    public currencyCodes=[];
    public selectedCurrencyCode:String; 
    public baseEntityCollectionConfig;
    public baseEntityName:string="Product"; 
    public baseEntityId:string;
    public selectCurrencyCodeEventName:string; 

    //@ngInject
    constructor(
        private collectionConfigService, 
        private observerService, 
        private $hibachi
    ){
        //this should be an rbkey
        this.currencyCodes.push("All");
        if( angular.isDefined(this.baseEntityId) ){ 
            this.selectCurrencyCodeEventName = "currencyCodeSelect" + this.baseEntityId; 
        }
        this.selectedCurrencyCode = "USD"; 
        this.observerService.notifyAndRecord(this.selectCurrencyCodeEventName, this.selectedCurrencyCode);
        if(angular.isDefined(this.baseEntityName) && angular.isDefined(this.baseEntityId)){
            this.baseEntityCollectionConfig = this.collectionConfigService.newCollectionConfig(this.baseEntityName);
            this.baseEntityCollectionConfig.addDisplayProperty("eligibleCurrencyCodeList");
            this.baseEntityCollectionConfig.addFilter("productID",this.baseEntityId,"=",'AND',true);
            this.baseEntityCollectionConfig.getEntity().then(
                (response)=>{
                    this.product = this.$hibachi.populateEntity(this.baseEntityName,response.pageRecords[0]); 
                    var tempCurrencyCodeArray =  this.product.data.eligibleCurrencyCodeList.split(",");
                    for(var key in tempCurrencyCodeArray){
                        this.currencyCodes.push(tempCurrencyCodeArray[key]);
                    }
                },
                (reason)=>{
                    //error callback
                }
            );
        }
    }    

    public select = (currencyCode:string) =>{
        this.selectedCurrencyCode = currencyCode;
        this.observerService.notifyAndRecord(this.selectCurrencyCodeEventName, currencyCode);
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
    public controllerAs="swSkuCurrencySelector";
   
   
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
