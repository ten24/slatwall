/// <reference path="../../../../../node_modules/typescript/lib/lib.es6.d.ts" />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Subject, Observable} from 'rxjs';
import * as Store from '../../../../../org/hibachi/client/src/core/prototypes/Store';

/**
 * Fulfillment List Controller
 */
class OrderFulfillmentService {
    //This is the single object that contains all state for the component.
    private state:any = {
        //boolean
        showFulfillmentListing: true,
        expandedFulfillmentBatchListing: true,
        editComment:false,
        
        //objects
        commentBeingEdited:undefined,
        
        //strings
        currentSelectedFulfillmentBatchItemID: "",
        fulfillmentBatchId:undefined,

        //empty collections
        smFulfillmentBatchItemCollection:undefined,
        lgFulfillmentBatchItemCollection:undefined,
        currentRecordOrderDetail:undefined,
        commentsCollection: undefined,
        orderFulfillmentItemsCollection:undefined,
        
        //arrays
        accountNames:[],
        orderDeliveryAttributes:[]
    };

    // Middleware - Logger - add this into the store declaration to log all calls to the reducer.
    public loggerEpic = (...args) => {
        return args;
    }

    /**
     * The reducer is responsible for modifying the state of the state object into a new state.
     */
    public orderFulfillmentStateReducer:Store.Reducer = (state:any, action:Store.Action<any>):Object => {
        switch(action.type) {
            case 'TOGGLE_FULFILLMENT_LISTING':
                //modify the state and return it.
                state.showFulfillmentListing = !state.showFulfillmentListing;
                
                return {
                    ...state, action
                };
            case 'ADD_BATCH':
                return {
                    ...state, action
                };
            //This handles setting up the fulfillment batch detail page including all state.
            case 'FULFILLMENT_BATCH_DETAIL_SETUP':
                //Setup the detail
                if (action.payload.fulfillmentBatchId != undefined){
                    this.state.fulfillmentBatchId = action.payload.fulfillmentBatchId;
                }
                this.setupFulfillmentBatchDetail();
                return {
                    ...this.state, action
                }
            case 'FULFILLMENT_BATCH_DETAIL_UPDATE':
                return {
                    ...this.state, action
                }
            case 'TOGGLE_FULFILLMENT_BATCH_LISTING':
                //Toggle the listing
                this.state.expandedFulfillmentBatchListing = !this.state.expandedFulfillmentBatchListing;
                return {
                    ...this.state, action
                }
            case 'EDIT_COMMENT_TOGGLE':
                //Update the comment.
                this.state.editComment = !this.state.editComment;
                if (this.state.editComment == true){
                    this.state.commentBeingEdited = action.payload.comment;
                }else{
                    this.state.commentBeingEdited = undefined;
                }
                
                return {
                    ...this.state, action
                }
            case 'SAVE_COMMENT_ACTION':
                if (action.payload.comment && action.payload.commentText){
                    //saving
                    this.saveComment(action.payload.comment, action.payload.commentText);
                }else{
                    //editing
                    this.saveComment({}, action.payload.commentText);
                }
                //toggle edit mode. so we are no longer editing.
                this.state.editComment = false;
                this.state.commentBeingEdited = undefined;
                return {
                    ...this.state, action
                }
            case 'DELETE_COMMENT_ACTION':
                this.deleteComment(action.payload.comment);
                this.state.editComment = false;
                this.state.commentBeingEdited = undefined;
                return {
                    ...this.state, action
                }
            case 'FULFILLMENT_ACTION':
                //create all the data
                console.log("Fulfilling Items", this.state.currentRecordOrderDetail, action.payload.viewState);
                this.fulfillItems(action.payload.viewState, false);
                
                return {
                    ...this.state, action
                }
             case 'DISPLAY_ORDER_DELIVERY_ATTRIBUTES':
                console.log("Display Attributes");
                this.createOrderDeliveryAttributeCollection();
                
                return {
                    ...this.state, action
                }
            default:
                return state;
        }
    } 
    /**
     *  Store stream. Set the initial state of the typeahead using startsWith and then scan. 
     *  Scan, is an accumulator function. It keeps track of the last result emitted, and combines
     *  it with the newest result. 
     */
    public orderFulfillmentStore:Store.Store;


    //@ngInject
    constructor(public $timeout, public observerService, public $hibachi, private collectionConfigService, private listingService, private $rootScope){
        //To create a store, we instantiate it using the object that holds the state variables,
        //and the reducer. We can also add a middleware to the end if you need.
        this.orderFulfillmentStore = new Store.Store( this.state, this.orderFulfillmentStateReducer );
        
    }

    public setupFulfillmentBatchDetail = () => {
        
        //Create the fulfillmentBatchItemCollection
        this.createLgOrderFulfillmentBatchItemCollection();
        this.createSmOrderFulfillmentBatchItemCollection();
        
        //get the listingDisplay store and listen for changes to the listing display state.
        this.listingService.listingDisplayStore.store$.subscribe((update)=>{
            if (update.action && update.action.type && update.action.type == "CURRENT_PAGE_RECORDS_SELECTED"){
                //Check for the tables we care about fulfillmentBatchItemTable1, fulfillmentBatchItemTable2
                //Outer table, will need to toggle and set the floating cards to this data.
                if (angular.isDefined(update.action.payload)){
                    if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable1"){
                       /* if (update.action.payload.values.length){
                            let selectedRowIndex = this.listingService.getSelectedBy("fulfillmentBatchItemTable2", "fulfillmentBatchItemID", this.state.currentSelectedFulfillmentBatchItemID);
                            if (selectedRowIndex != -1){
                            this.listingService
                                .getListing("fulfillmentBatchItemTable2").selectionService
                                    .addSelection(this.listingService.getListing("fulfillmentBatchItemTable2").tableID, 
                                        this.listingService.getListingPageRecords("fulfillmentBatchItemTable2")[selectedRowIndex][this.listingService.getListingBaseEntityPrimaryIDPropertyName("fulfillmentBatchItemTable2")]);
                            }
                        }else{
                            this.listingService.clearAllSelections("fulfillmentBatchItemTable1");
                            this.listingService.clearAllSelections("fulfillmentBatchItemTable2");
                        }*/
                        //on the first one being selected, go to the shrink view.
                        if (angular.isDefined(update.action.payload.values) && update.action.payload.values.length == 1){
                            if (this.state.expandedFulfillmentBatchListing){
                                this.state.expandedFulfillmentBatchListing = !this.state.expandedFulfillmentBatchListing;
                            }
                            this.state.currentSelectedFulfillmentBatchItemID = update.action.payload.values[0];
                            //use this id to get the record and set it to currentRecordOrderDetail.
                            //*****Need to iterate over the collection and find the ID to match against and get the orderfulfillment collection that matches this record.
                            this.state.smFulfillmentBatchItemCollection.getEntity().then((results)=>{
                                for (var result in results.pageRecords){
                                    let currentRecord = results['pageRecords'][result];
                                    if (currentRecord['fulfillmentBatchItemID'] == this.state.currentSelectedFulfillmentBatchItemID){
                                        //Matched - Save some items from the currentRecord to display.
                                        //Get the orderItems for this fulfillment
                                        this.createOrderFulfillmentItemCollection(currentRecord['orderFulfillment_orderFulfillmentID']);
                                        this.createCurrentRecordDetailCollection(currentRecord);
                                        this.emitUpdateToClient();
                                    }
                                }
                            });
                            //console.log("Batch Item Data", batchItemDetail);
                            //now get the orderFulfillment.

                        }
                        //set the inner selection to this selection.
                    }
                    if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable2"){
                        
                        //if nothing is selected, go back to the outer view.
                        if (!angular.isDefined(update.action.payload.values) || update.action.payload.values.length == 0){
                            if (this.state.expandedFulfillmentBatchListing == false){
                                this.state.expandedFulfillmentBatchListing = !this.state.expandedFulfillmentBatchListing;
                                this.emitUpdateToClient();
                            }
                        }
                    }
                }
            }
        }); 
    }

    public emitUpdateToClient = () => {
        this.orderFulfillmentStore.dispatch({
            type: "FULFILLMENT_BATCH_DETAIL_UPDATE",
            payload: {noop:angular.noop()}
        });
    }
    
    /**
     * Creates a batch. This should use api:main.post with a context of process and an entityName instead of doAction.
     * The process object should have orderItemIdList or orderFulfillmentIDList defined and should have
     * optionally an accountID, and or locationID (or locationIDList).
     */
    public addBatch = (processObject) => {
        if (processObject) {
            processObject.data.entityName = "FulfillmentBatch";
            processObject.data['fulfillmentBatch'] = {};
            processObject.data['fulfillmentBatch']['fulfillmentBatchID'] = "";

            return this.$hibachi.saveEntity("fulfillmentBatch",'',processObject.data, "create");
        }
    }

    /** Creates the orderDelivery - fulfilling the items quantity of items specified, capturing as needed. */
    public fulfillItems = (state:any={}, ignoreCapture:boolean = false) => {
        console.log("ViewState",state);
        let data:any = {};
        //Add the order information
        data.order = {};
        data.order['orderID'] = this.state.currentRecordOrderDetail['order_orderID'];
        //Add the orderFulfillment.
        data['orderDeliveryID'] = ""; //this indicates the the orderDelivery is being created.
        data['orderFulfillment'] = {};
        data['orderFulfillment']['orderFulfillmentID'] = this.state.currentRecordOrderDetail['fulfillmentBatchItem']['orderFulfillment_orderFulfillmentID'];
        data['trackingNumber'] = state.trackingCode || "";
        
        //Add the orderDelivertyItems as an array with the quantity set to the quantity.
        //Make sure all of the deliveryitems have a quantity set by the user.
        let idx = 1; //coldfusion indexes at 1
        data['orderDeliveryItems'] = [];
        for (var orderDeliveryItem in state.orderItem){
            if (state.orderItem[orderDeliveryItem] != undefined){
                data['orderDeliveryItems'].push({orderItem: {orderItemID: orderDeliveryItem}, quantity: state.orderItem[orderDeliveryItem]});
            }
            idx++;
        }

        //Add the payment information
        if (this.state.currentRecordOrderDetail['order_paymentAmountDue'] > 0 && !ignoreCapture){
            data.captureAuthorizedPaymentsFlag = true;
            data.capturableAmount = this.state.currentRecordOrderDetail['order_paymentAmountDue'];
        }
        //If the user input a captuable amount, use that instead.
        if (state.capturableAmount != undefined){
            data['capturableAmount'] = state.capturableAmount;
            //data['captureAuthorizedPaymentsFlag'] = true;
        }

        //Create the process object.
        let processObject = this.$hibachi.newOrderDelivery_Create();
        processObject.data = data;
        processObject.data.entityName = "OrderDelivery";
        
        //Basic Information
        processObject.data['location'] = {'locationID': "402828f95b108573015b165f48760528"};//sets a random location for now until batch issue with location is resolved.
        
        //Shipping information.
        processObject.data['containerLabel'] = data.containerLabel || "";
        processObject.data['shippingIntegration'] = data.shippingIntegration || "";
        processObject.data['shippingAddress'] = data.shippingAddress || "";
        processObject.data['useShippingIntegrationForTrackingNumber'] = data.useShippingIntegrationForTrackingNumber || false;
        
        //If we need to capture as well as fulfill.
        processObject.data['captureAuthorizedPaymentsFlag'] = data.captureAuthorizedPaymentsFlag || false;
        processObject.data['capturableAmount'] = data.capturableAmount || "";
        return this.$hibachi.saveEntity("OrderDelivery", '', processObject.data, "create");
    }

    /** Saves a comment. */
    public saveComment = (comment, newCommentText) => {
        //Editing
        if (angular.isDefined(comment) && angular.isDefined(comment.comment) && angular.isDefined(comment.commentID)) {
            comment.comment = newCommentText;
            return this.$hibachi.saveEntity("comment", comment.commentID, comment, "save");
        
        //New
        }else{
            //this is a new comment.
            var commentObject = {
                comment:"",
                fulfillmentBatchItem: {
                    fulfillmentBatchItemID: ""
                },
                fulfillmentBatchItemID:"",
                createdByAccountID:""
            };

            commentObject.comment = newCommentText;
            commentObject.fulfillmentBatchItem.fulfillmentBatchItemID = this.state.currentSelectedFulfillmentBatchItemID;
            commentObject.createdByAccountID = this.$rootScope.slatwall.account.accountID || "";
            this.$hibachi.saveEntity("comment",'', commentObject, "save").then((result)=>{
                //now regrab all comments so they are redisplayed.
                return this.createCommentsCollectionForFulfillmentBatchItem(this.state.currentSelectedFulfillmentBatchItemID);
            });
        }
    }

    /** Deletes a comment. */
    public deleteComment = (comment) => {
        if (comment != undefined) {
            this.$hibachi.saveEntity("comment", comment.commentID, comment, "delete").then((result) => {
                return this.createCommentsCollectionForFulfillmentBatchItem(this.state.currentSelectedFulfillmentBatchItemID);
            });
        }
    }

    /** Various collections used to retrieve data. */
    /**
     * Returns the comments for the selectedFulfillmentBatchItem
     */
     public createCommentsCollectionForFulfillmentBatchItem = (fulfillmentBatchItemID) => {
        this.state.commentsCollection = this.collectionConfigService.newCollectionConfig("Comment");
        this.state.commentsCollection.addDisplayProperty("createdDateTime");
        this.state.commentsCollection.addDisplayProperty("createdByAccountID");
        this.state.commentsCollection.addDisplayProperty("commentID");
        this.state.commentsCollection.addDisplayProperty("comment");
        this.state.commentsCollection.addFilter("fulfillmentBatchItem.fulfillmentBatchItemID", fulfillmentBatchItemID, "=");
        this.state.commentsCollection.getEntity().then((comments)=>{
            if (comments && comments.pageRecords.length){
                this.state.commentsCollection = comments['pageRecords'];
                for (var account in this.state.commentsCollection){
                    if (angular.isDefined(this.state.commentsCollection[account]['createdByAccountID'])){
                        //sets the account name to the account names object indexed by the account id.
                        this.getAccountNameByAccountID(this.state.commentsCollection[account]['createdByAccountID']);
                    }
                }
            }else{
                this.state.commentsCollection = comments.pageRecords;
                this.emitUpdateToClient();
            }
        });
     }

     /**
      * Returns the comments for the selectedFulfillmentBatchItem
      */
     public createCurrentRecordDetailCollection = (currentRecord) => {
        //Get a new collection using the orderFulfillment.
        this.state.currentRecordOrderDetail = this.collectionConfigService.newCollectionConfig("OrderFulfillment");
        this.state.currentRecordOrderDetail.addFilter("orderFulfillmentID", currentRecord['orderFulfillment_orderFulfillmentID'], "=");
        
        //For the order
        this.state.currentRecordOrderDetail.addDisplayProperty("order.orderOpenDateTime", "Open Date"); //date placed
        this.state.currentRecordOrderDetail.addDisplayProperty("order.orderCloseDateTime", "Close Date");
        this.state.currentRecordOrderDetail.addDisplayProperty("order.orderNumber", "Order Number");
        this.state.currentRecordOrderDetail.addDisplayProperty("order.orderID", "OrderID");
        this.state.currentRecordOrderDetail.addDisplayProperty("order.calculatedTotal", "Total");
        this.state.currentRecordOrderDetail.addDisplayProperty("order.paymentAmountDue", "Amount Due", {persistent: false});
        this.state.currentRecordOrderDetail.addDisplayProperty("order.paymentAmountAuthorizedTotal", "Authorized", {persistent: false});
        this.state.currentRecordOrderDetail.addDisplayProperty("order.paymentAmountCapturedTotal", "Captured", {persistent: false});
        
        //For the account portion of the tab.
        this.state.currentRecordOrderDetail.addDisplayProperty("order.account.accountID", "Account Number");
        this.state.currentRecordOrderDetail.addDisplayProperty("order.account.firstName", "First Name");
        this.state.currentRecordOrderDetail.addDisplayProperty("order.account.lastName", "Last Name");
        this.state.currentRecordOrderDetail.addDisplayProperty("order.account.company", "Company");
        
        //For the shipping portion of the tab.
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingMethod.shippingMethodName");
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.city");
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.stateCode");
        this.state.currentRecordOrderDetail.addDisplayProperty("orderFulfillmentStatusType.typeName");
        
        this.state.currentRecordOrderDetail.getEntity().then( (entityResults) => {
            if (entityResults['pageRecords'].length){
                this.state.currentRecordOrderDetail = entityResults['pageRecords'][0];
                this.state.currentRecordOrderDetail['fulfillmentBatchItem'] = currentRecord;
                this.state.currentRecordOrderDetail['comments'] = this.createCommentsCollectionForFulfillmentBatchItem(this.state.currentSelectedFulfillmentBatchItemID);
                this.emitUpdateToClient();
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
                this.state.accountNames[accountID] = account['pageRecords'][0]['firstName'] + ' ' + account['pageRecords'][0]['lastName'];
                this.emitUpdateToClient();
            }
        });
     } 
     /**
     * Setup the initial orderFulfillment Collection.
     */
     private createLgOrderFulfillmentBatchItemCollection = ():void => {
        this.state.lgFulfillmentBatchItemCollection = this.collectionConfigService.newCollectionConfig("FulfillmentBatchItem");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.order.orderOpenDateTime", "Date");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingMethod.shippingMethodName");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingAddress.stateCode");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentStatusType.typeName");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("fulfillmentBatchItemID");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
        this.state.lgFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.state.fulfillmentBatchId, "=");
     }
     
     /**
     * Setup the initial orderFulfillment Collection.
     */
     private createSmOrderFulfillmentBatchItemCollection = ():void => {
        this.state.smFulfillmentBatchItemCollection = this.collectionConfigService.newCollectionConfig("FulfillmentBatchItem");
        this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.order.orderOpenDateTime");
        this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingMethod.shippingMethodName");
        this.state.smFulfillmentBatchItemCollection.addDisplayProperty("fulfillmentBatchItemID");
        this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
        this.state.smFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.state.fulfillmentBatchId, "=");
        return this.state.smFulfillmentBatchItemCollection;
     }

     /**
     * Returns  orderFulfillmentItem Collection given an orderFulfillmentID.
     */
     private createOrderFulfillmentItemCollection = (orderFulfillmentID):void => {
        let collection = this.collectionConfigService.newCollectionConfig("OrderItem");
        collection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
        collection.addDisplayProperty("sku.skuCode");
        collection.addDisplayProperty("sku.product.productName");
        collection.addDisplayProperty("sku.skuName");
        collection.addDisplayProperty("sku.imagePath", "Path", {persistent: false});
        collection.addDisplayProperty("sku.imageFileName", "File Name", {persistent: false});
        collection.addDisplayProperty("quantity");
        collection.addDisplayProperty("orderItemID");
        collection.addFilter("orderFulfillment.orderFulfillmentID", orderFulfillmentID, "=");
        collection.getEntity().then((orderItems)=>{
            if (orderItems && orderItems.pageRecords && orderItems.pageRecords.length){
                this.state.orderFulfillmentItemsCollection = orderItems['pageRecords'];
            }else{
                this.state.orderFulfillmentItemsCollection = [];
            }
            this.emitUpdateToClient();
        });
     }

     /**
     * Returns  orderFulfillmentItem Collection given an orderFulfillmentID.
     */
     private createOrderDeliveryAttributeCollection = ():void => {
        let orderDeliveryAttributes = [];
        //Get all the attributes from those sets where the set object is orderDelivery.
        let attributeCollection = this.collectionConfigService.newCollectionConfig("Attribute");
        attributeCollection.addFilter("attributeSet.attributeSetObject", "OrderDelivery", "=");
        attributeCollection.getEntity().then((attributes)=>{ 
            if (attributes && attributes.pageRecords){
                attributes.pageRecords.forEach(attribute => {
                    let newAttribute = {
                        name: attribute.attributeName,
                        code: attribute.attributeCode,
                        description: attribute.attributeDescription,
                        hint: attribute.attributeHint,
                        type: attribute.attributeInputType,
                        default: attribute.defaultValue,
                        isRequired: attribute.requiredFlag,
                        isActive: attributes.activeFlag
                    };
                    orderDeliveryAttributes.push(newAttribute);
                });
            }
        });
        //For each attribute set, get all the attributes.
        this.state.orderDeliveryAttributes = orderDeliveryAttributes;
        this.emitUpdateToClient(); //alert the client that we have new data to give.
     }
}
export {
    OrderFulfillmentService
}