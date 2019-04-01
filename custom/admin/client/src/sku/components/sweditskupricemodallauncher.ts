// var swEditSkuPriceModalLauncherHTML = require("html-loader!sku/components/editskupricemodallauncher");
import {SWEditSkuPriceModalLauncher as EditSkuPriceModalLauncher} from "../../../../../../admin/client/src/sku/components/sweditskupricemodallauncher";
import {SWEditSkuPriceModalLauncherController as EditSkuPriceModalLauncherController} from "../../../../../../admin/client/src/sku/components/sweditskupricemodallauncher";

class SWEditSkuPriceModalLauncherController extends EditSkuPriceModalLauncherController{
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
        super(  
            $hibachi,
            entityService,
            formService,
            listingService,
            observerService, 
            skuPriceService,
            utilityService,
            scopeService,
            $scope
        );

        if(angular.isDefined(this.pageRecord)){ 
            //sku record case
            if(angular.isDefined(this.pageRecord["sku_skuID"]) && angular.isDefined(this.pageRecord.skuPriceID) && this.pageRecord.skuPriceID.length){
            
                this.skuPrice.personalVolume = this.pageRecord.personalVolume;
                this.skuPrice.taxableAmount = this.pageRecord.taxableAmount;
                this.skuPrice.commissionableVolume = this.pageRecord.commissionableVolume;
                this.skuPrice.sponsorVolume = this.pageRecord.sponsorVolume;
                this.skuPrice.productPackVolume = this.pageRecord.productPackVolume;
                this.skuPrice.retailValueVolume = this.pageRecord.retailValueVolume;
                this.skuPrice.handlingFee = this.pageRecord.handlingFee;
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
    
}

class SWEditSkuPriceModalLauncher extends EditSkuPriceModalLauncher implements ng.IDirective{
    
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
        super(
            $hibachi, 
            entityService,
            observerService,
            scopeService, 
            collectionConfigService, 
            skuPartialsPath,
            slatwallPathBuilder
        );
        
        let swEditSkuPriceModalLauncher = new EditSkuPriceModalLauncher(
            $hibachi, 
            entityService,
            observerService,
            scopeService, 
            collectionConfigService, 
            skuPartialsPath,
            slatwallPathBuilder
        );
            
        swEditSkuPriceModalLauncher.controller = SWEditSkuPriceModalLauncherController;
        swEditSkuPriceModalLauncher.controllerAs="swEditSkuPriceModalLauncher";
        return swEditSkuPriceModalLauncher;
    }
}

export{
    SWEditSkuPriceModalLauncher,
    SWEditSkuPriceModalLauncherController
}
