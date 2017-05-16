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
    public currentRecordOrderDetail:any;
    private currentSelectedFulfillmentBatchItemID:any;

    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private listingService){
        
        //Create the fulfillmentBatchItemCollection
        this.createLgOrderFulfillmentBatchItemCollection();
        this.createSmOrderFulfillmentBatchItemCollection();
        
        //get the listingDisplay store and listen for changes to the listing display state.
        listingService.listingDisplayStore.store$.subscribe((update)=>{
            console.log("State => ", update);
            if (update.action && update.action.type && update.action.type == "CURRENT_PAGE_RECORDS_SELECTED"){
                //Check for the tables we care about fulfillmentBatchItemTable1, fulfillmentBatchItemTable2
                //Outer table, will need to toggle and set the floating cards to this data.
                if (angular.isDefined(update.action.payload)){
                    
                    if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable1"){
                        //outer listing updated. We need to shrink the view and set the current record to the selected record.
                        console.log("Outer Listing Updated");
                        //on the first one being selected, go to the shrink view.
                        if (angular.isDefined(update.action.payload.values) && update.action.payload.values.length == 1){
                            if (this.expanded){
                                this.expanded = !this.expanded;
                            }
                            this.currentSelectedFulfillmentBatchItemID = update.action.payload.values[0];
                            //use this id to get the record and set it to currentRecordOrderDetail.
                            console.log("Collection Data", this.smFulfillmentBatchItemCollection);
                            //*****Need to iterate over the collection and find the ID to match against and get the orderfulfillment collection that matches this record.
                            for (var batchItem in this.smFulfillmentBatchItemCollection){
                                console.log("Item", batchItem, this.smFulfillmentBatchItemCollection[batchItem], this.currentSelectedFulfillmentBatchItemID);
                                if (this.smFulfillmentBatchItemCollection[batchItem]['orderFulfillment.orderFulfillmentID'] == this.currentSelectedFulfillmentBatchItemID){
                                    //get a new collection using the orderFulfillment.
                                    this.currentRecordOrderDetail = this.collectionConfigService.newCollectionConfig("OrderFulfillment");
                                    this.currentRecordOrderDetail.addFilter("orderFulfillmentID", this.smFulfillmentBatchItemCollection[batchItem]['orderFulfillmentID'], "=");
                                    this.currentRecordOrderDetail.getEntity().then(function(entityResult){
                                        console.log("Got entity", entityResult);
                                    });
                                }
                            }
                            
                            //console.log("Batch Item Data", batchItemDetail);
                            //now get the orderFulfillment.

                        }
                        //set the inner selection to this selection.
                    }
                    if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable2"){
                        //inner listing updated.
                        console.log("Inner Listing Updated");
                        //if nothing is selected, go back to the outer view.
                        if (!angular.isDefined(update.action.payload.values) || update.action.payload.values.length == 0){
                            if (this.expanded == false){
                                this.expanded = !this.expanded;
                            }
                        }
                        //set the outer selection to this selection.
                        this.currentSelectedFulfillmentBatchItemID = "";
                    }
                }
            }
        }); 
    }

     /**
     * Setup the initial orderFulfillment Collection.
     */
     private createLgOrderFulfillmentBatchItemCollection = ():void => {
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
     private createSmOrderFulfillmentBatchItemCollection = ():void => {
        this.smFulfillmentBatchItemCollection = this.collectionConfigService.newCollectionConfig("FulfillmentBatchItem");
        this.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.order.orderOpenDateTime");
        this.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingMethod.shippingMethodName");
        this.smFulfillmentBatchItemCollection.addDisplayProperty("fulfillmentBatchItemID");
        this.smFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.fulfillmentBatchId, "=");
        
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
