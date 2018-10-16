/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDeleteSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public sku:any;
    public skuId:string; 
    public skuPrice:any; 
    public baseName:string="j-delete-sku-item-"; 
    public listingID:string; 
    public uniqueName:string; 
    
    //@ngInject
    constructor(
        private $q,
        private $hibachi,
        private listingService, 
        private skuPriceService, 
        private utilityService,
        private observerService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
    }    

    public delete = () => {
        var priceGroupID = undefined;
        if(this.skuPrice.data.priceGroup){
            priceGroupID = this.skuPrice.data.priceGroup.data.priceGroupID;
        }
        var skuPricesToDelete = this.skuPriceService.getSkuPricesForQuantityRange(this.skuId, this.skuPrice.data.minQuantity, this.skuPrice.data.maxQuantity,undefined, priceGroupID);
        var deletePromises = [];
        skuPricesToDelete.then(
            (skuPrices)=>{  
                for(var i = 0; i < skuPrices.length; i++){
                    if(skuPrices[i].data.skuPriceID.length){
                        deletePromises.push(skuPrices[i].$$delete());
                    }
                }
            },
            (reason)=>{
                //error
            }
        ).finally(()=>{
            this.$q.all(deletePromises).then(
                (response)=>{
                    if(angular.isDefined(this.listingID)){
                        var pageRecords = this.listingService.getListingPageRecords(this.listingID);
                        for(var i = 0; i < pageRecords.length; i++){
                            if( angular.isDefined(pageRecords[i].skuPriceID) &&
                                this.skuPrice.data.skuPriceID == pageRecords[i].skuPriceID
                            ){
                                pageRecords.splice(i,1);
                                break; 
                            }
                        }
                    }
                }
            );
        });
        return this.$q.all(deletePromises); 
    }
}

class SWDeleteSkuPriceModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        pageRecord:"=?"
    };
    public controller = SWDeleteSkuPriceModalLauncherController;
    public controllerAs="swDeleteSkuPriceModalLauncher";
   
   
    public static Factory(){
        var directive = (
            $hibachi,
            scopeService, 
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWDeleteSkuPriceModalLauncher(
            $hibachi, 
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'scopeService',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        private $hibachi, 
        private scopeService,
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"deleteskupricemodallauncher.html";
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                //have to do our setup here because there is no direct way to pass the pageRecord into this transcluded directive
                var currentScope = this.scopeService.getRootParentScope($scope, "pageRecord");
                if(angular.isDefined(currentScope.pageRecord)){ 
                    $scope.swDeleteSkuPriceModalLauncher.pageRecord = currentScope.pageRecord; 
                    if(angular.isDefined(currentScope.pageRecord.sku_skuID)){
                         $scope.swDeleteSkuPriceModalLauncher.skuId = currentScope.pageRecord.sku_skuID;
                    }
                    if(angular.isDefined(currentScope.pageRecord.skuPriceID) && currentScope.pageRecord.skuPriceID.length){    
                        var skuPriceData = {
                            skuPriceID:currentScope.pageRecord.skuPriceID,
                            minQuantity:currentScope.pageRecord.minQuantity,
                            maxQuantity:currentScope.pageRecord.maxQuantity,
                            currencyCode:currentScope.pageRecord.currencyCode, 
                            price:currentScope.pageRecord.price
                        }
                        $scope.swDeleteSkuPriceModalLauncher.skuPrice = this.$hibachi.populateEntity('SkuPrice',skuPriceData);
                        var priceGroup = this.$hibachi.populateEntity('PriceGroup',{priceGroupID:currentScope.pageRecord.priceGroup_priceGroupID});
                        $scope.swDeleteSkuPriceModalLauncher.skuPrice.$$setPriceGroup(priceGroup);
                    }
                } else{ 
                    throw("swDeleteSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
                } 
                var listingScope = this.scopeService.getRootParentScope($scope, "swListingDisplay");
                if(angular.isDefined(listingScope.swListingDisplay)){ 
                    $scope.swDeleteSkuPriceModalLauncher.listingID = listingScope.swListingDisplay.tableID;
                }
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {

            }
        };
    }
}
export{
    SWDeleteSkuPriceModalLauncher,
    SWDeleteSkuPriceModalLauncherController
}
