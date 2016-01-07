/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
class SWOrderByPromotionListingController{
    public collectionPromise; 
    public collection;
    public orderCollectionConfig; 
    public appliedPromotionCollectionConfig; 
    public promotionId; 

    // @ngInject
	constructor(private collectionConfigService){
		this.init();
	}

	public init = ():void =>{
        this.orderCollectionConfig = this.collectionConfigService.newCollectionConfig('Order');
        this.orderCollectionConfig.setDisplayProperties("account.firstName,account.lastName,orderType.typeName,orderStatusType.typeName,calculatedTotal");
        this.appliedPromotionCollectionConfig = this.collectionConfigService.newCollectionConfig('PromotionApplied');
        this.appliedPromotionCollectionConfig.setDisplayProperties("promotion.promotionID,order.orderID"); 
        this.appliedPromotionCollectionConfig.setAllRecords(true);
        this.appliedPromotionCollectionConfig.addFilter("promotion.promotionID", this.promotionId), '=';
        
        this.appliedPromotionCollectionConfig.getEntity().then((response)=>{
            var first = true
            angular.forEach(response.records,(appliedPromotion)=>{
                if(first){
                    this.orderCollectionConfig.addFilter("orderID",appliedPromotion.order_orderID,"=");
                    first = false; 
                } else { 
                    this.orderCollectionConfig.addFilter("orderID",appliedPromotion.order_orderID,"=","OR");
                }
            });  
        }).finally(()=>{
            this.collectionPromise = this.orderCollectionConfig.getEntity();
            this.collectionPromise.then((data)=>{
                this.collection = data; 
                this.collection.collectionConfig = this.orderCollectionConfig; 
            })
        });
	}
}

class SWOrderByPromotionListing implements ng.IDirective {

	public restrict:string;
	public templateUrl:string;
	public scope = {};
	public bindToController = {
		promotionId:"@"
	};
	public controller= SWOrderByPromotionListingController;
	public controllerAs="swOrderByPromotionListing";

	public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
			collectionConfigService,
			promotionPartialsPath,
			pathBuilderConfig
		) => new SWOrderByPromotionListing(
			collectionConfigService,
			promotionPartialsPath,
			pathBuilderConfig
		);
		directive.$inject = [
			'collectionConfigService',
			'promotionPartialsPath',
			'pathBuilderConfig'
		];
		return directive;
	}

    // @ngInject
	constructor(private collectionConfigService, private promotionPartialsPath, private pathBuilderConfig){
		this.templateUrl = pathBuilderConfig.buildPartialsPath(promotionPartialsPath) + "/orderbypromotionlisting.html";
		this.restrict = "E";
	}

	public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
	}

}

export {
	SWOrderByPromotionListingController,
	SWOrderByPromotionListing
};
