/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWEditSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public sku:any;
    public priceGroup:any;
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
    public priceGroupId:string;
    
    //@ngInject
    constructor(
        private $hibachi,
        private entityService,
        private formService,
        private listingService,
        private observerService, 
        private skuPriceService,
        private utilityService,
        private scopeService,
        private $scope
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.formName = "editSkuPrice" + this.utilityService.createID(16);
        //have to do our setup here because there is no direct way to pass the pageRecord into this transcluded directive
        let currentScope = this.scopeService.getRootParentScope($scope, "pageRecord");
        if(angular.isDefined(currentScope.pageRecord)){ 
            this.pageRecord = currentScope.pageRecord;
            //sku record case
            if(angular.isDefined(currentScope.pageRecord["sku_skuID"]) && angular.isDefined(currentScope.pageRecord.skuPriceID) && currentScope.pageRecord.skuPriceID.length){    
                let skuData = {
                    skuID:currentScope.pageRecord["sku_skuID"],
                    skuCode:currentScope.pageRecord["sku_skuCode"],
                    calculatedSkuDefinition:currentScope.pageRecord["sku_calculatedSkuDefinition"]
                }
                
                let skuPriceData = {
                    skuPriceID:currentScope.pageRecord.skuPriceID,
                    minQuantity:currentScope.pageRecord.minQuantity,
                    maxQuantity:currentScope.pageRecord.maxQuantity,
                    currencyCode:currentScope.pageRecord.currencyCode, 
                    price:currentScope.pageRecord.price
                }
                
                let priceGroupData = {
                    priceGroupID:currentScope.pageRecord["priceGroup_priceGroupID"],
                    priceGroupCode:currentScope.pageRecord["priceGroup_priceGroupCode"]
                }
                
                this.sku = this.$hibachi.populateEntity('Sku',skuData);
                this.skuPrice = this.$hibachi.populateEntity('SkuPrice',skuPriceData);
                this.priceGroup = this.$hibachi.populateEntity('PriceGroup',priceGroupData);
                this.skuPrice.$$setPriceGroup(this.priceGroup);
                this.skuPrice.$$setSku(this.sku);
                this.currencyCodeOptions = ["USD"]; //hard-coded for now
            } else {
                return;
            }
        } else{ 
            throw("swEditSkuPriceModalLauncher was unable to find the pageRecord that it needs!");
        } 
        let listingScope = this.scopeService.getRootParentScope($scope, "swListingDisplay");
        if(angular.isDefined(listingScope.swListingDisplay)){ 
            this.listingID = listingScope.swListingDisplay.tableID;
            this.selectCurrencyCodeEventName = "currencyCodeSelect" + listingScope.swListingDisplay.baseEntityId; 
            this.defaultCurrencyOnly = true;
            this.observerService.attach(this.updateCurrencyCodeSelector, this.selectCurrencyCodeEventName);
        } else {
            throw("swEditSkuPriceModalLauncher couldn't find listing scope");
        }
         this.initData();
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
        if(angular.isDefined(this.priceGroupId)){
            this.skuPrice.data.priceGroup.data.priceGroupId = parseInt(this.priceGroupId); 
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
        this.observerService.notify("pullBindings");
    }
    
    public save = () => {
        this.observerService.notify("updateBindings");
        var firstSkuPriceForSku = !this.skuPriceService.hasSkuPrices(this.sku.data.skuID);
        var savePromise = this.skuPrice.$$save();
      
        savePromise.then(
            (response)=>{ 
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
                                //let's find and update the sku price
                                if(pageRecords[index].skuPriceID === this.skuPrice.skuPriceID){
                                    this.skuPrice.data.eligibleCurrencyCodeList = this.currencyCodeOptions.join(",");
                                    //spoof the page record
                                    var skuPriceForListing:any = {}; 
                                    for(var key in this.skuPrice.data){
                                        skuPriceForListing[key] =  this.skuPrice.data[key];
                                    }
                                    skuPriceForListing["sku_skuID"] = this.sku.skuID;
                                    skuPriceForListing["sku_skuCode"] = this.sku.skuCode;
                                    skuPriceForListing["sku_calculatedSkuDefinition"] = this.sku.calculatedSkuDefinition;
                                    skuPriceForListing["priceGroup_priceGroupCode"] = skuPriceForListing.selectedpriceGroup.priceGroupCode;
                                    skuPriceForListing["priceGroup_priceGroupID"] = skuPriceForListing.selectedpriceGroup.priceGroupID;
                                    pageRecords[index] = skuPriceForListing;
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

                if(firstSkuPriceForSku){
                    this.listingService.getCollection(this.listingID); 
                }
                this.listingService.notifyListingPageRecordsUpdate(this.listingID);
            }
        });
        return savePromise; 
    }
}

class SWEditSkuPriceModalLauncher implements ng.IDirective{
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
    public controller = SWEditSkuPriceModalLauncherController;
    public controllerAs="swEditSkuPriceModalLauncher";
   
   
    public static Factory(){
        var directive = (
            $hibachi,
            entityService,
            observerService,
            scopeService,
            collectionConfigService,
            skuPartialsPath,
            slatwallPathBuilder
        )=> new SWEditSkuPriceModalLauncher(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"editskupricemodallauncher.html";
    }
    
    public compile = (element: JQuery, attrs: angular.IAttributes) => {
        return {
            pre: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            },
            post: ($scope: any, element: JQuery, attrs: angular.IAttributes) => {
            }
        };
    }
}
export{
    SWEditSkuPriceModalLauncher,
    SWEditSkuPriceModalLauncherController
}
