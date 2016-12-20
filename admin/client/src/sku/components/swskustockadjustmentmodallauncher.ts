/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuStockAdjustmentModalLauncherController{
    
    public skuId:string; 
    public skuCode:string; 
    public skuDescription:string; 
    public imagePath:string;
    public sku:any; 
    public stock:any; 
    public stockAdjustmentID:string; 
    public stockAdjustment:any; 
    public stockAdjustmentType:any; 
    public stockAdjustmentStatusType:any; 
    public stockAdjustmentItem:any; 
    public toLocation:any; 
    public name:string; 
    public quantityDifference:number; 
    public calculatedQats:any; 
    public calculatedQoh:any; 
    public newQuantity:number; 
    
    public stockAdjustmentTypePromise:any; 
    public stockAdjustmentStatusTypePromise:any;
    
    public skuPromise; 
    
    //@ngInject
    constructor(
        private $http, 
        private $q, 
        private $hibachi, 
        private observerService,
        private utilityService
    ){

        if(angular.isDefined(this.skuId)){
            this.name="skuStockAdjustment" + this.utilityService.createID(32);
        } else{
            throw("SWSkuStockAdjustmentModalLauncherController was not provided with a sku id"); 
        }
        if(angular.isDefined(this.calculatedQats)){
            this.calculatedQats = parseInt(this.calculatedQats);
        }

        if(angular.isDefined(this.calculatedQoh)){
            this.calculatedQoh = parseInt(this.calculatedQoh);
        }
        var skudata = {
            skuID:this.skuId,
            skuCode:this.skuCode,
            skuDescription:this.skuDescription,
            imagePath:this.imagePath,
            calculatedQATS:this.calculatedQats || 0,
            calculatedQOH:this.calculatedQoh || 0,
            newQOH:this.calculatedQoh || 0
        }
        this.sku = this.$hibachi.populateEntity("Sku", skudata);

        this.observerService.attach(this.updateNewQuantity, this.name + 'newQuantitychange');
        this.initData();
    }
    
    public initData = () => {
        this.stockAdjustmentID="";
        this.stock = this.$hibachi.newStock();
        this.stockAdjustment = this.$hibachi.newStockAdjustment();
        this.stockAdjustmentItem = this.$hibachi.newStockAdjustmentItem();
        this.toLocation = this.$hibachi.newLocation(); 
        this.stockAdjustment.$$setToLocation(this.toLocation);
        this.stockAdjustment.$$addStockAdjustmentItem(this.stockAdjustmentItem);
        this.stock.$$setSku(this.sku);
        this.stockAdjustmentItem.$$setToStock(this.stock);
        this.stockAdjustmentType = this.$hibachi.populateEntity("Type",{typeID:"444df2e60db81c12589c9b39346009f2"});//manual in stock adjustment type 
        this.stockAdjustmentStatusType = this.$hibachi.populateEntity("Type",{typeID:"444df2e2f66ddfaf9c60caf5c76349a6"});//new status type for stock adjusment
        this.stockAdjustment.$$setStockAdjustmentType(this.stockAdjustmentType);
        this.stockAdjustment.$$setStockAdjustmentStatusType(this.stockAdjustmentStatusType);
        this.stockAdjustmentItem.$$setSku(this.sku); 
        this.newQuantity = this.calculatedQoh || 0;
    }
    
    public save = () => {
        return this.$q.all([this.observerService.notify('updateBindings'), this.stock.$$save()]).then().finally(()=>{
            var stockAdjustmentSavePromise = this.stockAdjustment.$$save(); 
            stockAdjustmentSavePromise.then(
                (response)=>{
                    this.sku.newQOH = this.newQuantity;
                    this.sku.data.newQOH = this.newQuantity; 
                    this.sku.data.calculatedQOH = this.newQuantity; 
                    this.stockAdjustmentID = response.stockAdjustmentID; 
                }
            ).finally(()=>{
                this.$http({
                    method:"POST", 
                    url:this.$hibachi.getUrlWithActionPrefix()+"entity.processStockAdjustment&processContext=processAdjustment&stockAdjustmentID="+this.stockAdjustmentID
                }).then((response)=>{
                    //don't need to do anything here
                });

            }); 
        });
    }    


    public updateNewQuantity = (args) => { 
        if(!isNaN(args.swInput.value)){
            this.newQuantity = args.swInput.value;
        } else {
            this.sku.data.newQOH = 0; 
        }
        this.updateStockAdjustmentQuantity();
    }

    public updateStockAdjustmentQuantity = () => {
        if(!isNaN(this.newQuantity)){
            this.stockAdjustmentItem.data.quantity = this.newQuantity - this.sku.data.calculatedQOH;
        } else {
            this.newQuantity = 0;
        }
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
