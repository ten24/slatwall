/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public sku:any;
    public skuId:string; 
    public skuPrice:any; 
    public baseName:string="j-add-sku-item-"; 
    public formName:string; 
    public minQuantity:string; 
    public maxQuantity:string; 
    public currencyCode:string;
    public defaultCurrencyOnly:boolean;
    public eligibleCurrencyCodeList:string; 
    public uniqueName:string;
    public listingID:string;  
    public disableAllFieldsButPrice:boolean;
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
    }    
    
    public initData = () =>{
        //these are populated in the link function initially
        this.skuPrice.$$setSku(this.sku);
        if(angular.isUndefined(this.disableAllFieldsButPrice)){
            this.disableAllFieldsButPrice = false; 
        }
        if(angular.isUndefined(this.defaultCurrencyOnly)){
            this.defaultCurrencyOnly = false; 
        }
        if(angular.isDefined(this.minQuantity) && !isNaN(parseInt(this.minQuantity))){
            this.skuPrice.data.minQuantity = parseInt(this.minQuantity);
        }
        if(angular.isDefined(this.maxQuantity) && !isNaN(parseInt(this.minQuantity))){
            this.skuPrice.data.maxQuantity = parseInt(this.maxQuantity); 
        }
        if(angular.isUndefined(this.currencyCodeOptions) && angular.isDefined(this.eligibleCurrencyCodeList)){
            this.currencyCodeOptions = this.eligibleCurrencyCodeList.split(",");
        }
        if(this.defaultCurrencyOnly){
            this.skuPrice.data.currencyCode = "USD" //temporarily hardcoded
        } else if(angular.isDefined(this.currencyCode)){
            this.skuPrice.data.currencyCode = this.currencyCode; 
        } else if(angular.isDefined(this.currencyCodeOptions) && this.currencyCodeOptions.length){
            this.skuPrice.data.currencyCode = this.currencyCodeOptions[0]; 
        }
        console.log("thissku",this.sku);
    }
    
    public save = () => {
        var firstSkuPriceForSku = !this.skuPriceService.hasSkuPrices(this.sku.data.skuID);
        var savePromise = this.skuPrice.$$save();
        savePromise.then(
            (response)=>{ 
               this.observerService.notify('skuPricesUpdate',{skuID:this.sku.data.skuID,refresh:true});
                //temporarily overriding for USD need to get this setting accessable to client side
                if( angular.isDefined(this.listingID) && 
                    this.skuPrice.data.currencyCode=="USD"
                ){
                   var pageRecords = this.listingService.getListingPageRecords(this.listingID);
                   for(var i=0; i < pageRecords.length; i++){
                        if( angular.isDefined(pageRecords[i].skuID) &&
                            pageRecords[i].skuID == this.sku.data.skuID
                        ){
                            var index = i + 1; 
                            while(index < pageRecords.length && angular.isUndefined(pageRecords[index].skuID)){
                                //if there is a place in the listing to insert the new sku price lets insert it
                                if( ( 
                                        pageRecords[index].minQuantity <= this.skuPrice.data.minQuantity &&
                                        index + 1 < pageRecords.length && (
                                        pageRecords[index+1].minQuantity >= this.skuPrice.data.minQuantity ||
                                        angular.isDefined(pageRecords[index+1].skuID) ) 
                                    ) || 
                                    index + 1 == pageRecords.length
                                ){
                                    this.skuPrice.data.skuSkuId = this.skuId;
                                    this.skuPrice.data.eligibleCurrencyCodeList = this.currencyCodeOptions.join(",");
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
            if(firstSkuPriceForSku){
                this.listingService.getCollection(this.listingID); 
            }
        });
        return savePromise; 
    }
}

class SWAddSkuPriceModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public transclude = true; 
    public bindToController = {
        sku:"=?",
        pageRecord:"=?",
        minQuantity:"@?",
        maxQuantity:"@?",
        currencyCode:"@?",
        eligibleCurrencyCodeList:"@?",
        defaultCurrencyOnly:"=?",
        disableAllFieldsButPrice:"=?"
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
                    //sku record case
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
                 $scope.swAddSkuPriceModalLauncher.initData();
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
