/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceQuantityEditController{
    
    public skuPriceId:string;
    public skuPrice:any; 
    public column:any; 
    public columnPropertyIdentifier:string; 
    public filterOnCurrencyCode:string;
    public minQuantity:string; 
    public maxQuantity:string; 
    
    
    //@ngInject
    constructor(
        private $hibachi
    ){
        
        if(angular.isUndefined(this.skuPrice)){
            var skuPriceData = {
                skuPriceID:this.skuPriceId, 
                minQuantity:this.minQuantity, 
                maxQuantity:this.maxQuantity
            }
            this.skuPrice = this.$hibachi.populateEntity("SkuPrice",skuPriceData);
        }
    }    

     

}

class SWSkuPriceQuantityEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuPrice:"=?",
        skuPriceId:"@",
        column:"=?",
        columnPropertyIdentifier:"@",
        minQuantity:"@",
        maxQuantity:"@"
    };
    public controller = SWSkuPriceQuantityEditController;
    public controllerAs="swSkuPriceQuantityEdit";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPriceQuantityEdit(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupricequantityedit.html";
    }
}
export{
    SWSkuPriceQuantityEdit,
    SWSkuPriceQuantityEditController
}
