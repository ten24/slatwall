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
    //Collections
    public lgFulfillmentBatchItemCollection:any;
    public smFulfillmentBatchItemCollection:any;
    public currentRecordOrderDetail:any;
    public commentsCollection:any;
    public orderFulfillmentItemsCollection:any;
    //Misc
    public accountNames:any = {};
    private currentSelectedFulfillmentBatchItemID:any;

    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private listingService){
        
        //Create the fulfillmentBatchItemCollection
        this.createLgOrderFulfillmentBatchItemCollection();
        this.createSmOrderFulfillmentBatchItemCollection();
        
        //get the listingDisplay store and listen for changes to the listing display state.
        listingService.listingDisplayStore.store$.subscribe((update)=>{
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
                            //*****Need to iterate over the collection and find the ID to match against and get the orderfulfillment collection that matches this record.
                            let collectionItems = this.smFulfillmentBatchItemCollection.getEntity().then((results)=>{
                                for (var result in results.pageRecords){
                                    let currentRecord = results['pageRecords'][result];
                                    if (currentRecord['fulfillmentBatchItemID'] == this.currentSelectedFulfillmentBatchItemID){
                                        //Save some items from the currentRecord to display.

                                        //Get a new collection using the orderFulfillment.
                                        this.currentRecordOrderDetail = this.collectionConfigService.newCollectionConfig("OrderFulfillment");
                                        this.currentRecordOrderDetail.addFilter("orderFulfillmentID", currentRecord['orderFulfillment_orderFulfillmentID'], "=");
                                        
                                        //Get the orderItems for this fulfillment
                                        this.getOrderFulfillmentItemCollection(currentRecord['orderFulfillment_orderFulfillmentID']);
                                        
                                        //For the order
                                        this.currentRecordOrderDetail.addDisplayProperty("order.orderOpenDateTime", "Open Date"); //date placed
                                        this.currentRecordOrderDetail.addDisplayProperty("order.orderCloseDateTime", "Close Date");
                                        this.currentRecordOrderDetail.addDisplayProperty("order.orderNumber", "Order Number");
                                        this.currentRecordOrderDetail.addDisplayProperty("order.calculatedTotal", "Total");
                                        this.currentRecordOrderDetail.addDisplayProperty("order.paymentAmountDue", "Amount Due", {persistent: false});
                                        
                                        //For the account portion of the tab.
                                        this.currentRecordOrderDetail.addDisplayProperty("order.account.accountID", "Account Number");
                                        this.currentRecordOrderDetail.addDisplayProperty("order.account.firstName", "First Name");
                                        this.currentRecordOrderDetail.addDisplayProperty("order.account.lastName", "Last Name");
                                        this.currentRecordOrderDetail.addDisplayProperty("order.account.company", "Company");
                                        
                                        //For the shipping portion of the tab.
                                        this.currentRecordOrderDetail.addDisplayProperty("shippingMethod.shippingMethodName");
                                        this.currentRecordOrderDetail.addDisplayProperty("shippingAddress.city");
                                        this.currentRecordOrderDetail.addDisplayProperty("shippingAddress.stateCode");
                                        this.currentRecordOrderDetail.addDisplayProperty("orderFulfillmentStatusType.typeName");
                                        
                                        this.currentRecordOrderDetail.getEntity().then( (entityResults) => {
                                            if (entityResults['pageRecords'].length){
                                                this.currentRecordOrderDetail = entityResults['pageRecords'][0];
                                                this.currentRecordOrderDetail['fulfillmentBatchItem'] = currentRecord;
                                                this.currentRecordOrderDetail['comments'] = this.getCommentsForFulfillmentBatchItem(this.currentSelectedFulfillmentBatchItemID);
                                            }
                                        });
                                    }
                                }
                            });

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
                                //set the outer selection to this selection.
                                this.currentSelectedFulfillmentBatchItemID = "";
                            }
                        }
                    }
                }
            }
        }); 
    }
     /**
      * Returns the comments for the selectedFulfillmentBatchItem
      */
     public getCommentsForFulfillmentBatchItem = (fulfillmentBatchItemID) => {
        this.commentsCollection = this.collectionConfigService.newCollectionConfig("Comment");
        this.commentsCollection.addDisplayProperty("createdDateTime");
        this.commentsCollection.addDisplayProperty("createdByAccountID");
        this.commentsCollection.addDisplayProperty("comment");
        this.commentsCollection.addFilter("fulfillmentBatchItem.fulfillmentBatchItemID", fulfillmentBatchItemID, "=");
        this.commentsCollection.getEntity().then((comments)=>{
            this.commentsCollection = comments['pageRecords'];
            for (var account in this.commentsCollection){
                if (angular.isDefined(this.commentsCollection[account]['createdByAccountID'])){
                    //sets the account name to the account names object indexed by the account id.
                    this.getAccountNameByAccountID(this.commentsCollection[account]['createdByAccountID']);
                }
            }
        });
     }

     /**
      * Returns account information given an accountID
      */
     public getAccountNameByAccountID= (accountID) => {
        let accountCollection = this.collectionConfigService.newCollectionConfig("Account");
        accountCollection.addFilter("accountID", accountID, "=");
        accountCollection.getEntity().then((account)=>{
            if (account['pageRecords'].length){
                this.accountNames[accountID] = account['pageRecords'][0]['firstName'] + ' ' + account['pageRecords'][0]['lastName'];
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
        this.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
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
        this.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
        this.smFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.fulfillmentBatchId, "=");
        
     }

     /**
     * Returns  orderFulfillmentItem Collection given an orderFulfillmentID.
     */
     private getOrderFulfillmentItemCollection = (orderFulfillmentID):void => {
        this.orderFulfillmentItemsCollection = this.collectionConfigService.newCollectionConfig("OrderItem");
        this.orderFulfillmentItemsCollection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
        this.orderFulfillmentItemsCollection.addDisplayProperty("sku.skuCode");
        this.orderFulfillmentItemsCollection.addDisplayProperty("sku.product.productName");
        this.orderFulfillmentItemsCollection.addDisplayProperty("sku.skuName");
        this.orderFulfillmentItemsCollection.addDisplayProperty("sku.imagePath", "Path", {persistent: false});
        this.orderFulfillmentItemsCollection.addDisplayProperty("sku.imageFileName", "File Name", {persistent: false});
        this.orderFulfillmentItemsCollection.addDisplayProperty("quantity");
        this.orderFulfillmentItemsCollection.addDisplayProperty("orderItemID");
        this.orderFulfillmentItemsCollection.addFilter("orderFulfillment.orderFulfillmentID", orderFulfillmentID, "=");
        this.orderFulfillmentItemsCollection.getEntity().then((orderItems)=>{
            this.orderFulfillmentItemsCollection = orderItems['pageRecords'];
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
