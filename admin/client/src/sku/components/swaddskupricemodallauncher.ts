/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public sku:any;
    public skuId:string; 
    public skuPrice:any; 
    public baseName:string="j-add-sku-item-"; 
    public formName:string; 
    public uniqueName:string;
    public listingID:string;  
    public currencyCodeOptions; 
    
    //@ngInject
    constructor(
        private $hibachi,
        private formService,
        private listingService,
        private observerService, 
        private skuPriceService,
        private utilityService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.formName = "addSkuPrice" + this.utilityService.createID(16);
        this.skuPrice = this.$hibachi.newEntity('SkuPrice'); 
        this.initData(); 
    }    
    
    public initData = () =>{
        //these are populated in the link function initially
        this.skuPrice.$$setSku(this.sku);
    }
    
    public save = () => {
        var savePromise = this.skuPrice.$$save();
        savePromise.then(
            (response)=>{ 
               this.skuPriceService.setSkuPrices(this.sku.data.skuID,[this.skuPrice]);
               this.observerService.notify('skuPricesUpdate',{skuID:this.sku.data.skuID,refresh:true});
                //temporarily overriding for USD need to get this setting accessable to client side
                if(angular.isDefined(this.listingID) && this.skuPrice.data.currencyCode=="USD"){
                   var pageRecords = this.listingService.getListingPageRecords(this.listingID);
                   for(var i=0; i < pageRecords.length; i++){
                        if( angular.isDefined(pageRecords[i].skuID) &&
                            pageRecords[i].skuID == this.sku.data.skuID
                        ){
                            var index = i + 1; 
                            while(index < pageRecords.length && angular.isUndefined(pageRecords[index].skuID)){
                                if(pageRecords[index].minQuantity <= this.skuPrice.data.minQuantity &&
                                   index + 1 < pageRecords.length && (
                                   pageRecords[index+1].minQuantity >= this.skuPrice.data.minQuantity ||
                                   angular.isDefined(pageRecords[index+1].skuID) )
                                ){
                                    this.skuPrice.data.skuSkuId = this.skuId;
                                    var skuPriceForListing = {}; 
                                    angular.copy(this.skuPrice.data,skuPriceForListing); 
                                    pageRecords.splice(index+1,0,skuPriceForListing);
                                    break; 
                                }
                                index++; 
                            }
                        }
                   }
                } 
            },
            (reason)=>{
                //error callback
            }
        ).finally(()=>{
            for(var key in this.skuPrice.data){
                this.skuPrice.data[key] = null;
            }
            this.initData(); 
        });
        return savePromise; 
    }
}

class SWAddSkuPriceModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        pageRecord:"=?"
    };
    public controller = SWAddSkuPriceModalLauncherController;
    public controllerAs="swAddSkuPriceModalLauncher";
   
   
    public static Factory(){
        var directive = (
            $hibachi,
            scopeService,
            collectionConfigService,
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWAddSkuPriceModalLauncher(
            $hibachi, 
            scopeService,
            collectionConfigService,
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'scopeService',
            'collectionConfigService',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        private $hibachi, 
        private scopeService, 
        private collectionConfigService, 
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"addskupricemodallauncher.html";
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
                //have to do our setup here because there is no direct way to pass the pageRecord into this transcluded directive
                var currentScope = this.scopeService.locateParentScope($scope, "pageRecord");
                if(angular.isDefined(currentScope.pageRecord)){ 
                    $scope.swAddSkuPriceModalLauncher.pageRecord = currentScope.pageRecord; 
                    if(angular.isDefined(currentScope.pageRecord.skuID)){    
                        var skuData = {
                            skuID:currentScope.pageRecord.skuID,
                            skuCode:currentScope.pageRecord.skuCode,
                            skuDescription:currentScope.pageRecord.skuDescription,
                            eligibleCurrencyCodeList:currentScope.pageRecord.eligibleCurrencyCodeList
                        }
                        $scope.swAddSkuPriceModalLauncher.currencyCodeOptions = currentScope.pageRecord.eligibleCurrencyCodeList.split(",");
                        $scope.swAddSkuPriceModalLauncher.sku = this.$hibachi.populateEntity('Sku',skuData);
                        $scope.swAddSkuPriceModalLauncher.skuPrice = this.$hibachi.newEntity('SkuPrice');
                        $scope.swAddSkuPriceModalLauncher.skuPrice.$$setSku($scope.swAddSkuPriceModalLauncher.sku);
                    }
                } else{ 
                    throw("swAddSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
                } 
                var listingScope = this.scopeService.locateParentScope($scope, "swMultiListingDisplay");
                if(angular.isDefined(listingScope.swMultiListingDisplay)){ 
                    $scope.swAddSkuPriceModalLauncher.listingID = listingScope.swMultiListingDisplay.tableID;
                }
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {

            }
        };
    }
}
export{
    SWAddSkuPriceModalLauncher,
    SWAddSkuPriceModalLauncherController
}
