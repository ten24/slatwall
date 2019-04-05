/// <reference path="../../../../../node_modules/typescript/lib/lib.es6.d.ts" />
/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Subject, Observable} from 'rxjs';
import * as FluxStore from   '../../../../../org/Hibachi/client/src/core/prototypes/swstore';
import * as actions from '../../../../../admin/client/src/fulfillmentbatch/actions/fulfillmentbatchactions';

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
        useShippingIntegrationForTrackingNumber:true,
        
        //objects
        commentBeingEdited:undefined,
        emailTemplates:undefined,
        imagePath:undefined,
        
        //strings
        currentSelectedFulfillmentBatchItemID: "",
        fulfillmentBatchId:undefined,

        //empty collections
        smFulfillmentBatchItemCollection:undefined,
        lgFulfillmentBatchItemCollection:undefined,
        currentRecordOrderDetail:undefined,
        commentsCollection: undefined,
        orderFulfillmentItemsCollection:undefined,
        emailCollection:undefined,
        printCollection:undefined,

        //arrays
        accountNames:[],
        orderDeliveryAttributes:[],
        unassignedContainerItems:{},
        orderItem:{},
        loading: false,
        tableSelections: {
            table1: [],
            table2: []
        },
        boxes:[{}]
    };
    private updateLock:Boolean = false;
    private selectedValue:string = "";
    // Middleware - Logger - add this into the store declaration to log all calls to the reducer.
    public loggerEpic = (...args) => {
        return args;
    }

    /**
     * The reducer is responsible for modifying the state of the state object into a new state.
     */
    public orderFulfillmentStateReducer:FluxStore.Reducer = (state:any, action:FluxStore.Action<any>):Object => {
        switch(action.type) {
            case actions.TOGGLE_FULFILLMENT_LISTING:
                this.state.showFulfillmentListing = !this.state.showFulfillmentListing;
                return {...this.state, action};
            
            case actions.ADD_BATCH:
                return {...state, action};
            
            case actions.SETUP_BATCHDETAIL:
                //Setup the detail
                if (action.payload.fulfillmentBatchId != undefined){
                    this.state.fulfillmentBatchId = action.payload.fulfillmentBatchId;
                }
                this.setupFulfillmentBatchDetail();
                return {...this.state, action}
            
            case actions.UPDATE_BATCHDETAIL:
            
                return {...this.state, action}
            
            case actions.TOGGLE_BATCHLISTING:
            
                //Toggle the listing from expanded to half size.
                this.state.expandedFulfillmentBatchListing = !this.state.expandedFulfillmentBatchListing;
                return {...this.state, action}
            
            case actions.TOGGLE_EDITCOMMENT:
            
                //Update the comment.
                this.state.editComment = !this.state.editComment;
                if (this.state.editComment == true){
                    this.state.commentBeingEdited = action.payload.comment;
                }else{
                    this.state.commentBeingEdited = undefined;
                }
                return {...this.state, action}
            
            case actions.SAVE_COMMENT_REQUESTED:
            
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
                return {...this.state, action}
            
            case actions.DELETE_COMMENT_REQUESTED:
                this.deleteComment(action.payload.comment);
                this.state.editComment = false;
                this.state.commentBeingEdited = undefined;
                return {...this.state, action}
            
            case actions.CREATE_FULFILLMENT_REQUESTED:
                //create all the data
                this.fulfillItems(action.payload.viewState, false);
                return {...this.state, action}
             
             case actions.SETUP_ORDERDELIVERYATTRIBUTES:
                this.createOrderDeliveryAttributeCollection();
                return {...this.state, action}
            
            case actions.DELETE_FULFILLMENTBATCHITEM_REQUESTED:
                this.deleteFulfillmentBatchItem();
                return {...this.state, action}
    
            case actions.PRINT_LIST_REQUESTED:
                this.getPrintList();
                return {...this.state, action}
            
            case actions.EMAIL_LIST_REQUESTED:
                this.getEmailList();
                return {...this.state, action}
            
            case actions.UPDATE_BOX_DIMENSIONS:
                this.updateBoxDimensions(action.payload.box);
                return {...this.state, action}
                
            case actions.ADD_BOX:
                this.addNewBox();
                return {...this.state, action}
            
            case actions.REMOVE_BOX:
                this.removeBox(action.payload.index);
                return {...this.state, action}
                
            case actions.SET_DELIVERY_QUANTITIES:
                this.setDeliveryQuantities();
                return {...this.state, action}
                
            case actions.UPDATE_CONTAINER_ITEM_QUANTITY:
                this.updateContainerItemQuantity(action.payload.containerItem, action.payload.newValue);
                return {...this.state, action}
            
            case actions.SET_UNASSIGNED_ITEM_CONTAINER:
                this.setUnassignedItemContainer(action.payload.skuCode, action.payload.container);
                return {...this.state,action}
            
            case actions.TOGGLE_LOADER:
                this.state.loading = !this.state.loading;
                return {...this.state, action}
            
            default:
                return this.state;
        }
    } 
    
    /**
     *  Store stream. Set the initial state of the typeahead using startsWith and then scan. 
     *  Scan, is an accumulator function. It keeps track of the last result emitted, and combines
     *  it with the newest result. 
     */
    public orderFulfillmentStore:FluxStore.IStore;

    //@ngInject
    constructor(public $timeout, public observerService, public $hibachi, private collectionConfigService, private listingService, public $rootScope, public selectionService){

        //To create a store, we instantiate it using the object that holds the state variables,
        //and the reducer. We can also add a middleware to the end if you need.
        this.orderFulfillmentStore = new FluxStore.IStore( this.state, this.orderFulfillmentStateReducer );
        this.observerService.attach(this.swSelectionToggleSelectionfulfillmentBatchItemTable2, "swSelectionToggleSelectionfulfillmentBatchItemTable2", "swSelectionToggleSelectionfulfillmentBatchItemTableListener");
        
    }

    /** When a row is selected, remove the other selections.  */
    public swSelectionToggleSelectionfulfillmentBatchItemTable2 = (args) => {
        if(args.selectionid != "fulfillmentBatchItemTable2"){
            return;
        }
        
        if (args.action === "uncheck"){
            if(this.selectedValue == args.selection){
                this.selectedValue = undefined;
            }
            return;
        }
        //Are any previously checked?
        if (args.action === "check" 
            && args.selection != undefined 
            && args.selection != this.selectedValue
            && args.selectionid == "fulfillmentBatchItemTable2"){
            
            //set the selection.
            //save the selected value
            var current = "";
            if (this.selectedValue != undefined && this.selectedValue.length){
                current = this.selectedValue;
                
                this.selectedValue = args.selection;
                //remove that old value
                
                this.selectionService.removeSelection("fulfillmentBatchItemTable2", current);
                this.state.currentSelectedFulfillmentBatchItemID = this.selectedValue;
                this.state.useShippingIntegrationForTrackingNumber = true;
                this.state.orderItem = {};
                this.state.boxes = [{}];

                this.state.smFulfillmentBatchItemCollection.getEntity().then((results)=>{
                    for (var result in results.records){
                        let currentRecord = results['records'][result];
                        if (currentRecord['fulfillmentBatchItemID'] == this.state.currentSelectedFulfillmentBatchItemID){
                            //Matched - Save some items from the currentRecord to display.
                            //Get the orderItems for this fulfillment
                            this.createOrderFulfillmentItemCollection(currentRecord['orderFulfillment_orderFulfillmentID']);
                            this.createCurrentRecordDetailCollection(currentRecord);
                            this.createShippingIntegrationOptions(currentRecord);
                            this.emitUpdateToClient();
                        }
                    }
                });
            } else {
                this.selectedValue = args.selection;
            }
        }
    }

    /** Sets up the batch detail page including responding to listing changes. */
    public setupFulfillmentBatchDetail = () => {
        
        //Create the fulfillmentBatchItemCollection
        this.createLgOrderFulfillmentBatchItemCollection();
        this.createSmOrderFulfillmentBatchItemCollection();
        this.getOrderFulfillmentEmailTemplates();
        this.getContainerPresetList();
        //Select the initial table row
        //get the listingDisplay store and listen for changes to the listing display state.
        this.listingService.listingDisplayStore.store$.subscribe((update)=>{
            if (update.action && update.action.type && update.action.type == actions.CURRENT_PAGE_RECORDS_SELECTED){
                
                /*  Check for the tables we care about fulfillmentBatchItemTable1, fulfillmentBatchItemTable2
                    Outer table, will need to toggle and set the floating cards to this data.
                    on the first one being selected, go to the shrink view and set the selection on there as well.*/
                        
                if (angular.isDefined(update.action.payload)){
                    if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable1"){
                        
                        //If there is only one item selected, show that detail.
                        if (angular.isDefined(update.action.payload.values) && update.action.payload.values.length == 1){
                            if (this.state.expandedFulfillmentBatchListing){
                                this.state.expandedFulfillmentBatchListing = !this.state.expandedFulfillmentBatchListing;
                            }
                            this.state.currentSelectedFulfillmentBatchItemID = update.action.payload.values[0];
                            
                            //set the selection.
                            if (update.action.payload.values.length && this.state.currentSelectedFulfillmentBatchItemID){
                                let selectedRowIndex = this.listingService.getSelectedBy("fulfillmentBatchItemTable1", "fulfillmentBatchItemID", this.state.currentSelectedFulfillmentBatchItemID);
                                if (selectedRowIndex != -1){
                                this.listingService
                                    .getListing("fulfillmentBatchItemTable2").selectionService
                                        .addSelection(this.listingService.getListing("fulfillmentBatchItemTable2").tableID, 
                                            this.listingService.getListingPageRecords("fulfillmentBatchItemTable2")[selectedRowIndex][this.listingService.getListingBaseEntityPrimaryIDPropertyName("fulfillmentBatchItemTable2")]);
                                }
                            }

                            //use this id to get the record and set it to currentRecordOrderDetail.
                            //*****Need to iterate over the collection and find the ID to match against and get the orderfulfillment collection that matches this record.

                            this.state.smFulfillmentBatchItemCollection.getEntity().then((results)=>{
                                for (var result in results.records){
                                    let currentRecord = results['records'][result];
                                    if (currentRecord['fulfillmentBatchItemID'] == this.state.currentSelectedFulfillmentBatchItemID){
                                        //Matched - Save some items from the currentRecord to display.
                                        //Get the orderItems for this fulfillment
                                        this.createOrderFulfillmentItemCollection(currentRecord['orderFulfillment_orderFulfillmentID']);
                                        this.createCurrentRecordDetailCollection(currentRecord);
                                        this.createShippingIntegrationOptions(currentRecord);
                                        this.emitUpdateToClient();
                                    }
                                }
                            });
                        }
                    }
                    if (angular.isDefined(update.action.payload.listingID) && update.action.payload.listingID == "fulfillmentBatchItemTable2"){
                        //if nothing is selected, go back to the outer view.
                        if (!angular.isDefined(update.action.payload.values) || update.action.payload.values.length == 0){
                            if (this.state.expandedFulfillmentBatchListing == false){
                                this.state.expandedFulfillmentBatchListing = !this.state.expandedFulfillmentBatchListing;
                                //Clear all selections.
                                this.listingService.clearAllSelections("fulfillmentBatchItemTable2");
                                this.listingService.clearAllSelections("fulfillmentBatchItemTable1");
                                this.emitUpdateToClient();
                            }
                        }
                    }
                }
            }
        }); 
    }

    /** During key times when data changes, we would like to alert the client to those changes. This allows us to do that. */
    public emitUpdateToClient = () => {
        this.orderFulfillmentStore.dispatch({
            type: actions.UPDATE_BATCHDETAIL,
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
            //If only 1, add that to the list.
            if (processObject.data.locationID){
                processObject.data.locationIDList = processObject.data.locationID;
            }
            return this.$hibachi.saveEntity("fulfillmentBatch",'',processObject.data, "create");
        }
    }

    /** Creates the orderDelivery - fulfilling the items quantity of items specified, capturing as needed. */
    public fulfillItems = (state:any={}, ignoreCapture:boolean = false) => {
        this.state.loading=true;
        if (state.useShippingIntegrationForTrackingNumber == 1 && (state.shippingIntegrationID == "" || state.shippingIntegrationID == null)) {
            this.state.loading = false;
            alert(this.$rootScope.rbKey('define.invalidShippingIntegration'));
            this.emitUpdateToClient();
            return;
        }
         
        let data:any = {};
        //Add the order information
        data.order = {};
        data.order['orderID'] = this.state.currentRecordOrderDetail['order_orderID'];
        //Add the orderFulfillment.
        data['orderDeliveryID'] = ""; //this indicates the the orderDelivery is being created.
        data['orderFulfillment'] = {};
        data['orderFulfillment']['orderFulfillmentID'] = this.state.currentRecordOrderDetail['fulfillmentBatchItem']['orderFulfillment_orderFulfillmentID'];
        data['trackingNumber'] = state.trackingCode || "";
        data['containers'] = state.boxes || [];
        if (data['trackingNumber'] == undefined || !data['trackingNumber'].length){
            data['useShippingIntegrationForTrackingNumber'] = state.useShippingIntegrationForTrackingNumber || "false";
        }

        //console.log("Batch Information: ", this.state.currentRecordOrderDetail['fulfillmentBatchItem']);
        //Add the orderDelivertyItems as an array with the quantity set to the quantity.
        //Make sure all of the deliveryitems have a quantity set by the user.
        let idx = 1; //coldfusion indexes at 1
        data['orderDeliveryItems'] = [];
        
        for (var orderDeliveryItem in state.orderItem){
            if (state.orderItem[orderDeliveryItem] != undefined){
                if (state.orderItem[orderDeliveryItem] && state.orderItem[orderDeliveryItem] > 0){
                    data['orderDeliveryItems'].push({orderItem: {orderItemID: orderDeliveryItem}, quantity: state.orderItem[orderDeliveryItem]});
                }
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
            data['captureAuthorizedPaymentsFlag'] = false;
            //hidden fields
            data['order'] = {};
            data['order']['orderID'] = this.state.currentRecordOrderDetail['order_orderID'] || "";
            
            //shippingMethod.shippingMethodID
            data['shippingMethod'] = {};
            data['shippingMethod']['shippingMethodID'] = this.state.currentRecordOrderDetail['shippingMethod_shippingMethodID'];
            //shippingAddress.addressID
            data['shippingAddress'] = {};
            data['shippingAddress']['addressID'] = this.state.currentRecordOrderDetail['shippingAddress_addressID'];
            if(data['useShippingIntegrationForTrackingNumber']){
                data['shippingIntegration'] = {integrationID:state.shippingIntegrationID}
            }

        }

        //Create the process object.
        let processObject = this.$hibachi.newOrderDelivery_Create();
        processObject.data = data;
        processObject.data.entityName = "OrderDelivery";
        
        //Basic Information
        processObject.data['location'] = {'locationID': this.$rootScope.slatwall.defaultLocation || "5cacb1d00b20aa339bc5585e13549dda"};//sets a random location for now until batch issue with location is resolved.
        
        //Shipping information.
        processObject.data['containerLabel'] = data.containerLabel || "";
        processObject.data['orderFulfillment']['shippingIntegration'] = data.shippingIntegration || "";
        processObject.data['shippingAddress'] = data.shippingAddress || "";
        processObject.data['containers'] = data.containers;
        processObject.data['useShippingIntegrationForTrackingNumber'] = data.useShippingIntegrationForTrackingNumber || false;
        
        if(state.orderDeliveryAttributes){
            for(let i = 0; i < state.orderDeliveryAttributes.length; i++){
                let attribute = state.orderDeliveryAttributes[i];
                processObject.data[attribute.code] = state[attribute.code];
            }
        }
        
        this.$hibachi.saveEntity("OrderDelivery", '', processObject.data, "create").then((result)=>{
            this.state.loading=false;
            
            if (result.orderDeliveryID != undefined && result.orderDeliveryID != ''){
                return result;
            }
            
            //Sets the next selected value.
            let selectedRowIndex = this.listingService.getSelectedBy("fulfillmentBatchItemTable1", "fulfillmentBatchItemID", this.state.currentSelectedFulfillmentBatchItemID);
            
            //clear first
            this.listingService.clearAllSelections("fulfillmentBatchItemTable1");
            this.listingService.clearAllSelections("fulfillmentBatchItemTable2");
            
            //then select the next.
            if (selectedRowIndex != -1){
                //Set the next one.
                selectedRowIndex = selectedRowIndex+1;
                this.listingService
                    .getListing("fulfillmentBatchItemTable1").selectionService
                        .addSelection(this.listingService.getListing("fulfillmentBatchItemTable1").tableID, 
                            this.listingService.getListingPageRecords("fulfillmentBatchItemTable1")[selectedRowIndex][this.listingService.getListingBaseEntityPrimaryIDPropertyName("fulfillmentBatchItemTable1")]);
           
                
                let args = {
                    selection:this.listingService.getListingPageRecords("fulfillmentBatchItemTable2")[selectedRowIndex][this.listingService.getListingBaseEntityPrimaryIDPropertyName("fulfillmentBatchItemTable2")],
                    selectionid:"fulfillmentBatchItemTable2",
                    action:"check"
                };
                
                this.swSelectionToggleSelectionfulfillmentBatchItemTable2(args);
            }
            //refresh.
            //Scroll to the quantity div.
            //scrollTo(orderItemQuantity_402828ee57e7a75b0157fc89b45b05c4)

        },(error)=>{
            this.state.loading=false;
        });
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

    /** Deletes a fulfillment batch item. */
    public deleteFulfillmentBatchItem = () => {
        if (this.state.currentSelectedFulfillmentBatchItemID){
            let fulfillmentBatchItem = {"fulfillmentBatchItemID" : this.state.currentSelectedFulfillmentBatchItemID};//get current fulfillmentBatchItem;
            if (fulfillmentBatchItem.fulfillmentBatchItemID != undefined) {
                this.$hibachi.saveEntity("fulfillmentBatchItem", fulfillmentBatchItem.fulfillmentBatchItemID, fulfillmentBatchItem, "delete").then((result) => {
                    window.location.reload(false);
                });
            }
        }
    }
    
    public createShippingIntegrationOptions = (currentRecord)=>{
        this.$hibachi.getPropertyDisplayOptions("OrderFulfillment",{property:"ShippingIntegration",entityID:currentRecord['orderFulfillment_orderFulfillmentID']}).then(response=>{
            this.state.shippingIntegrationOptions = response.data;
            if(currentRecord['orderFulfillment_shippingIntegration_integrationID'].trim() != "" && currentRecord['orderFulfillment_shippingIntegration_integrationID'] != null){
                this.state.shippingIntegrationID = currentRecord['orderFulfillment_shippingIntegration_integrationID'];
            } else {
                this.state.shippingIntegrationID = this.state.shippingIntegrationOptions[0]['VALUE'];
            }
        });
    }

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
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingMethod.shippingMethodID");
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingMethod.shippingMethodName");
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.addressID");
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.city");
        this.state.currentRecordOrderDetail.addDisplayProperty("shippingAddress.stateCode");
        this.state.currentRecordOrderDetail.addDisplayProperty("orderFulfillmentStatusType.typeName");
        this.state.currentRecordOrderDetail.addDisplayProperty("calculatedShippingIntegrationName");
        
        
        this.state.currentRecordOrderDetail.getEntity().then( (entityResults) => {
            if (entityResults['pageRecords'].length){
                this.state.currentRecordOrderDetail = entityResults['pageRecords'][0];
                //set the capturable amount to the amount that still needs to be paid on this order.
                if (this.state.currentRecordOrderDetail){
                    this.state.capturableAmount = this.state.currentRecordOrderDetail['order_paymentAmountDue'];
                }
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
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingIntegration.integrationID");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.lastMessage");
        this.state.lgFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.lastStatusCode");
        this.state.lgFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.state.fulfillmentBatchId, "=");
        this.state.lgFulfillmentBatchItemCollection.setAllRecords(true);
     }

     /**
     * Get a collection of orderFulfillment email templates.
     */
     private getOrderFulfillmentEmailTemplates = ():void => {
        let emailTemplates = this.collectionConfigService.newCollectionConfig("EmailTemplate");
        emailTemplates.addFilter("emailTemplateObject", "orderFulfillment", "=");
        emailTemplates.getEntity().then((emails)=>{
            if (emails['pageRecords'].length){
                this.state.emailTemplates = emails['pageRecords'];
                this.emitUpdateToClient();
            }
        });
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
        this.state.smFulfillmentBatchItemCollection.addDisplayProperty("orderFulfillment.shippingIntegration.integrationID");
        this.state.smFulfillmentBatchItemCollection.addFilter("fulfillmentBatch.fulfillmentBatchID", this.state.fulfillmentBatchId, "=");
        this.state.smFulfillmentBatchItemCollection.setAllRecords(true);
     }

     /**
     * Setup the initial orderFulfillment Collection.
     */
     private createLocationCollection = () => {
        this.state.locationCollection = this.collectionConfigService.newCollectionConfig("FulfillmentBatchLocation");
        this.state.locationCollection.addDisplayProperty("locationID");
        this.state.locationCollection.addDisplayProperty("fulfillmentBatchID");
        this.state.locationCollection.addFilter("fulfillmentBatchID", this.state.fulfillmentBatchId, "=");
        return this.state.locationCollection.getEntity().then( (result) => {return (result.pageRecords.length)?result.pageRecords:[];} );
     }

    /**
     * Setup the initial print template -> orderFulfillment Collection.
     */
     private getPrintList = () => {
        this.state.printCollection = this.collectionConfigService.newCollectionConfig("PrintTemplate");
        this.state.printCollection.addDisplayProperty("printTemplateID");
        this.state.printCollection.addDisplayProperty("printTemplateName");
        this.state.printCollection.addDisplayProperty("printTemplateObject");
        this.state.printCollection.addFilter("printTemplateObject", 'OrderFulfillment', "=");
        this.state.printCollection.getEntity().then( 
            (result) => {
                this.state.printCollection = result.pageRecords || [];
            });
     }

    /**
     * Setup the initial email template -> orderFulfillment Collection.
     */
     private getEmailList = () => {
        this.state.emailCollection = this.collectionConfigService.newCollectionConfig("EmailTemplate");
        this.state.emailCollection.addDisplayProperty("emailTemplateID");
        this.state.emailCollection.addDisplayProperty("emailTemplateName");
        this.state.emailCollection.addDisplayProperty("emailTemplateObject");
        this.state.emailCollection.addFilter("emailTemplateObject", 'OrderFulfillment', "=");
        this.state.emailCollection.getEntity().then( 
            (result) => {
                this.state.emailCollection = result.pageRecords || [];
            });
     }
     
    /**
    * Get Container Preset collection
    */
    private getContainerPresetList = () => {
        this.state.containerPresetCollection = this.collectionConfigService.newCollectionConfig("ContainerPreset");
        this.state.containerPresetCollection.addDisplayProperty("containerPresetID");
        this.state.containerPresetCollection.addDisplayProperty("containerName");
        this.state.containerPresetCollection.addDisplayProperty("height");
        this.state.containerPresetCollection.addDisplayProperty("width");
        this.state.containerPresetCollection.addDisplayProperty("depth");
        this.state.containerPresetCollection.getEntity().then((result) => {
            this.state.containerPresetCollection = result.pageRecords || [];
        });
    }
     
    /**
    * Update the dimensions of a box on the shipment
    */
    private updateBoxDimensions = (box) => {
        if(!box.containerPreset){
            return;
        }
        box.containerName = box.containerPreset.containerName;
        box.height = box.containerPreset.height;
        box.width = box.containerPreset.width;
        box.depth = box.containerPreset.depth;
    }
     
     /**
     * Add a box to the shipment
     */
     private addNewBox = () => {
        this.state.boxes.push({containerItems:[]});
     }
     
     /**
     * Remove a box from the shipment
     */
     private removeBox = (index) => {
        this.state.boxes.splice(index,1);
     }

    /**
     * Returns  orderFulfillmentItem Collection given an orderFulfillmentID.
     */
     private createOrderFulfillmentItemCollection = (orderFulfillmentID):void => {
        let collection = this.collectionConfigService.newCollectionConfig("OrderItem");
        collection.addDisplayProperty("orderFulfillment.orderFulfillmentID");
        collection.addDisplayProperty("sku.skuCode");
        collection.addDisplayProperty("sku.skuID");
        collection.addDisplayProperty("sku.product.productName");
        collection.addDisplayProperty("sku.skuName");
        // collection.addDisplayProperty("sku.imagePath", "Path", {persistent: false});
        // collection.addDisplayProperty("sku.imageFileName", "File Name", {persistent: false});
        collection.addDisplayAggregate("sku.stocks.calculatedQOH","SUM","QOH");
        collection.addDisplayProperty("quantity");
        collection.addDisplayAggregate("orderDeliveryItems.quantity","SUM","quantityDelivered");
        collection.addDisplayProperty("orderItemID");
        collection.addFilter("orderFulfillment.orderFulfillmentID", orderFulfillmentID, "=");
        collection.addFilter("sku.stocks.location.locationID", this.$rootScope.slatwall.defaultLocation, "=");
        collection.setPageShow(100);
        collection.getEntity().then((orderItems)=>{
            if (orderItems && orderItems.pageRecords && orderItems.pageRecords.length){
                this.state.orderFulfillmentItemsCollection = orderItems['pageRecords'];
            }
            else if (orderItems && orderItems.records && orderItems.records.length){
                this.state.orderFulfillmentItemsCollection = orderItems['records'];
            }
            else{
                this.state.orderFulfillmentItemsCollection = [];
            }
            let skuIDs = [];
            for(let i = 0; i < this.state.orderFulfillmentItemsCollection.length; i++){
                skuIDs[i] = this.state.orderFulfillmentItemsCollection[i]['sku_skuID'];
            }
            this.$rootScope.slatwall.getResizedImageByProfileName('small',skuIDs.join(',')).then(result=>{
                if(!angular.isDefined(this.$rootScope.slatwall.imagePath)){
                    this.$rootScope.slatwall.imagePath = {};
                }
                this.state.imagePath = this.$rootScope.slatwall.imagePath;
            });
            
            this.emitUpdateToClient();
        });
     }
     
     /**
      * Submits delivery item quantity information
      */
    private setDeliveryQuantities = () =>{
        let orderDeliveryItems = [];
        for(let key in this.state.orderItem){
            orderDeliveryItems.push(
                {
                    orderItem:{
                        orderItemID:key
                    },
                    quantity:this.state.orderItem[key]
                });
        }
        
        let urlString = this.$hibachi.getUrlWithActionPrefix()+'api:main.post';
        let params = {
            entityName:'OrderDelivery',
            context:'getContainerDetails',
            orderDeliveryItems:orderDeliveryItems,
            apiFormat:true
        };
		let request = this.$hibachi.requestService.newAdminRequest(urlString,params);
		request.promise.then(result=>{
		    if(!result.containerStruct){
		        this.state.boxes = [{containerItems:[]}];
		        return;
		    }

		    this.state.unassignedContainerItems = {};
		    let boxes = [];
		    for(let key in result.containerStruct ){
		        if(Array.isArray(result.containerStruct[key])){
		            let containerArray = result.containerStruct[key];
		            for(let i = 0; i < containerArray.length; i++){
		                let container = containerArray[i];
		                //Do this for UI tracking
		                container.containerPreset = {
		                    //Don't judge me
		                    containerPresetID: container.containerPresetID
		                }
		                boxes.push(container);
		            }
		        }
		    }
		    this.state.boxes = boxes;
            this.emitUpdateToClient();
		})
    }
    
    /**
     * Updates the quantity of a container item.
     */ 
    private updateContainerItemQuantity = (containerItem, newQuantity) =>{
        newQuantity = +newQuantity;
        if(newQuantity == undefined || isNaN(newQuantity)){
            return;
        }
        if(newQuantity < 0){
            newQuantity = 0;
        }
        
        if(newQuantity > containerItem.packagedQuantity){
            let quantityDifference = newQuantity - containerItem.packagedQuantity;
            if(!this.state.unassignedContainerItems[containerItem.sku.skuCode]){
                containerItem.newQuantity = containerItem.packagedQuantity;
                return;
            }else if(this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity <= quantityDifference){
                newQuantity = containerItem.packagedQuantity + this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity;
                quantityDifference = newQuantity - containerItem.packagedQuantity;
                containerItem.newQuantity = newQuantity;
                containerItem.packagedQuantity = newQuantity;
                this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity -= quantityDifference;
            }
        }else if(newQuantity < containerItem.packagedQuantity){
            if(!this.state.unassignedContainerItems[containerItem.sku.skuCode]){
                this.state.unassignedContainerItems[containerItem.sku.skuCode] = {
                    sku:containerItem.sku,
                    item:containerItem.item,
                    quantity:0
                };
            }
            this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity += containerItem.packagedQuantity - newQuantity;
            containerItem.packagedQuantity = newQuantity;
            containerItem.newQuantity = newQuantity;
        }
        if(this.state.unassignedContainerItems[containerItem.sku.skuCode].quantity == 0){
            delete this.state.unassignedContainerItems[containerItem.sku.skuCode];
        }
        this.cleanUpContainerItems();
        this.emitUpdateToClient();
    }
    
    public setUnassignedItemContainer = (skuCode,container) =>{
        let containerItem = container.containerItems.find(item=>{
            return item.sku.skuCode == skuCode;
        });
        if(!containerItem){
            containerItem = {
                item:this.state.unassignedContainerItems[skuCode].item,
                sku:this.state.unassignedContainerItems[skuCode].sku,
                packagedQuantity:0
            };
            container.containerItems.push(containerItem);
        }
        containerItem.packagedQuantity += this.state.unassignedContainerItems[skuCode].quantity;
        delete this.state.unassignedContainerItems[skuCode];
        this.cleanUpContainerItems();
        this.emitUpdateToClient();
    }
    
    /**
     * Removes any container items from their container if the packaged quantity is zero
     */
    private cleanUpContainerItems = ()=>{
        for(let i = 0; i < this.state.boxes.length; i++){
            let box = this.state.boxes[i];
            for(let j = box.containerItems.length-1; j >= 0; j--){
                let containerItem = box.containerItems[j];
                if(containerItem.packagedQuantity == 0){
                    box.containerItems.splice(j,1);
                }else{
                    containerItem.newQuantity = containerItem.packagedQuantity;
                }
            }
        }
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
