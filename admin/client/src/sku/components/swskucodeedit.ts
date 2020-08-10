/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWSkuCodeEditController{

    public skuId:string;
    public skuPriceId:string;
    public minQuantity:string;
    public maxQuantity:string;
    public skuCode:string;
    public price:string;
    public currencyFilter:any;
    public currencyCode:string;
    public eligibleCurrencyCodeList:string;
    public filterOnCurrencyCode:string;
    public bundledSkuSkuId:string;
    public bundledSkuSkuCode:string;
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
        this.formName = this.utilityService.createID(32);
        if(angular.isUndefined(this.skuId) && angular.isDefined(this.bundledSkuSkuId)){
            this.skuId = this.bundledSkuSkuId;
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
        if(angular.isDefined(this.bundledSkuSkuCode)){
            this.skuCode = this.bundledSkuSkuCode;
        }

        if(angular.isDefined(this.skuId) && angular.isUndefined(this.sku)){
            var skuData = {
                skuID : this.skuId,
                skuCode : this.skuCode
            }
            this.sku = this.$hibachi.populateEntity("Sku", skuData);
        }
    }
}

class SWSkuCodeEdit implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {};
    public bindToController = {
        skuId:"@?",
        skuPriceId:"@?",
        skuCode:"@?",
        price:"@?",
        baseEntityId:"@?",
        baseEntityName:"@?",
        bundledSkuSkuId:"@?",
        bundledSkuSkuCode:"@?",
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
    public controller = SWSkuCodeEditController;
    public controllerAs="swSkuCodeEdit";


    public static Factory(){
        var directive = (
            observerService,
            historyService,
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWSkuCodeEdit(
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
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"skucodeedit.html";
    }

    public link:ng.IDirectiveLinkFn = (scope:any, element: ng.IAugmentedJQuery, attrs:ng.IAttributes, formController:any, transcludeFn:ng.ITranscludeFunction) =>{

        var currentScope = this.scopeService.getRootParentScope(scope, "pageRecord");
        if(angular.isDefined(currentScope["pageRecord"])){
            scope.swSkuCodeEdit.pageRecord = currentScope["pageRecord"];

        }
        var currentScope = this.scopeService.getRootParentScope(scope, "pageRecordKey");
        if(angular.isDefined(currentScope["pageRecordKey"])){
             scope.swSkuCodeEdit.pageRecordIndex = currentScope["pageRecordKey"];
        }
	}
}
export{
    SWSkuCodeEdit,
    SWSkuCodeEditController
}
