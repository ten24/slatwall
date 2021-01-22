class SWSkuPriceModalController{
    
    public productId:string;
    public promotionRewardId:string;
    public pageRecord:any; 
    public sku:any;
    public promotionReward:any;
    public skuOptions:any;
    public submittedSku:any;
    public selectedSku:any;
    public skuCollectionConfig:any;
    public priceGroup:any;
    public skuId:string; 
    public compoundSkuName:string; 
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
        public collectionConfigService,
        public scopeService,
        public $scope,
        public $timeout,
        public requestService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.formName = "skuPriceForm" + this.utilityService.createID(16);
        if(angular.isDefined(this.productId)){
            this.skuCollectionConfig = this.skuPriceService.getSkuCollectionConfig(this.productId);
        } else if (angular.isDefined(this.promotionRewardId)){
            var collectionConfigStruct = angular.fromJson(this.skuCollectionConfig);
            $timeout(()=>{
                this.skuCollectionConfig = this.collectionConfigService.newCollectionConfig().loadJson(collectionConfigStruct);
            });
        }
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
        this.observerService.attach(this.initData, "EDIT_SKUPRICE");
        this.observerService.attach(this.inlineSave, "SAVE_SKUPRICE");
        this.observerService.attach(this.deleteSkuPrice, "DELETE_SKUPRICE");
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
    
     public inlineSave = (pageRecord:any) =>{
        this.initData(pageRecord);
        
        var formDataToPost:any = {
			entityName: 'SkuPrice',
			entityID : pageRecord['skuPriceID'],
			context: 'save',
			propertyIdentifiersList: ''
		};
		
		for(var key in pageRecord){
        if(key.indexOf("$") > -1 || key.indexOf("skuPriceID") > -1){
		        continue;
		    } else if(key.indexOf("_") > -1){
		        if(key.indexOf("ID") == -1){
		            continue;
		        }
		        var property = key.split("_");
		        formDataToPost[property[0]] = { };
		        formDataToPost[property[0]][property[1]] = pageRecord[key];
		          
		    } else {
		        formDataToPost[key] = pageRecord[key];
		    }
		}
		
		
		var processUrl = this.$hibachi.buildUrl('api:main.post');
		
		var adminRequest = this.requestService.newAdminRequest(processUrl, formDataToPost);
		
		return adminRequest.promise.then(
		    (response)=>{
		        this.listingService.notifyListingPageRecordsUpdate(this.listingID);
		        this.observerService.notifyById("rowSaved", this.pageRecord.$$hashKey, this.pageRecord);
		    });
    }

    public initData (pageRecord?:any) {
        this.pageRecord = pageRecord;
        
        if(pageRecord){
           let skuPriceData = {
                skuPriceID : pageRecord.skuPriceID,
                minQuantity : pageRecord.minQuantity,
                maxQuantity : pageRecord.maxQuantity,
                currencyCode : pageRecord.currencyCode, 
                price : pageRecord.price,
                listPrice : pageRecord.listPrice
            } 
            
            let skuData = {
                skuID : pageRecord["sku_skuID"],
                skuCode : pageRecord["sku_skuCode"],
                calculatedSkuDefinition : pageRecord["sku_calculatedSkuDefinition"],
                skuName : pageRecord["sku_skuName"],
                imagePath : pageRecord["sku_imagePath"]
            }
            
            let promotionRewardData = {
                promotionRewardID : pageRecord['promotionRewardID']
            }
            
            let priceGroupData = {
                priceGroupID : pageRecord["priceGroup_priceGroupID"],
                priceGroupCode : pageRecord["priceGroup_priceGroupCode"]
            }
            //reference to form is being wiped
            if(this.skuPrice){
                var skuPriceForms = this.skuPrice.forms;
            }
            this.skuPrice = this.$hibachi.populateEntity('SkuPrice', skuPriceData);
            if(skuPriceForms){
                this.skuPrice.forms=skuPriceForms;
            }
            
            if(this.sku){
                var skuForms = this.sku.forms;
            }
            this.sku = this.$hibachi.populateEntity('Sku', skuData);
            if(skuForms){
                this.skuPrice.forms=skuForms;
            }
            
            this.setCoumpoundSkuName(skuData);
            
            if(this.promotionReward){
                var promotionRewardForms = this.promotionReward.forms;
            }
            this.promotionReward = this.$hibachi.populateEntity('PromotionReward', promotionRewardData);
            if(promotionRewardForms){
                this.promotionReward.forms=promotionRewardForms;
            }
            
            if(this.priceGroup){
                var priceGroupForms = this.priceGroup.forms;
            }
            this.priceGroup = this.$hibachi.populateEntity('PriceGroup',priceGroupData);
            if(priceGroupForms){
                this.priceGroup.forms=priceGroupForms;
            }
            
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
                        console.log(this.selectedPriceGroup);
                    }
                }
                this.priceGroupEditable = false;
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
            this.skuPrice.$$setPromotionReward(this.promotionReward);
            
        } else {
            //reference to form is being wiped
            if(this.skuPrice){
                var skuPriceForms = this.skuPrice.forms;
            }
            this.skuPrice = this.skuPriceService.newSkuPrice();
            if(skuPriceForms){
                this.skuPrice.forms=skuPriceForms;
            }
            
            if(this.promotionRewardId){
                if(this.promotionReward){
                    var promotionRewardForms = this.promotionReward.forms;
                }
                this.promotionReward = this.$hibachi.populateEntity('PromotionReward', {promotionRewardID : this.promotionRewardId});
                if(promotionRewardForms){
                    this.promotionReward.forms=promotionRewardForms;
                }
                this.skuPrice.$$setPromotionReward(this.promotionReward);
            }
            
            
            
            this.skuPriceService.getSkuOptions(this.productId).then(
                (response)=>{
                     this.skuOptions = [];
                     console.log("response", response);
                    for(var i=0; i<response.records.length; i++){
                         this.skuOptions.push({skuName : response.records[i]['skuName'], skuCode : response.records[i]['skuCode'], skuID : response.records[i]['skuID']});
                    }
                }
            ).finally(()=>{ 
                
                if(angular.isDefined(this.skuOptions) && this.skuOptions.length == 1){
                    this.setSelectedSku(this.skuOptions[0]);
                } else {
                    this.setCoumpoundSkuName("");
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
                        this.currencyCodeOptions.unshift("- Select Currency Code -");
                        
                        this.selectedCurrencyCode = this.currencyCodeOptions[0];
                    }
                }
            );
        }
    }
    
    public setSelectedPriceGroup = (priceGroupData) =>{
        
        if(!priceGroupData.priceGroupID){
            this.submittedPriceGroup = {};
            return;
        }
        this.submittedPriceGroup = { priceGroupID : priceGroupData['priceGroupID'] };
    }
    
    public setSelectedSku = (skuData) =>{
        if(!angular.isDefined(skuData['skuID'])){
            return;
        }
        
        this.selectedSku = { skuName : skuData['skuName'], skuCode : skuData['skuCode'], skuID : skuData['skuID'] };
        this.sku = this.$hibachi.populateEntity('Sku', skuData);
        this.submittedSku = { skuID : skuData['skuID'] };
        this.setCoumpoundSkuName(skuData);
    }
    
    public setCoumpoundSkuName = (skuData:any) =>{
        this.compoundSkuName = "";
        if(skuData['skuName']){
            this.compoundSkuName += skuData['skuName'];
        }
        
        if(this.compoundSkuName.length){
            this.compoundSkuName += " - ";
        }
        
        if(skuData['skuCode']){
            this.compoundSkuName += skuData['skuCode'];
        }
    }
    
    public isDefaultSkuPrice = ():boolean =>{
        if(this.pageRecord){
            if( (this.skuPrice.sku.currencyCode == this.skuPrice.currencyCode) &&
                !this.skuPrice.minQuantity.trim() &&
                !this.skuPrice.maxQuantity.trim() &&
                (!this.skuPrice.priceGroup.priceGroupID || !this.skuPrice.priceGroup.priceGroupID.trim()) &&
                this.skuPrice.price){
                
                return true;
            }
        }
        
        return false;
    }
    
    public $onDestroy = ()=>{
		this.observerService.detachByEvent('EDIT_SKUPRICE');
		this.observerService.detachByEvent('SAVE_SKUPRICE');
	}
	
	public deleteSkuPrice = (pageRecord:any)=>{
        
        var skuPriceData = {
            skuPriceID : pageRecord.skuPriceID,
            minQuantity : pageRecord.minQuantity,
            maxQuantity : pageRecord.maxQuantity,
            currencyCode : pageRecord.currencyCode, 
            price : pageRecord.price
        }
        
        var skuPrice = this.$hibachi.populateEntity('SkuPrice', skuPriceData);
        
        var deletePromise = skuPrice.$$delete();
        
        deletePromise.then(
            (resolve)=>{
                //hack, for whatever reason is not responding to getCollection event
                this.observerService.notifyById('swPaginationAction', this.listingID, { type: 'setCurrentPage', payload: 1 });
            },
            (reason)=>{
                console.log("Could not delete Sku Price Because: ", reason);
            }
        );
        
        return deletePromise;
	}
    
    public save = () => {
        this.observerService.notify("updateBindings");
        if(this.pageRecord && this.submittedPriceGroup){
            this.priceGroup.priceGroupID = this.submittedPriceGroup.priceGroupID;
            this.priceGroup.priceGroupCode = this.submittedPriceGroup.priceGroupCode;
        }
        
        var form = this.formService.getForm(this.formName);
        
        var savePromise = this.skuPrice.$$save();
      
        savePromise.then(
            (response)=>{ 
              this.saveSuccess = true; 
              this.observerService.notify('skuPricesUpdate',{skuID:this.sku.data.skuID,refresh:true});
              //hack, for whatever reason is not responding to getCollection event
                this.observerService.notifyById('swPaginationAction', this.listingID, { type: 'setCurrentPage', payload: 1 });
                this.formService.resetForm(form);
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
                this.selectedSku = {};
                this.submittedSku = {};
                this.formService.resetForm(form);
                
                this.listingService.getCollection(this.listingID); 
                
                this.listingService.notifyListingPageRecordsUpdate(this.listingID);
            }
        });
        return savePromise; 
    }
}

class SWSkuPriceModal implements ng.IDirective{
    public template = require("./skupricemodal.html");;
    public transclude = true; 
    public restrict = 'EA';
    
    public require = {
        ngForm : '?ngForm'
    }
    public scope = {}; 
    
    public bindToController = {
        sku:"=?",
        pageRecord:"=?",
        productId:"@?",
        promotionRewardId:"@?",
        minQuantity:"@?",
        maxQuantity:"@?",
        priceGroupId:"@?",
        currencyCode:"@?",
        eligibleCurrencyCodeList:"@?",
        defaultCurrencyOnly:"=?",
        skuCollectionConfig:"@?",
        disableAllFieldsButPrice:"=?"
    };
    public controller = SWSkuPriceModalController;
    public controllerAs="swSkuPriceModal";
   
   
    public static Factory(){
        return () => new this();
    }

}
export{
    SWSkuPriceModal,
    SWSkuPriceModalController
}
