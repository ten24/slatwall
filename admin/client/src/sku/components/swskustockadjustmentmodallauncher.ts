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
    public selectedLocation:any;
    public selectedLocationTypeaheadDataKey:string;
    public name:string;
    public quantityDifference:number;
    public calculatedQats:any;
    public calculatedQoh:any;
    public newQuantity:number;

    public stockAdjustmentTypePromise:any;
    public stockAdjustmentStatusTypePromise:any;

    public stockCollectionConfig;
    public swListingDisplay;


    public skuPromise;

    //@ngInject
    constructor(
        private $http,
        private $q,
        private $hibachi,
        private observerService,
        private utilityService,
        private collectionConfigService
    ){
        this.selectedLocationTypeaheadDataKey = this.utilityService.createID(32);
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
        this.initData();
        this.observerService.attach(this.updateNewQuantity, this.name + 'newQuantitychange');
    }

    public initData = () => {
        this.selectedLocation = undefined;
        this.stockAdjustmentType = undefined;
        var skudata = {
            skuID:this.skuId,
            skuCode:this.skuCode,
            skuDescription:this.skuDescription,
            imagePath:this.imagePath,
            calculatedQATS:this.calculatedQats || 0,
            calculatedQOH:this.calculatedQoh || 0,
        }
        this.sku = this.$hibachi.populateEntity("Sku", skudata);
        this.sku.setNewQOH(this.calculatedQoh || 0);

        this.stockAdjustmentID="";
        this.stock = this.$hibachi.newStock();
        this.stockAdjustment = this.$hibachi.newStockAdjustment();
        this.stockAdjustmentItem = this.$hibachi.newStockAdjustmentItem();
        this.selectedLocation = this.$hibachi.newLocation();

        this.stockAdjustment.$$addStockAdjustmentItem(this.stockAdjustmentItem);
        this.stock.$$setSku(this.sku);
        this.stockAdjustmentStatusType = this.$hibachi.populateEntity("Type",{typeID:"444df2e2f66ddfaf9c60caf5c76349a6"});//new status type for stock adjusment
        this.stockAdjustment.$$setStockAdjustmentStatusType(this.stockAdjustmentStatusType);
        this.stockAdjustmentItem.$$setSku(this.sku);

        this.newQuantity = this.calculatedQoh || 0;
        this.observerService.notify(this.selectedLocationTypeaheadDataKey + 'clearSearch');
    }

    public save = () => {
        if (this.stockAdjustmentItem.data.quantity > 0){
            this.stockAdjustment.$$setStockAdjustmentType(this.$hibachi.populateEntity("Type",{typeID:"444df2e60db81c12589c9b39346009f2"}));//manual in stock adjustment type
            this.stockAdjustment.$$setToLocation(this.selectedLocation);
            this.stockAdjustmentItem.$$setToStock(this.stock);
        }else{
            this.stockAdjustment.$$setStockAdjustmentType(this.$hibachi.populateEntity("Type",{typeID:"444df2e7dba550b7a24a03acbb37e717"}));//manual out stock adjustment type
            this.stockAdjustment.$$setFromLocation(this.selectedLocation);
            this.stockAdjustmentItem.data.quantity = this.stockAdjustmentItem.data.quantity * -1;
            this.stockAdjustmentItem.$$setFromStock(this.stock);
        }

        return this.$q.all([this.observerService.notify('updateBindings'), this.stock.$$save()]).then().finally(()=>{
            var stockAdjustmentSavePromise = this.stockAdjustment.$$save();
            stockAdjustmentSavePromise.then(
                (response)=>{
                    this.sku.newQOH = this.newQuantity;
                    this.sku.data.newQOH = this.newQuantity;
                    this.sku.data.calculatedQOH = this.newQuantity;
                    this.stockAdjustmentID = response.stockAdjustmentID;
                    this.observerService.notify('updateBindings')
                }
            ).finally(()=>{
                this.observerService.notify('updateBindings')
                this.$http({
                    method:"POST",
                    url:this.$hibachi.getUrlWithActionPrefix()+"entity.processStockAdjustment&processContext=processAdjustment&stockAdjustmentID="+this.stockAdjustmentID
                }).then((response)=>{
                    //don't need to do anything here
                    this.swListingDisplay.getCollection();
                });

            });
        });
    }

    public addSelectedLocation = (item) =>{
        if(angular.isDefined(item)){
            this.selectedLocation = this.$hibachi.populateEntity('Location', item);

            this.stock.$$setLocation(this.selectedLocation);

            //get existing stockID if one exists
            this.stockCollectionConfig = this.collectionConfigService.newCollectionConfig('Stock');
            this.stockCollectionConfig.addFilter('sku.skuID', this.stock.sku.skuID);
            this.stockCollectionConfig.addFilter('location.locationID', this.selectedLocation.locationID);
            this.stockCollectionConfig.setDistinct(true);
            this.stockCollectionConfig.getEntity().then((res) =>{
                if (res.pageRecords.length > 0){
                    this.stock.stockID = res.pageRecords[0].stockID;
                }
            });
        } else {
            this.selectedLocation = undefined;
        }
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
    public require = {swListingDisplay:'?^swListingDisplay'};
    public bindToController = {
        skuId:"@",
        skuCode:"@",
        skuDescription:"@",
        imagePath:"@",
        calculatedQats:"=?",
        calculatedQoh:"=?"
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
    public link=(scope,element,attrs)=>{
        scope.$watch('swStockAdjustmentModalLauncherController.calculatedQoh',(newValue)=>{
            scope.swSkuStockAdjustmentModalLauncher.newQuantity = newValue;
        });
    }
}
export{
    SWSkuStockAdjustmentModalLauncher,
    SWSkuStockAdjustmentModalLauncherController
}
