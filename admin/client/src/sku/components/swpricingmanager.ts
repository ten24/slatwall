/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWPricingManagerController{
    
    public productId;
    
    //temporary var
    public singleEditTest; 
    
    //@ngInject
    constructor(
        private $hibachi 
    ){
       this.singleEditTest = $hibachi.newEntity("SkuPrice");
       console.log("white whale", this.singleEditTest);  
    }    

}

class SWPricingManager implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        productId:"@"
    };
    public controller = SWPricingManagerController;
    public controllerAs="SWPricingManager";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWPricingManager(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"pricingmanager.html";
    }
}
export{
    SWPricingManager,
    SWPricingManagerController
}
