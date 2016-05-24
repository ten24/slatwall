/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuThumbnailController{
   
    public sku; 
   
    //@ngInject
    constructor(
    ){
        if(!angular.isDefined(this.sku)){
            throw("You must provide a sku to the SWSkuThumbnailController");
        }
        if(angular.isDefined(this.sku.data)){
            this.sku = this.sku.data; 
        }
    }    
}

class SWSkuThumbnail implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        sku:"="
    };
    public controller = SWSkuThumbnailController;
    public controllerAs="swSkuThumbnail";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuThumbnail(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skuthumbnail.html";
    }
}
export{
    SWSkuThumbnail,
    SWSkuThumbnailController
}
