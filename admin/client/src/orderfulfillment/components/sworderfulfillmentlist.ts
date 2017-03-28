/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWOrderFulfillmentListController {
    
    
    
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService){
        
        
        
        //this.productCollectionConfig = collectionConfigService.newCollectionConfig("Product");
        //this.productCollectionConfig.addDisplayProperty("productID, productName, productType.productTypeID");
        
        /*this.productCollectionConfig.getEntity(this.productId).then((response)=>{
            
            this.product = response; 				
            this.productTypeID = response.productType_productTypeID;
            
            this.skuCollectionConfig = collectionConfigService.newCollectionConfig("Sku");
            this.skuCollectionConfig.addDisplayProperty("skuID, skuCode, product.productID"); 
            this.skuCollectionConfig.addFilter("product.productID", this.productId);
            this.skuCollectionConfig.setAllRecords(true);
            
            this.usedOptions = [];
            
            this.skuCollectionConfig.getEntity().then((response)=>{
                this.skus = response.records; 	
                angular.forEach(this.skus, (sku)=>{
                    
                    var optionCollectionConfig = collectionConfigService.newCollectionConfig("Option");
                    
                    optionCollectionConfig.addDisplayProperty("optionID, optionName, optionCode, optionGroup.optionGroupID");
                    optionCollectionConfig.setAllRecords(true);
                    optionCollectionConfig.addFilter("skus.skuID", sku.skuID);
                    
                    optionCollectionConfig.getEntity().then((response)=>{
                        this.usedOptions.push(
                            utilityService.arraySorter(response.records, ["optionGroup_optionGroupID"])
                        );
                    });
                });
            }); 
        }); */
        
        //this.observerService.attach(this.validateOptions, "validateOptions");			
    }
    
}

class SWOrderFulfillmentList implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA"; 
    public scope = {}	
    
    public bindToController = {
    }
    public controller=SWOrderFulfillmentListController;
    public controllerAs="swOrderFulfillmentListController";
     
    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			optionGroupPartialsPath,
			slatwallPathBuilder
		) => new SWOrderFulfillmentList (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			optionGroupPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
            '$hibachi', 
            '$timeout', 
            'collectionConfigService',
            'observerService',
			'optionGroupPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private optionGroupPartialsPath, slatwallPathBuilder){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(optionGroupPartialsPath) + "orderfulfillmentlist.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{  
    }
}

export {
    SWOrderFulfillmentListController,
	SWOrderFulfillmentList
};