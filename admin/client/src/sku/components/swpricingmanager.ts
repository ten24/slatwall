/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWPricingManagerController{
    
    public productId;
    
    //temporary var
    public singleEditTest; 
    public testScope; 
    
    //@ngInject
    constructor(
        private $hibachi 
    ){
       console.log("priority","pricing manager constructor");
    }    

}

class SWPricingManager implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public priority = 1000;
    public scope = {}; 
    public bindToController = {
        productId:"@"
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
    
    constructor(
        private $hibachi, 
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"pricingmanager.html";
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes, transclude: any) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                console.log("priority","pricemanager pre");
                $scope.swPricingManager.singleEditTest = this.$hibachi.newEntity("SkuPrice"); 
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                console.log("priority","pricemanager post");
            }
        };
    }
}
export{
    SWPricingManager,
    SWPricingManagerController
}
