/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuPriceEditController{

    public skuId:string;
    public skuPriceId:string;
    public minQuantity:string;
    public maxQuantity:string;
    public skuCode:string;
    public price:string;
    public priceGroup:any;
    public priceGroupId:string;
    public currencyFilter:any;
    public currencyCode:string;
    public eligibleCurrencyCodeList:string;
    public filterOnCurrencyCode:string;
    public bundledSkuSkuId:string;
    public bundledSkuCurrencyCode:string;
    public bundledSkuPrice:string;
    public formName:string;
    public showSave:boolean=true;
    public baseEntityId:string;
    public baseEntityName:string="Product";
    public listingDisplayId:string;
    public masterPriceObject:any;
    public revertToValue:any;

    public sku:any;
    public skuPrice:any;
    public pageRecord:any;
    public pageRecordIndex;

    public showPriceEdit:boolean;
    public showSwitchTabContextButton:boolean;
    public switchTabContextEventName:string;
    public selectCurrencyCodeEventName:string;
    public tabToSwitchTo:string;

    //@ngInject
    constructor(
        private historyService,
        private listingService,
        private observerService,
        private skuPriceService,
        private utilityService,
        private $hibachi,
        private $filter,
        private $timeout
    ){
        
        if(angular.isDefined(this.pageRecord)){
            this.pageRecord.edited = false;
        }
        this.currencyFilter = this.$filter('swcurrency');
        this.formName = this.utilityService.createID(32);
        if(angular.isUndefined(this.showPriceEdit)){
            this.showPriceEdit=true;
        }
        if(angular.isUndefined(this.skuId) && angular.isDefined(this.bundledSkuSkuId)){
            this.skuId = this.bundledSkuSkuId;
        }
        if(angular.isDefined(this.bundledSkuCurrencyCode)){
            this.currencyCode = this.bundledSkuCurrencyCode;
        }
        if(angular.isUndefined(this.currencyCode) && angular.isDefined(this.sku)){
            this.currencyCode = this.sku.data.currencyCode;
        }
        if(angular.isUndefined(this.currencyCode) && angular.isDefined(this.skuPrice)){
            this.currencyCode = this.skuPrice.data.currencyCode;
        }
        if(angular.isUndefined(this.price) && angular.isDefined(this.bundledSkuPrice)){
            this.price = this.bundledSkuPrice;
        }
        if(angular.isDefined(this.sku)){
            this.sku.data.price =  this.currencyFilter(this.sku.data.price, this.currencyCode, 2, false);
        }
        if(angular.isDefined(this.skuPrice)){
            this.skuPrice.data.price = this.currencyFilter(this.skuPrice.data.price, this.currencyCode, 2, false);
        }

        if(angular.isUndefined(this.skuId)
            && angular.isUndefined(this.sku)
            && angular.isUndefined(this.skuPriceId)
            && angular.isUndefined(this.skuPrice)
        ){
            throw("You must provide either a skuID or a skuPriceID or a sku or a skuPrice to SWSkuPriceSingleEditController");
        } else {
            if(angular.isDefined(this.skuId) && angular.isUndefined(this.sku)){
                var skuData = {
                    skuID : this.skuId,
                    skuCode : this.skuCode,
                    currencyCode : this.currencyCode,
                    price : this.currencyFilter(this.price, this.currencyCode, 2, false)
                }
                this.sku = this.$hibachi.populateEntity("Sku", skuData);
            }

            if(angular.isDefined(this.skuPriceId) && angular.isUndefined(this.skuPrice)){
                var skuPriceData = {
                    skuPriceId:this.skuPriceId,
                    currencyCode : this.currencyCode,
                    minQuantity:this.minQuantity,
                    maxQuantity:this.maxQuantity,
                    price: this.currencyFilter(this.price, this.currencyCode, 2, false)
                }
                this.skuPrice = this.$hibachi.populateEntity("SkuPrice", skuPriceData);
                this.priceGroup = this.$hibachi.populateEntity('PriceGroup',{priceGroupID:this.priceGroupId});
                this.skuPrice.$$setPriceGroup(this.priceGroup);
            }
        }
        if(angular.isDefined(this.masterPriceObject)){
            if(angular.isDefined(this.masterPriceObject.data.sku)){
                var sku = this.masterPriceObject.data.sku;
            } else {
                var sku = this.masterPriceObject;
            }
            this.revertToValue =  this.currencyFilter(this.skuPriceService.getInferredSkuPrice(sku, this.masterPriceObject.data.price, this.currencyCode),this.currencyCode,2,false);
        }
    }

    public updateDisplay = (currencyCode) =>{
        if(angular.isDefined(currencyCode) && angular.isDefined(this.currencyCode)){
            this.filterOnCurrencyCode = currencyCode;
            if(
                this.currencyCode ==  this.filterOnCurrencyCode ||  this.filterOnCurrencyCode == "All"
            ){
                this.showPriceEdit = true;
            } else {
                this.showPriceEdit = false;
            }
        }
    }

    public switchTabContext = () => {
        this.observerService.notify(this.switchTabContextEventName, this.tabToSwitchTo);
    }
}

class SWSkuPriceEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {};
    public bindToController = {
        skuId:"@?",
        skuPriceId:"@?",
        skuCode:"@?",
        price:"@?",
        priceGroupId:"@?",
        baseEntityId:"@?",
        baseEntityName:"@?",
        bundledSkuSkuId:"@?",
        bundledSkuCurrencyCode:"@?",
        bundledSkuPrice:"@?",
        eligibleCurrencyCodeList:"@?",
        listingDisplayId:"@?",
        currencyCode:"@?",
        masterPriceObject:"=?",
        revertToValue:"=?",
        sku:"=?",
        skuPrice:"=?"
    };
    public controller = SWSkuPriceEditController;
    public controllerAs="swSkuPriceEdit";


    public static Factory(){
        var directive = (
            observerService,
            historyService,
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuPriceEdit(
            observerService,
            historyService,
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            'observerService',
            'historyService',
            'scopeService',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        private observerService,
        private historyService,
        private scopeService,
		skuPartialsPath,
	    slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skupriceedit.html";
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any, transcludeFn:ng.ITranscludeFunction) =>{

        var currentScope = this.scopeService.getRootParentScope(scope, "pageRecord");
        if(angular.isDefined(currentScope["pageRecord"])){
            scope.swSkuPriceEdit.pageRecord = currentScope["pageRecord"];

        }
        var currentScope = this.scopeService.getRootParentScope(scope, "pageRecordKey");
        if(angular.isDefined(currentScope["pageRecordKey"])){
             scope.swSkuPriceEdit.pageRecordIndex = currentScope["pageRecordKey"];
        }
        
        var skuPricesEditScope = this.scopeService.getRootParentScope(scope, "swSkuPricesEdit");
        
        if(skuPricesEditScope != null){
            scope.swSkuPriceEdit.baseEntityId = skuPricesEditScope["swSkuPricesEdit"].baseEntityId;
            scope.swSkuPriceEdit.baseEntityName = skuPricesEditScope["swSkuPricesEdit"].baseEntityName;
        }
        if( angular.isDefined( scope.swSkuPriceEdit.baseEntityId) && angular.isUndefined( scope.swSkuPriceEdit.skuId)){
             scope.swSkuPriceEdit.selectCurrencyCodeEventName = "currencyCodeSelect" +  scope.swSkuPriceEdit.baseEntityId;
            this.observerService.attach( scope.swSkuPriceEdit.updateDisplay,  scope.swSkuPriceEdit.selectCurrencyCodeEventName,  scope.swSkuPriceEdit.formName);
            if(this.historyService.hasHistory(scope.swSkuPriceEdit.selectCurrencyCodeEventName)){
                scope.swSkuPriceEdit.updateDisplay(this.historyService.getHistory(scope.swSkuPriceEdit.selectCurrencyCodeEventName));
            }
        }

        var tabGroupScope = this.scopeService.getRootParentScope(scope,"swTabGroup");
        var tabContentScope = this.scopeService.getRootParentScope(scope,"swTabContent");
        if(tabContentScope != null){
            if(angular.isDefined(tabGroupScope) && tabContentScope["swTabContent"].name == "Basic"){
                scope.swSkuPriceEdit.switchTabContextEventName = tabGroupScope["swTabGroup"].switchTabEventName;
                scope.swSkuPriceEdit.tabToSwitchTo = tabGroupScope["swTabGroup"].getTabByName("Pricing");
                scope.swSkuPriceEdit.showSwitchTabContextButton = true;
            } else {
                scope.swSkuPriceEdit.showSwitchTabContextButton = false;
            }
        }
	}
}
export{
    SWSkuPriceEdit,
    SWSkuPriceEditController
}
