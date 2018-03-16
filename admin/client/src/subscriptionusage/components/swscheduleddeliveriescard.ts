/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

class SWScheduledDeliveriesCardController {

    public selectedSubscriptionPeriod:string;
    public subscriptionUsageId:string;

    //@ngInject
    constructor(
    ){
        collectionConfigService
    }
    
    public selectSubscriptionPeriod=()=>{
        var subscriptionOrderDeliveryItemsCollectionList = this.collectionConfigService.newCollectionConfig('SubscriptionOrderDeliveryItem');
        subscriptionOrderDeliveryItemsCollectionList.addFilter('subscriptionOrderItem.subscriptionUsage.subscriptionUsageID',this.subscriptionUsageId);
        
        if(this.selectedSubscriptionPeriod == 'All Deliveries'){
            //subscriptionOrderDeliveryItemsCollectionList.setDisplayProperties('subscr')
        }else if(this.selectedSubscriptionPeriod == 'Current Term'){
            
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
