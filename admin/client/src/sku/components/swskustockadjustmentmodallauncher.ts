/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuStockAdjustmentModalLauncherController{
    
    public skuId:string; 
    public sku:any; 
    public stock:any; 
    public stockAdjustment:any; 
    public processObject:any; 
    public name:string; 
    
    //@ngInject
    constructor(
        private $hibachi 
    ){
        if(angular.isDefined(this.skuId)){
            this.name="j-change-qty-" + this.skuId;
        } else{
            throw("SWSkuStockAdjustmentModalLauncherController was not provided with a sku id"); 
        }
        this.stock = this.$hibachi.newEntity('Stock');
        this.stockAdjustment = this.$hibachi.newEntity('StockAdjustment');
        this.processObject = this.$hibachi.newEntity('StockAdjustment_AddStockAdjustmentItem');
        console.log("THISSSS", this);
        $hibachi.getEntity("Sku",this.skuId).then(
            (sku)=>{
                this.sku = this.$hibachi.newEntity('Sku');
                angular.extend(this.sku.data, sku);
                if(!this.sku.data.calculatedQOH.length){
                    this.sku.data.calculatedQOH = 0; 
                }
                console.log("looky", this.sku);
            },
            (reason)=>{
                throw("SWSkuStockAdjustmentModalLauncherController was unable to load the sku for the provided id:" + this.skuId + " with a reason of: " + reason );
            }
        );
    }    
}

class SWSkuStockAdjustmentModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@"
    };
    public controller = SWSkuStockAdjustmentModalLauncherController;
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
