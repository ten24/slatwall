/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var pricingmanagerHTML='';
try{
    pricingmanagerHTML = require("html-loader!Custom/test.html");
}catch(err){
    pricingmanagerHTML = require("html-loader!Admin/sku/components/pricingmanager.html");
}

class SWPricingManagerController{
    
    public productId;
    public product; 
    public productCollectionConfig;
    public trackInventory; 
    
    //temporary var
    public singleEditTest; 
    public testScope; 
    
    //@ngInject
    constructor(
        private collectionConfigService
    ){
        this.productCollectionConfig = this.collectionConfigService.newCollectionConfig("Product"); 
        this.productCollectionConfig.addFilter("productID", this.productId, "=",'AND',true);
        this.productCollectionConfig.addDisplayProperty("productID,defaultSku.currencyCode");
        this.productCollectionConfig.getEntity().then(
            (response)=>{
                this.product = response.pageRecords[0]; 
            },
            (reason)=>{

            }
        );
    }    

}

class SWPricingManager implements ng.IDirective{
    public template;
    public restrict = 'EA';
    public priority = 1000;
    public scope = {}; 
    public bindToController = {
        productId:"@",
        trackInventory:"=?"
    };
    public controller = SWPricingManagerController;
    public controllerAs="swPricingManager";
   
    public static Factory(){
        var directive = (
            $hibachi, 
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWPricingManager(
            $hibachi, 
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    // @ngInject
    constructor(
        private $hibachi, 
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.template = pricingmanagerHTML;
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
    SWPricingManager,
    SWPricingManagerController
}
