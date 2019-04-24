/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var skuPriceModalLauncherHTML = require("html-loader!sku/components/addskupricemodallauncher");

class SWAddSkuPriceModalLauncherController{
    
    public pageRecord:any;
    public productId:string;
    public sku:any;
    public skuOptions:any;
    public selectedSku:any;
    public submittedSku:any;
    public priceGroup:any;
    public priceGroupOptions:any;
    public selectedPriceGroup:any;
    public submittedPriceGroup:any;
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
    public currencyCodeOptions = []; 
    public selectedCurrencyCode; 
    public saveSuccess:boolean=true; 
    public imagePath:string; 
    public selectCurrencyCodeEventName:string; 
    public skuCollectionConfig; 

    //@ngInject
    constructor(
        private $hibachi,
        private entityService,
        private formService,
        private listingService,
        private observerService, 
        private skuPriceService,
        private utilityService,
        private $timeout
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.formName = "addSkuPrice" + this.utilityService.createID(16);
        this.skuCollectionConfig = this.skuPriceService.getSkuCollectionConfig(this.productId);
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
        
        this.skuPriceService.getSkuOptions(this.productId).then(
            (response)=>{
                 this.skuOptions = [];
                for(var i=0; i<response.records.length; i++){
                     this.skuOptions.push({skuCode : response.records[i]['skuCode'], skuID : response.records[i]['skuID']});
                }
            }
        ).finally(()=>{ 
            
            if(angular.isDefined(this.skuOptions) && this.skuOptions.length){
                this.selectedSku = this.skuOptions[0];
                this.submittedSku = { skuId : this.selectedSku['skuID']};
            }
        }); 
        
        this.skuPriceService.getPriceGroupOptions().then(
            (response)=>{
                this.priceGroupOptions = response.records;
                this.priceGroupOptions.unshift({priceGroupName : "- Select Price Group -", priceGroupID : ""})
            }    
        ).finally(()=>{ 
            if(angular.isDefined(this.priceGroupOptions) && this.priceGroupOptions.length){
                this.selectedPriceGroup = this.priceGroupOptions[0];
            }
        });
        
        this.skuPriceService.getCurrencyOptions().then(
            (response)=>{
                if(response.records.length){    
                    for(var i=0; i<response.records.length; i++){
                        this.currencyCodeOptions.push(response.records[i]['currencyCode']);
                    }
                    this.currencyCodeOptions.unshift("- Select Currency Code -");
                    
                    this.selectedCurrencyCode = this.currencyCodeOptions[0];
                }
            }
        );
        
        
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

    public initData = (pageRecord?:any) =>{
        //these are populated in the link function initially
        this.skuPrice = this.skuPriceService.newSkuPrice();

        this.pageRecord = pageRecord;
        
        if(angular.isDefined(pageRecord)){
           let skuPriceData = {
                skuPriceID : pageRecord.skuPriceID,
                minQuantity : pageRecord.minQuantity,
                maxQuantity : pageRecord.maxQuantity,
                currencyCode : pageRecord.currencyCode, 
                price : pageRecord.price
            } 
            
            let skuData = {
                skuID : pageRecord["sku_skuID"],
                skuCode : pageRecord["sku_skuCode"],
                calculatedSkuDefinition : pageRecord["sku_calculatedSkuDefinition"]
            }
            
            let priceGroupData = {
                priceGroupID : pageRecord["priceGroup_priceGroupID"],
                priceGroupCode : pageRecord["priceGroup_priceGroupCode"]
            }
            
            this.skuPrice = this.$hibachi.populateEntity('SkuPrice', skuPriceData);
            this.priceGroup = this.$hibachi.populateEntity('PriceGroup',priceGroupData);
            this.skuPrice.$$setPriceGroup(this.priceGroup);
            this.currencyCodeOptions = ["USD"];
            
            this.skuPrice.data.minQuantity = pageRecord.minQuantity;
            this.skuPrice.data.maxQuantity = pageRecord.maxQuantity;
            this.skuPrice.data.priceGroup.data.priceGroupId = pageRecord["priceGroup_priceGroupID"];
        } else {
            return;
        }
        
        this.observerService.notify("pullBindings");
    }
    
    public setSelectedPriceGroup = (priceGroupData) =>{
        if(!angular.isDefined(priceGroupData.priceGroupID)){
            this.submittedPriceGroup = {};
            return;
        }
        this.submittedPriceGroup = { priceGroupID : priceGroupData['priceGroupID'] };
    }
    
    public setSelectedSku = (skuData) =>{
        if(!angular.isDefined(skuData['skuID'])){
            return;
        }
       
        this.selectedSku = { skuCode : skuData['skuCode'], skuID : skuData['skuID'] };
        this.submittedSku = { skuID : skuData['skuID'] };
    } 
    
    public save = () => {
        this.observerService.notify("updateBindings");
        // var firstSkuPriceForSku = !this.skuPriceService.hasSkuPrices(this.sku.data.skuID);
        var savePromise = this.skuPrice.$$save();
      
        savePromise.then(
            (response)=>{
               this.saveSuccess = true; 
               //hack, for whatever reason is not responding to getCollection event
                this.observerService.notifyById('swPaginationAction', this.listingID, { type: 'setCurrentPage', payload: 1 });
            },
            (reason)=>{
                //error callback
                console.log(reason);
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
    public template;
    public restrict = 'EA';
    public scope = {}; 
    public skuData = {}; 
    public imagePathToUse;
    public transclude = true; 
    public bindToController = {
        sku:"=?",
        pageRecord:"=?",
        productId:"@?",
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
        this.template = skuPriceModalLauncherHTML;
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
    SWAddSkuPriceModalLauncher,
    SWAddSkuPriceModalLauncherController
}
