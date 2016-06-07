/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDefaultSkuRadioController{
    
    public skuId;   
    public productProductId;
    public productDefaultSkuSkuId;
    public productId; 
    public sku; 
    public product; 
    public listingDisplayId;
    public columnId;
    public selectionId; 
    public selectionFieldName; 
    public isDefaultSku:boolean; 
    
    public collectionConfig; 
    
    //@ngInject
    constructor(
        private $hibachi,
        private observerService
    ){
        if(angular.isDefined(this.listingDisplayId) && angular.isDefined(this.columnId)){
            this.selectionId = this.listingDisplayId + this.columnId;
        } else if(angular.isDefined(this.listingDisplayId)){
            this.selectionId = this.listingDisplayId; 
        } else {
            throw("You must provide the listingDisplayId to SWDefaultSkuRadioController");
        }
        if(angular.isUndefined(this.selectionFieldName)){
            this.selectionFieldName = this.selectionId + 'selection';
        }
        if(angular.isUndefined(this.skuId) && angular.isUndefined(this.sku)){
            throw("You must provide a skuID to SWDefaultSkuRadioController");
        }
        console.log("isDefault?",this.skuId, this.productDefaultSkuSkuId);
        this.isDefaultSku = (this.skuId == this.productDefaultSkuSkuId);
        if(angular.isUndefined(this.sku)){
            this.$hibachi.getEntity("Sku",this.skuId).then(
                (sku)=>{
                    if(angular.isDefined(sku)){
                        this.sku = this.$hibachi.populateEntity('Sku',sku);
                    } else { 
                        throw("There was a problem fetching the sku in SWSkuPriceSingleEditController");
                    }
                },
                (reason)=>{
                    throw("SWDefaultSkuRadio had trouble loading the sku because:" + reason);
                }
            )
        }
    }    
}

class SWDefaultSkuRadio implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        sku:"=?",
        productProductId:"@?",
        productDefaultSkuSkuId:"@?",
        productId:"@?",
        listingDisplayId:"@?",
        columnId:"@?"
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
    
     public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs) => {
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }
}
export{
    SWDefaultSkuRadio,
    SWDefaultSkuRadioController
}
