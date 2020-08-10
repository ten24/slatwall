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
                this.setSelectedSku(this.skuOptions[0]);
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

    public initData = () =>{
        //these are populated in the link function initially
        this.skuPrice = this.skuPriceService.newSkuPrice();
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
        this.sku = this.$hibachi.populateEntity('Sku', skuData);
        this.submittedSku = { skuID : skuData['skuID'] };
    } 
    
    public save = () => {
        this.observerService.notify("updateBindings");
        var savePromise = this.skuPrice.$$save();
      
        savePromise.then(
            (response)=>{
               this.saveSuccess = true; 
               //hack, for whatever reason is not responding to getCollection event
                this.observerService.notifyById('swPaginationAction', this.listingID, { type: 'setCurrentPage', payload: 1 });
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
                this.listingService.notifyListingPageRecordsUpdate(this.listingID);
            }
        });
        return savePromise; 
    }
}

class SWAddSkuPriceModalLauncher implements ng.IDirective{
    public template = require("./addskupricemodallauncher.html");
    public restrict = 'EA';
    public transclude = true; 
    
    public scope = {};
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
        return () => new this();
    }
}
export{
    SWAddSkuPriceModalLauncher,
    SWAddSkuPriceModalLauncherController
}
