/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
var swEditSkuPriceModalLauncherHTML = require("html-loader!sku/components/editskupricemodallauncher");

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
    public priceGroupEditable:boolean=false; 
    public currencyCodeOptions = []; 
    public selectedCurrencyCode; 
    public priceGroupOptions; 
    public selectedPriceGroup:{};
    public submittedPriceGroup:any;
    public saveSuccess:boolean=true; 
    public imagePath:string; 
    public selectCurrencyCodeEventName:string; 
    public priceGroupId:string;
    

    //@ngInject
    constructor(
        public $hibachi,
        public entityService,
        public formService,
        public listingService,
        public observerService, 
        public skuPriceService,
        public utilityService,
        public scopeService,
        public $scope
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.formName = "editSkuPrice" + this.utilityService.createID(16);
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
        this.observerService.attach(this.initData, "EDIT_SKUPRICE");
        
        // this.initData();
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
            this.sku = this.$hibachi.populateEntity('Sku', skuData);
            this.priceGroup = this.$hibachi.populateEntity('PriceGroup',priceGroupData);
            
            this.skuPriceService.getPriceGroupOptions().then(
                (response)=>{
                    this.priceGroupOptions = response.records;
                    this.priceGroupOptions.unshift({priceGroupName : "- Select Price Group -", priceGroupID : ""});
                }    
            ).finally(()=>{
                
                this.selectedPriceGroup = this.priceGroupOptions[0];
                for(var i=0; i<this.priceGroupOptions.length; i++){
                    if(this.pageRecord['priceGroup_priceGroupID'] == this.priceGroupOptions[i].priceGroupID){
                        this.selectedPriceGroup = this.priceGroupOptions[i];
                    }
                }
                
                if(!this.selectedPriceGroup['priceGroupID']){
                    this.priceGroupEditable = true;
                }
            });
            
            this.skuPriceService.getCurrencyOptions().then(
                (response)=>{
                    if(response.records.length){
                        this.currencyCodeOptions = [];
                        for(var i=0; i<response.records.length; i++){
                            this.currencyCodeOptions.push(response.records[i]['currencyCode']);
                        }
                        this.currencyCodeOptions.unshift("- Select Currency Code -")
                        
                        this.selectedCurrencyCode = this.currencyCodeOptions[0];
                        for(var i=0; i<this.currencyCodeOptions.length; i++){
                            if(this.pageRecord['currencyCode'] == this.currencyCodeOptions[i]){
                                this.selectedCurrencyCode = this.currencyCodeOptions[i];
                            }
                        }
                    }
                }
            );
            
            this.skuPrice.$$setPriceGroup(this.priceGroup);
            this.skuPrice.$$setSku(this.sku);
            
        } else {
            return;
        }
        
        this.observerService.notify("pullBindings");
    }
    
    public setSelectedPriceGroup = (priceGroupData) =>{
        if(!priceGroupData.priceGroupID){
            this.submittedPriceGroup = {};
            return;
        }
        this.submittedPriceGroup = { priceGroupID : priceGroupData['priceGroupID'] };
    }
    
    public $onDestroy = ()=>{
        console.log("$onDestroy called");
		this.observerService.detachByEvent('EDIT_SKUPRICE');
	}
    
    public save = () => {
        this.observerService.notify("updateBindings");
        var firstSkuPriceForSku = !this.skuPriceService.hasSkuPrices(this.sku.data.skuID);
        var savePromise = this.skuPrice.$$save();
      
        savePromise.then(
            (response)=>{ 
               this.saveSuccess = true; 
               this.observerService.notify('skuPricesUpdate',{skuID:this.sku.data.skuID,refresh:true});
               //hack, for whatever reason is not responding to getCollection event
                this.observerService.notifyById('swPaginationAction', this.listingID, { type: 'setCurrentPage', payload: 1 });
            },
            (reason)=>{
                //error callback
                console.log("validation failed because: ", reason);
                this.saveSuccess = false; 
            }
        ).finally(()=>{       
            if(this.saveSuccess){
                
                for(var key in this.skuPrice.data){
                    if (key != 'sku' && key !='currencyCode'){
                        this.skuPrice.data[key] = null;
                    }
                }
                console.log(this.listingID);
                this.formService.resetForm(this.formName);
                this.initData();
                
                this.listingService.getCollection(this.listingID); 
                
                this.listingService.notifyListingPageRecordsUpdate(this.listingID);
                
            }
        });
        return savePromise; 
    }
}

class SWEditSkuPriceModalLauncher implements ng.IDirective{
    public template;
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
        public $hibachi, 
        public entityService,
        public observerService,
        public scopeService, 
        public collectionConfigService, 
        public skuPartialsPath,
        public slatwallPathBuilder
    ){
        this.template = swEditSkuPriceModalLauncherHTML;
        
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
