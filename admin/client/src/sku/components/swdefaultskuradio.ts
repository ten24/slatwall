/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDefaultSkuRadioController{
    
    public skuId;   
    public sku; 
    
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private $hibachi
    ){
        if(angular.isUndefined(this.skuId) && angular.isUndefined(this.sku)){
            throw("You must provide a skuID to SWSkuPriceSingleEditController");
        }
        if(angular.isUndefined(this.sku)){
            this.$hibachi.getEntity("Sku",this.skuId).then(
                (sku)=>{
                    if(angular.isDefined(sku)){
                        this.sku = this.$hibachi.newEntity('Sku');
                        angular.extend(this.sku.data, sku);
                    } else { 
                        throw("There was a problem fetching the sku in SWSkuPriceSingleEditController");
                    }
                },
                (reason)=>{
                   throw("SWDefaultSkuRadio had trouble loading the sku because:" + reason);
                }
           ); 
        }
    }    

}

class SWDefaultSkuRadio implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        sku:"=?"
    };
    public controller = SWDefaultSkuRadioController;
    public controllerAs="swDefaultSkuRadio";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWDefaultSkuRadio(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"defaultskuradio.html";
    }
}
export{
    SWDefaultSkuRadio,
    SWDefaultSkuRadioController
}
