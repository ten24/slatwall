/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWAddSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public sku:any;
    public priceGroup:any;
    public priceGroupId;String;
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
    public currencyCodeEditable:boolean=false; 
    public currencyCodeOptions; 
    public saveSuccess:boolean=true; 
    public imagePath:string; 
    public selectCurrencyCodeEventName:string; 
    
    //@ngInject
    constructor(
        private $hibachi,
        private entityService,
        private formService,
        private listingService,
        private observerService, 
        private skuPriceService,
        private utilityService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.formName = "addSkuPrice" + this.utilityService.createID(16);
        this.skuPrice = this.entityService.newEntity('SkuPrice'); 
    }    
    
    public updateCurrencyCodeSelector = (args) =>{
        if(args != 'All'){
            this.skuPrice.data.currencyCode = args; 
            this.currencyCodeEditable = false;
        } else {
            this.currencyCodeEditable = true; 
        }
        this.observerService.notify("pullBindings");
    }

    public initData = () =>{
        //these are populated in the link function initially
        this.skuPrice = this.entityService.newEntity('SkuPrice'); 
        this.skuPrice.$$setSku(this.sku);
        this.skuPrice.$$setPriceGroup(this.priceGroup);
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
        
        if(angular.isDefined(this.priceGroupId)){
            this.skuPrice.data.priceGroup_priceGroupID = this.priceGroupId;
        }
        this.observerService.notify("pullBindings");
    }
    
    public save = () => {
        this.observerService.notify("updateBindings");
        var firstSkuPriceForSku = !this.skuPriceService.hasSkuPrices(this.sku.data.skuID);
        var savePromise = this.skuPrice.$$save();
      
        savePromise.then(
            (response)=>{
               if(firstSkuPriceForSku){
                    this.observerService.notifyById('swPaginationAction', this.listingID, { type: 'setCurrentPage', payload: 1 });
               }
               this.saveSuccess = true; 
               this.observerService.notify('skuPricesUpdate',{skuID:this.sku.data.skuID,refresh:true});
                
                //temporarily overriding for USD need to get this setting accessable to client side
                if( angular.isDefined(this.listingID) && 
                    this.skuPrice.data.currencyCode == "USD"
                ){
                   var pageRecords = this.listingService.getListingPageRecords(this.listingID);
                   
                   for(var i=0; i < pageRecords.length; i++){
                        if( angular.isDefined(pageRecords[i].skuID) &&
                            pageRecords[i].skuID == this.sku.data.skuID
                        ){
                            var skuPageRecord = pageRecords[i];
                            var index = i + 1; 
                            while(index < pageRecords.length && angular.isUndefined(pageRecords[index].skuID)){
                                //if there is a place in the listing to insert the new sku price lets insert it
                                if( 
                                    ( pageRecords[index].minQuantity <= this.skuPrice.data.minQuantity ) &&
                                    (   index + 1 < pageRecords.length && (
                                        pageRecords[index+1].minQuantity >= this.skuPrice.data.minQuantity ||
                                        angular.isDefined(pageRecords[index+1].skuID) ) 
                                    ) || index + 1 == pageRecords.length
                                ){
                                    this.skuPrice.data.eligibleCurrencyCodeList = this.currencyCodeOptions.join(",");
                                    //spoof the page record
                                    var skuPriceForListing = {}; 
                                    for(var key in this.skuPrice.data){
                                        skuPriceForListing[key] =  this.skuPrice.data[key];
                                    }
                                    skuPriceForListing["sku_skuID"] = this.sku.skuID;
                                    skuPriceForListing["sku_skuCode"] = this.sku.skuCode;
                                    skuPriceForListing["sku_calculatedSkuDefinition"] = this.sku.calculatedSkuDefinition || pageRecords[index]['sku_calculatedSkuDefinition'];
                                    this.skuPrice.$$getPriceGroup().then((data)=>{
                                        skuPriceForListing["priceGroup_priceGroupID"]=this.skuPrice.priceGroup.priceGroupID;
                                        skuPriceForListing["priceGroup_priceGroupCode"]=this.skuPrice.priceGroup.priceGroupCode;
                                        pageRecords.splice(index+1,0,skuPriceForListing);    
                                    })
                                    ;
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
                this.saveSuccess = false; 
            }
        ).finally(()=>{       
            if(this.saveSuccess){
                
                for(var key in this.skuPrice.data){
                    if (key != 'sku' && key !='currencyCode'){
                        this.skuPrice.data[key] = null;
                    }
                }

                this.formService.resetForm(this.formName);
                this.initData();

                // if(firstSkuPriceForSku){
                //     this.listingService.getCollection(this.listingID); 
                // }
                this.listingService.notifyListingPageRecordsUpdate(this.listingID);
            }
        });
        return savePromise; 
    }
}

class SWAddSkuPriceModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public skuData = {}; 
    public imagePathToUse;
    public transclude = true; 
    public bindToController = {
        sku:"=?",
        pageRecord:"=?",
        minQuantity:"@?",
        maxQuantity:"@?",
        priceGroupId:"@?",
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
            entityService,
            observerService,
            scopeService,
            collectionConfigService,
            skuPartialsPath,
            slatwallPathBuilder
        )=> new SWAddSkuPriceModalLauncher(
            $hibachi, 
            entityService,
            observerService,
            scopeService,
            collectionConfigService,
            skuPartialsPath,
            slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'entityService',
            'observerService',
            'scopeService',
            'collectionConfigService',
            'skuPartialsPath',
            'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        private $hibachi, 
        private entityService,
        private observerService,
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
                var currentScope = this.scopeService.getRootParentScope($scope, "pageRecord");
                if(angular.isDefined(currentScope.pageRecord)){ 
                    $scope.swAddSkuPriceModalLauncher.pageRecord = currentScope.pageRecord;
                    
                    //sku record case
                    if(angular.isDefined(currentScope.pageRecord.skuID)){    

                        var skuData = {
                            skuID:currentScope.pageRecord.skuID,
                            skuCode:currentScope.pageRecord.skuCode,
                            skuDescription:currentScope.pageRecord.skuDescription,
                            eligibleCurrencyCodeList:currentScope.pageRecord.eligibleCurrencyCodeList,
                            imagePath:currentScope.pageRecord.imagePath
                        }
                        
                        $scope.swAddSkuPriceModalLauncher.currencyCodeOptions = currentScope.pageRecord.eligibleCurrencyCodeList.split(",");
                        $scope.swAddSkuPriceModalLauncher.sku = this.$hibachi.populateEntity('Sku',skuData);
                        $scope.swAddSkuPriceModalLauncher.priceGroup = this.$hibachi.newEntity('PriceGroup');
                        $scope.swAddSkuPriceModalLauncher.skuPrice = this.entityService.newEntity('SkuPrice');
                        $scope.swAddSkuPriceModalLauncher.skuPrice.$$setSku($scope.swAddSkuPriceModalLauncher.sku);
                    

                    }
                } else{ 
                    throw("swAddSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
                } 
                var listingScope = this.scopeService.getRootParentScope($scope, "swListingDisplay");
                if(angular.isDefined(listingScope.swListingDisplay)){ 
                    $scope.swAddSkuPriceModalLauncher.listingID = listingScope.swListingDisplay.tableID;
                    $scope.swAddSkuPriceModalLauncher.selectCurrencyCodeEventName = "currencyCodeSelect" + listingScope.swListingDisplay.baseEntityId; 
                    this.observerService.attach($scope.swAddSkuPriceModalLauncher.updateCurrencyCodeSelector, $scope.swAddSkuPriceModalLauncher.selectCurrencyCodeEventName);
                } else {
                    throw("swAddSkuPriceModalLauncher couldn't find listing scope");
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
