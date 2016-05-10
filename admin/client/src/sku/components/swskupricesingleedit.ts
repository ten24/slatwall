/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceSingleEditController{
    
    public skuId;
    
    //@ngInject
    constructor(
        private $hibachi 
    ){
    }    

}

class SWSkuPriceSingleEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@"
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
