/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuThumbnailController{
   
    public sku:any; 
    public imagePath:string;
    public imageOnly:boolean; 
   
    //@ngInject
    constructor(
    ){
        if(!angular.isDefined(this.sku)){
            throw("You must provide a sku to the SWSkuThumbnailController");
        }
    }    
}

class SWSkuThumbnail implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        sku:"=",
        imageOnly:"=?",
        imagePath:"@?"
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
