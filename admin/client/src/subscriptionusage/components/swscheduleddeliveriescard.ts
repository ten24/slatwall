/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWScheduledDeliveriesCardController {

    public selectedSubscriptionPeriod:string;
    public subscriptionUsageId:string;
    public numerator:number;
    public denominator:number;

    //@ngInject
    constructor(
        public collectionConfigService
    ){
        
    }
    
    /*
    SELECT COUNT(DISTINCT tempAlias.id) FROM SlatwallSubscriptionOrderItem tempAlias 
    WHERE tempAlias.id IN ( 
        SELECT MIN(_subscriptionorderitem.id) 
        FROM SlatwallSubscriptionOrderItem as _subscriptionorderitem 
        left join _subscriptionorderitem.subscriptionOrderDeliveryItems as _subscriptionorderitem_subscriptionOrderDeliveryItems 
        left join _subscriptionorderitem.subscriptionUsage as _subscriptionorderitem_subscriptionUsage 
        where ( _subscriptionorderitem_subscriptionUsage.subscriptionUsageID = :P56a22bb6fd344a738e4472399eecd963 ) 
        GROUP BY _subscriptionorderitem.subscriptionOrderItemID,_subscriptionorderitem.createDateTime 
    )
    */
    
    public selectSubscriptionPeriod=()=>{
        if(this.selectedSubscriptionPeriod == 'All Deliveries'){
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
