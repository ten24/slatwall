/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuStockAdjustmentModalLauncherController{
    
    public skuId:string; 
    public sku:any; 
    public stock:any; 
    public stockAdjustment:any; 
    public stockAdjustmentType:any; 
    public stockAdjustmentStatusType:any; 
    public stockAdjustmentItem:any; 
    public toLocation:any; 
    public name:string; 
    public quantityDifference:number; 
    
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
        this.stock = this.$hibachi.newStock();
        this.stockAdjustment = this.$hibachi.newStockAdjustment();
        this.toLocation = this.$hibachi.newLocation(); 
        this.stockAdjustment.$$setToLocation(this.toLocation);
        this.stockAdjustmentItem = this.$hibachi.newStockAdjustmentItem();
        this.stockAdjustment.$$addStockAdjustmentItem(this.stockAdjustmentItem);
        this.stockAdjustmentItem.$$setToStock(this.stock);
        this.skuPromise = $hibachi.getEntity("Sku",this.skuId);
        this.stockAdjustmentTypePromise = $hibachi.getEntity("Type","444df2e60db81c12589c9b39346009f2");//manual in stock adjustment type 
        this.stockAdjustmentStatusTypePromise = $hibachi.getEntity("Type","444df2e2f66ddfaf9c60caf5c76349a6");//new status type for stock adjusment
        this.skuPromise.then(
            (sku)=>{
                this.sku = this.$hibachi.populateEntity("Sku", sku);
                if(!this.sku.data.calculatedQOH.length){
                    this.sku.data.calculatedQOH = 0; 
                }
                this.stockAdjustmentItem.$$setSku(this.sku); 
            },
            (reason)=>{
                throw("SWSkuStockAdjustmentModalLauncherController was unable to load the sku for the provided id:" + this.skuId + " with a reason of: " + reason );
            }
        );
        this.stockAdjustmentStatusTypePromise.then(
            (type)=>{
                this.stockAdjustmentStatusType = this.$hibachi.populateEntity("Type",type); 
                this.stockAdjustment.$$setStockAdjustmentStatusType(this.stockAdjustmentStatusType);
            },
            (reason)=>{
                //error callback   
            }
        );
        this.stockAdjustmentTypePromise.then(
            (type)=>{
                this.stockAdjustmentType = this.$hibachi.populateEntity("Type",type); 
                this.stockAdjustment.$$setStockAdjustmentType(this.stockAdjustmentType);
            },
            (reason)=>{
                //error callback   
            }
        );
        
    }
    
    public save = () => {
        this.stockAdjustment.$$save().then(
            (response)=>{
                //sucess callback
                $("#" + this.name).modal('hide');
            },
            (reason)=>{
                //error callback
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
