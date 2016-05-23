/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuStockAdjustmentModalLauncherController{
    
    //@ngInject
    constructor(
        private $hibachi 
    ){
    
    }    
}

class SWSkuStockAdjustmentModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
    };
    public controller = SWSkuStockAdjustmentModalLauncher;
    public controllerAs="swSkuStockAdjustmentModalLauncher";
   
   
    public static Factory(){
        var directive = (
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuStockAdjustmentModalLauncher(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skustockadjustmentmodallauncher.html";
    }
}
export{
    SWSkuStockAdjustmentModalLauncher,
    SWSkuStockAdjustmentModalLauncherController
}
