/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWScheduledDeliveriesCardController {

    public selectedSubscriptionPeriod:string;
    public subscriptionUsageId:string;
    public numerator:number;
    public denominator:number;

    //@ngInject
    constructor(
        public collectionConfigService,
        public observerService
    ){
        
    }
    
    public selectSubscriptionPeriod=()=>{
        
        this.subscriptionOrderDeliveryItemsCollectionList = this.collectionConfigService.newCollectionConfig('SubscriptionOrderDeliveryItem');
        
        this.subscriptionOrderDeliveryItemsCollectionList.addFilter('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID',this.subscriptionUsageId);
        this.subscriptionOrderDeliveryItemsCollectionList.setDisplayProperties('createdDateTime,quantity,subscriptionOrderItem.orderItem.calculatedExtendedPrice,earned');
        this.subscriptionOrderDeliveryItemsCollectionList.setAllRecords(true);
        
        if(this.selectedSubscriptionPeriod == 'All Deliveries'){
            
            this.observerService.notify('getCollection');
            
            var subscriptionOrderItemCollectionList = this.collectionConfigService.newCollectionConfig('SubscriptionOrderItem');
            subscriptionOrderItemCollectionList.addFilter('subscriptionUsage.subscriptionUsageID',this.subscriptionUsageId);
            subscriptionOrderItemCollectionList.setDisplayProperties('subscriptionOrderItemID,subscriptionUsage.subscriptionTerm.itemsToDeliver,orderItem.calculatedExtendedPrice');
            subscriptionOrderItemCollectionList.addDisplayAggregate('subscriptionOrderDeliveryItems.quantity','SUM','subscriptionOrderDeliveryItemsQuantitySum');
            subscriptionOrderItemCollectionList.setOrderBy('createdDateTime|DESC');
            subscriptionOrderItemCollectionList.setAllRecords(true);
            subscriptionOrderItemCollectionList.getEntity().then((data)=>{
                var itemsDelivered = 0;
                var itemsToDeliver = 0;
                var valueEarned = 0;
                for(var i in data.records){
                    var subscriptionOrderItemData = data.records[i];
                    itemsDelivered += subscriptionOrderItemData.subscriptionOrderDeliveryItemsQuantitySum;
                    itemsToDeliver += subscriptionOrderItemData.subscriptionUsage_subscriptionTerm_itemsToDeliver;
                    valueEarned += subscriptionOrderItemData.orderItem_calculatedExtendedPrice * subscriptionOrderItemData.subscriptionOrderDeliveryItemsQuantitySum;
                }
                
               this.numerator = itemsDelivered; 
               this.denominator = itemsToDeliver;
               this.earned = valueEarned;
            });
            
        }else if(this.selectedSubscriptionPeriod == 'Current Term'){
            var subscriptionOrderItemCollectionList = this.collectionConfigService.newCollectionConfig('SubscriptionOrderItem');
            subscriptionOrderItemCollectionList.addFilter('subscriptionUsage.subscriptionUsageID',this.subscriptionUsageId);
            subscriptionOrderItemCollectionList.setDisplayProperties('subscriptionOrderItemID,subscriptionUsage.subscriptionTerm.itemsToDeliver,orderItem.calculatedExtendedPrice');
            subscriptionOrderItemCollectionList.addDisplayAggregate('subscriptionOrderDeliveryItems.quantity','SUM','subscriptionOrderDeliveryItemsQuantitySum');
            subscriptionOrderItemCollectionList.setOrderBy('createdDateTime|DESC');
            subscriptionOrderItemCollectionList.setPageShow(1);
            subscriptionOrderItemCollectionList.getEntity().then((data)=>{
               this.numerator = data.pageRecords[0].subscriptionOrderDeliveryItemsQuantitySum; 
               this.denominator = data.pageRecords[0].subscriptionUsage_subscriptionTerm_itemsToDeliver;
               this.earned = data.pageRecords[0].orderItem_calculatedExtendedPrice * data.pageRecords[0].subscriptionOrderDeliveryItemsQuantitySum;
               
               this.subscriptionOrderDeliveryItemsCollectionList.addFilter('subscriptionOrderItem.subscriptionOrderItemID',data.pageRecords[0].subscriptionOrderItemID);
               this.observerService.notify('getCollection');
            });
        }        
    }
    
}

class SWScheduledDeliveriesCard implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA";
    public scope = {};  
    
    public bindToController = {
        subscriptionUsageId:"@"
    };
    
    public controller=SWScheduledDeliveriesCardController;
    public controllerAs="swScheduledDeliveriesCard";
    
	public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    subscriptionUsagePartialsPath,
			slatwallPathBuilder
        ) => new SWScheduledDeliveriesCard(
			subscriptionUsagePartialsPath,
			slatwallPathBuilder
        );
        directive.$inject = [
			'subscriptionUsagePartialsPath',
			'slatwallPathBuilder'
        ];
        return directive;
    }
    
    //@ngInject
	constructor(
	    private subscriptionUsagePartialsPath,
		private slatwallPathBuilder
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(subscriptionUsagePartialsPath) + "/scheduleddeliveriescard.html";
    }

    public link:ng.IDirectiveLinkFn = (scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
	SWScheduledDeliveriesCardController,
	SWScheduledDeliveriesCard
};
