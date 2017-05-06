/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Observable} from 'rxjs/Observable';

type ActionName = "toggle" | "refresh";

/**
 * Fulfillment Batch Detail Controller
 */
class SWFulfillmentBatchDetailController  {
    public expanded:boolean = true;
    public TOGGLE_ACTION:ActionName = "toggle";
    public fulfillmentBatchId: string;
    public lgFulfillmentBatchItemCollection:any;
    public smFulfillmentBatchItemCollection:any;
    
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private orderFulfillmentService){
        
        this.orderFulfillmentService.actionStream$.subscribe(
            (next) => {
                console.log("Next Action", next);
            },
            (error) => {
                console.log("Error", error);
            }
        );
        console.log(`FulfillmentBatchId, ${this.fulfillmentBatchId}`);

        //Create the fulfillmentBatchItemCollection
        this.createExpandedOrderFulfillmentBatchItemCollection();
        this.createShunkOrderFulfillmentBatchItemCollection();
    }

     /**
     * Setup the initial orderFulfillment Collection.
     */
     private createExpandedOrderFulfillmentBatchItemCollection = ():void => {
        this.lgFulfillmentBatchItemCollection = this.collectionConfigService.newCollectionConfig("FulfillmentBatchItem");
        this.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.order.orderOpenDateTime", "Date");
        this.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingMethod.shippingMethodName");
        this.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingAddress.stateCode");
        this.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentStatusType.typeName");
        this.lgFulfillmentBatchItemCollection.addDisplayProperty("fulfillmentBatchItemID");
        this.lgFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.fulfillmentBatchId, "=");
       
     }
     /**
     * Setup the initial orderFulfillment Collection.
     */
     private createShunkOrderFulfillmentBatchItemCollection = ():void => {
        this.smFulfillmentBatchItemCollection = this.collectionConfigService.newCollectionConfig("FulfillmentBatchItem");
        this.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.order.orderOpenDateTime");
        this.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingMethod.shippingMethodName");
        this.smFulfillmentBatchItemCollection.addDisplayProperty("fulfillmentBatchItemID");
        this.smFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.fulfillmentBatchId, "=");
        
     }

    public toggleListing = () => {
        this.orderFulfillmentService.dispatchAction({
            "name": this.TOGGLE_ACTION,
            "payload": {}
        });
    }


}

/**
 * This is a view helper class that uses the collection helper class.
 */
class SWFulfillmentBatchDetail implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA"; 
    public scope = {}	
    
    public bindToController = {
        fulfillmentBatchId: "@?"
    }

    public controller=SWFulfillmentBatchDetailController;
    public controllerAs="swFulfillmentBatchDetailController";
     
    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			fulfillmentBatchDetailPartialsPath,
			slatwallPathBuilder
		) => new SWFulfillmentBatchDetail (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			fulfillmentBatchDetailPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
            '$hibachi', 
            '$timeout', 
            'collectionConfigService',
            'observerService',
			'fulfillmentBatchDetailPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private fulfillmentBatchDetailPartialsPath, slatwallPathBuilder){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(fulfillmentBatchDetailPartialsPath) + "fulfillmentbatchdetail.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{  
    }
}

export {
    SWFulfillmentBatchDetailController,
	SWFulfillmentBatchDetail
};
