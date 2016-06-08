/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuStockAdjustmentModalLauncherController{
    
    public skuId:string; 
    public skuCode:string; 
    public skuDescription:string; 
    public imagePath:string;
    public sku:any; 
    public stock:any; 
    public stockAdjustment:any; 
    public stockAdjustmentType:any; 
    public stockAdjustmentStatusType:any; 
    public stockAdjustmentItem:any; 
    public toLocation:any; 
    public name:string; 
    public quantityDifference:number; 
    public calculatedQats:any; 
    public calculatedQoh:any; 
    
    public stockAdjustmentTypePromise:any; 
    public stockAdjustmentStatusTypePromise:any;
    
    public skuPromise; 
    
    //@ngInject
    constructor(
        private $q, 
        private $hibachi 
    ){
        if(angular.isDefined(this.skuId)){
            this.name="j-change-qty-" + this.skuId;
        } else{
            throw("SWSkuStockAdjustmentModalLauncherController was not provided with a sku id"); 
        }
        this.initData();
    }
    
    public initData = () => {
        this.stock = this.$hibachi.newStock();
        this.stockAdjustment = this.$hibachi.newStockAdjustment();
        this.toLocation = this.$hibachi.newLocation(); 
        this.stockAdjustment.$$setToLocation(this.toLocation);
        this.stockAdjustmentItem = this.$hibachi.newStockAdjustmentItem();
        this.stockAdjustment.$$addStockAdjustmentItem(this.stockAdjustmentItem);
        this.stockAdjustmentItem.$$setToStock(this.stock);
        this.stockAdjustmentType = this.$hibachi.populateEntity("Type",{typeID:"444df2e60db81c12589c9b39346009f2"});//manual in stock adjustment type 
        this.stockAdjustmentStatusType = this.$hibachi.populateEntity("Type",{typeID:"444df2e2f66ddfaf9c60caf5c76349a6"});//new status type for stock adjusment
        var skudata = {
            skuID:this.skuId,
            skuCode:this.skuCode,
            skuDescription:this.skuDescription,
            imagePath:this.imagePath,
            calculatedQATS:this.calculatedQats || 0,
            calculatedQOH:this.calculatedQoh || 0
        }
        this.sku = this.$hibachi.populateEntity("Sku", skudata);
    }
    
    public save = () => {
        var savePromise = this.stockAdjustment.$$save(); 
        savePromise.then((response)=>{
            this.initData(); 
        });
        return savePromise;
    }      
}


class SWSkuStockAdjustmentModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        skuId:"@",
        skuCode:"@",
        skuDescription:"@",
        imagePath:"@",
        calculatedQats:"@?",
        calculatedQoh:"@?"
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
