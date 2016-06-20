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
        private $hibachi,
        private listingService, 
        private skuPriceService, 
        private utilityService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
    }    
    
    public delete = () => {
        var deletePromise = this.skuPrice.$$delete();
        deletePromise.then(
            (response)=>{
                if(angular.isDefined(this.listingID)){
                    var pageRecords = this.listingService.getListingPageRecords(this.listingID);
                    for(var i = 0; i < pageRecords.length; i++){
                        if(angular.isDefined(pageRecords[i].skuPriceID) &&
                           this.skuPrice.data.minQuantity == pageRecords[i].minQuantity &&
                           this.skuPrice.data.maxQuantity == pageRecords[i].maxQuantity
                        ){
                           pageRecords.splice(i,1);
                           break; 
                        }
                    }
                }
            },
            (reason)=>{
                //error callback
            }
        );
        return deletePromise; 
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
                var currentScope = this.scopeService.locateParentScope($scope, "pageRecord");
                if(angular.isDefined(currentScope.pageRecord)){ 
                    $scope.swDeleteSkuPriceModalLauncher.pageRecord = currentScope.pageRecord; 
                    if(angular.isDefined(currentScope.pageRecord.skuPriceID) && currentScope.pageRecord.skuPriceID.length){    
                        var skuPriceData = {
                            skuPriceID:currentScope.pageRecord.skuPriceID,
                            minQuantity:currentScope.pageRecord.minQuantity,
                            maxQuantity:currentScope.pageRecord.maxQuantity,
                            currencyCode:currentScope.pageRecord.currencyCode, 
                            price:currentScope.pageRecord.price
                        }
                        $scope.swDeleteSkuPriceModalLauncher.skuPrice = this.$hibachi.populateEntity('SkuPrice',skuPriceData);
                    }
                } else{ 
                    throw("swDeleteSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
                } 
                var listingScope = this.scopeService.locateParentScope($scope, "swMultiListingDisplay");
                if(angular.isDefined(listingScope.swMultiListingDisplay)){ 
                    $scope.swDeleteSkuPriceModalLauncher.listingID = listingScope.swMultiListingDisplay.tableID;
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
