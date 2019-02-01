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
        private defaultSkuService
    ){
        if(angular.isDefined(this.listingDisplayId) && angular.isDefined(this.columnId)){
            this.selectionId = this.listingDisplayId + this.columnId;
        } else if(angular.isDefined(this.listingDisplayId)){
            this.selectionId = this.listingDisplayId; 
        } else {
            throw("You must provide the listingDisplayId to SWDefaultSkuRadioController");
        }
        defaultSkuService.attachObserver(this.selectionId,this.productProductId);
        if(angular.isUndefined(this.selectionFieldName)){
            this.selectionFieldName = this.selectionId + 'selection';
        }
        if(angular.isUndefined(this.skuId) && angular.isUndefined(this.sku)){
            throw("You must provide a skuID to SWDefaultSkuRadioController");
        }
        this.isDefaultSku = (this.skuId == this.productDefaultSkuSkuId);
        if(angular.isUndefined(this.sku)){
            var skuData = {
                skuID:this.skuId
            }
           this.sku = this.$hibachi.populateEntity('Sku',skuData);
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
