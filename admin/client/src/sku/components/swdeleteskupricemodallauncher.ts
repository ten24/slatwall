/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWDeleteSkuPriceModalLauncherController{
    
    public pageRecord:any; 
    public sku:any;
    public skuId:string; 
    public skuPrice:any; 
    public baseName:string="j-delete-sku-item-"; 
    public listingID:string; 
    public uniqueName:string; 
    
    //@ngInject
    constructor(
        private $q,
        private $hibachi,
        private listingService, 
        private skuPriceService, 
        private utilityService,
        private observerService
    ){
        this.uniqueName = this.baseName + this.utilityService.createID(16); 
        this.observerService.attach(this.init, "DELETE_SKUPRICE");
        //hack for listing hardcodeing id
        this.listingID = 'pricingListing';
    }  
    
    public init = (pageRecord:any) =>{
        this.pageRecord = pageRecord;
        
        var skuPriceData = {
            skuPriceID : pageRecord.skuPriceID,
            minQuantity : pageRecord.minQuantity,
            maxQuantity : pageRecord.maxQuantity,
            currencyCode : pageRecord.currencyCode, 
            price : pageRecord.price
        }
        
        this.skuPrice = this.$hibachi.populateEntity('SkuPrice', skuPriceData);
    }

    public deleteSkuPrice = () => {
        var deletePromise = this.skuPrice.$$delete();
        
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
}

class SWDeleteSkuPriceModalLauncher implements ng.IDirective{
    public templateUrl;
    public restrict = 'EA';
    public scope = {}; 
    public bindToController = {
        pageRecord:"=?"
    };
    public controller = SWDeleteSkuPriceModalLauncherController;
    public controllerAs="swDeleteSkuPriceModalLauncher";
   
   
    public static Factory(){
        var directive = (
            $hibachi,
            scopeService, 
            skuPartialsPath,
			slatwallPathBuilder
        )=> new SWDeleteSkuPriceModalLauncher(
            $hibachi, 
            scopeService,
            skuPartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
            '$hibachi',
            'scopeService',
            'skuPartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    constructor(
        private $hibachi, 
        private scopeService,
		private skuPartialsPath,
	    private slatwallPathBuilder
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(skuPartialsPath)+"deleteskupricemodallauncher.html";
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
    SWDeleteSkuPriceModalLauncher,
    SWDeleteSkuPriceModalLauncherController
}
