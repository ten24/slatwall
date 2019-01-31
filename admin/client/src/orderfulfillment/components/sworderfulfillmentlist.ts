/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

module FulfillmentsList {
    export enum Views {
        Fulfillments,
        Items
    }
    export enum ofisStatusType {
        "unavailable",
        "partial",
        "available",
    }
    export type CollectionFilterValue =  "partial"|"available"|"unavailable"|"location"|"paid";
}

/**
 * Fulfillment List Controller
 */
class SWOrderFulfillmentListController {
    private orderFulfillmentCollection:any;
    private orderItemCollection:any;
    private orderCollectionConfig:any;
    private orderFulfillments:any[];
    private filters:{};
    private view:number;
    private collections:any;
    private refreshFlag:boolean;
    private usingRefresh:boolean=false;
    public addingBatch=false;
    public views:any;
    public total:number;
    public formData:{};
    public processObject:any;
    public addSelection:Function;
    public FulfillmentsList=FulfillmentsList;
    public customOrderFulfillmentCollectionConfig:string;
    public customOrderItemCollectionConfig:string;
    private state:any;

    // @ngInject
    constructor(
            private $hibachi, 
            private $timeout, 
            private collectionConfigService, 
            private observerService, 
            private utilityService, 
            private $location, 
            private $http, 
            private $window, 
            private typeaheadService, 
            private orderFulfillmentService,
            private listingService
        ){

        //Set the initial state for the filters.
        this.filters = { "unavailable": false, "partial": false, "available": false , "paid": false};
        this.collections = [];

        //Some setup for the fulfillments collection.
        this.createOrderFulfillmentCollection();
        this.createOrderItemCollection();

        //some view setup.
        this.views = FulfillmentsList.Views;

        this.setView(this.views.Fulfillments);

        //add both collections into the collection object. Removed 0 elements (insert only).
        this.collections.push(this.orderFulfillmentCollection);
        this.collections.push(this.orderItemCollection);

        //Setup the processObject
        this.setProcessObject(this.$hibachi.newFulfillmentBatch_Create());

        //adds the two default filters to start.
        //this.addFilter('available', true);
        //this.addFilter('partial', true);
        var collection = this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
        if (collection.entityName = "OrderFulfillment"){
            this.orderFulfillmentCollection = collection;
        }else{
            this.orderItemCollection = collection;
        }

        //Attach our listeners for selections on both listing displays.
        this.observerService.attach(this.swSelectionToggleSelectionorderFulfillmentCollectionTableListener, "swSelectionToggleSelectionorderFulfillmentCollectionTable", "swSelectionToggleSelectionorderFulfillmentCollectionTableListener");
        this.observerService.attach(this.swSelectionToggleSelectionorderItemCollectionTableListener, "swSelectionToggleSelectionorderItemCollectionTable", "swSelectionToggleSelectionorderItemCollectionTableListener");
        this.observerService.attach(this.collectionConfigUpdatedListener, "collectionConfigUpdated", "collectionConfigUpdatedListener");
        

        //Subscribe to state changes in orderFulfillmentService
        this.orderFulfillmentService.orderFulfillmentStore.store$.subscribe((state)=>{
            this.state = state;
            if (state && state.showFulfillmentListing == true){
                //set the view.
                this.setView(this.views.Fulfillments);
            }else{
                this.setView(this.views.Items);
            }
            this.getCollectionByView(this.getView());
        });

        //Subscribe for state changes to the typeahead.
        this.typeaheadService.typeaheadStore.store$.subscribe((update)=>{
            if (update.action && update.action.payload){
                this.recieveNotification(update.action);
            }
        });
    }
    
     private getBaseCollection = (entity):any=>{
         console.log(entity);
        var collection = this.collectionConfigService.newCollectionConfig(entity);
        switch(entity){
            case "OrderFulfillment":
                if(this.customOrderFulfillmentCollectionConfig){
                    collection.loadJson(this.customOrderFulfillmentCollectionConfig);
                }
                break;
            case "OrderItem":
                if(this.customOrderItemCollectionConfig){
                    collection.loadJson(this.customOrderItemCollectionConfig);
                }
                break;
            default:
            break;
        }
        return collection;
     }
    

    /**
     * Implements a listener for the orderFulfillment selections
     */
    public swSelectionToggleSelectionorderFulfillmentCollectionTableListener = (callBackData) => {
        let processObject = this.getProcessObject();
        if (this.isSelected(callBackData.action)){
             processObject['data']['orderFulfillmentIDList'] = this.listAppend(processObject.data['orderFulfillmentIDList'], callBackData.selection);
        }else{
             processObject['data']['orderFulfillmentIDList'] = this.listRemove(processObject.data['orderFulfillmentIDList'], callBackData.selection);
        }
        this.setProcessObject(processObject);
    };

    public collectionConfigUpdatedListener = (callBackData) => {
        if (this.usingRefresh == true){
            this.refreshFlag=true;
        }
    };

    public orderFulfillmentCollectionTablepageRecordsUpdatedListener = (callBackData) => {
        if (callBackData){
            this.updateCollectionsInView();
            this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
        }

    };


    /**
     * Implements a listener for the orderItem selections
     */
    public swSelectionToggleSelectionorderItemCollectionTableListener = (callBackData) => {
        let processObject = this.getProcessObject();
        if (this.isSelected(callBackData.action)){
             processObject['data']['orderItemIDList'] = this.listAppend(processObject['data']['orderItemIDList'], callBackData.selection)
        }else{
             processObject['data']['orderItemIDList'] = this.listRemove(processObject['data']['orderItemIDList'], callBackData.selection);
        }

    };

    /**
     * Adds a string to a list.
     */
    listAppend (str:string, subStr:string):string {
        return this.utilityService.listAppend(str, subStr, ",");
    }

    /**
     * Removes a substring from a string.
     * str: The original string.
     * subStr: The string to remove.
     */
     listRemove (str:string, subStr:string):string {
        return this.utilityService.listRemove(str, subStr);
     }

    /**
     * returns true if the action is selected
     */
     public isSelected = (test):boolean => {
        if (test == "check") { return true; } else { return false };
     }

    /**
     * Each collection has a view. The view is maintained by the enum. This Returns
     * the collection for that view.
     */
     public getCollectionByView = (view:number):any => {
        if (view == undefined || this.collections == undefined){
            return;
        }

        return this.collections[view];
     }

     public updateCollectionsInView = ():void => {
         this.collections = [];
         this.collections.push(this.orderFulfillmentCollection);
         this.collections.push(this.orderItemCollection);

     }

    /**
     * Setup the initial orderFulfillment Collection.
     */
     private createOrderFulfillmentCollection = ():void => {
        this.orderFulfillmentCollection = this.getBaseCollection("OrderFulfillment");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID", "ID");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderType.systemCode", "Order Type");
        this.orderFulfillmentCollection.addDisplayProperty("fulfillmentMethod.fulfillmentMethodType", "Fulfillment Method Type");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber", "Order Number");
        this.orderFulfillmentCollection.addDisplayProperty("order.account.calculatedFullName", "Full Name");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
        this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
        this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode", "State");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status");
        this.orderFulfillmentCollection.addDisplayProperty("estimatedShippingDate");
        //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentItems.stock.location.locationID", "Stock Location");
        //this.orderFulfillmentCollection.addFilter("orderFulfillmentInvStatType.systemCode", "ofisAvailable", "=");
        this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "=");
        this.orderFulfillmentCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
        this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=");
        this.orderFulfillmentCollection.addFilter("fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
        
        
     }

     private createOrderFulfillmentCollectionWithStatus = (status):void => {
        
        status = status.trim();

        this.orderFulfillmentCollection = this.getBaseCollection("OrderFulfillment");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID", "ID");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber", "Order Number");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
        this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
        this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode", "State");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status");
        //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentInvStatType.systemCode", "Availability");
        //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentItems.stock.location.locationID", "Stock Location");
        this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "!=");
        this.orderFulfillmentCollection.addFilter("fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
        //Shipping
        this.orderFulfillmentCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
        this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=");
       

        if (status){
            console.log("S", status, status=="available");
            if(status == "unavailable"){
                this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.sku.calculatedQOH", "0", "<=");
            }else if(status == "available"){
                console.log("Made it.");
                this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.sku.calculatedQOH", "0", ">");
            }else if(status == "paid"){
                this.orderFulfillmentCollection.addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">");
            }
        
        }

        this.orderFulfillmentCollection.getEntity().then((result)=>{
            //refreshes the page.
            this.collections[0] = this.orderFulfillmentCollection;
            this.view = this.views.Fulfillments;
            this.refreshFlag=false;
        });



     }

     private createOrderItemCollectionWithStatus = (status):void => {
        delete this.orderItemCollection;
        this.view = undefined;

        this.orderItemCollection = this.getBaseCollection("OrderItem");
        this.orderItemCollection.addDisplayProperty("orderItemID", "ID");
        this.orderItemCollection.addDisplayProperty("order.orderNumber", "Order Number");
        this.orderItemCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
        this.orderItemCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
        this.orderItemCollection.addDisplayProperty("shippingAddress.stateCode", "State");
        this.orderItemCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status");
        this.orderItemCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "==");
        this.orderItemCollection.addFilter("fulfillmentMethod.fulfillmentMethodName", "Shipping", "=");
        //Shipping
        this.orderItemCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
        this.orderItemCollection.addFilter("order.orderNumber", "", "!=");
       
        //"order.paymentAmountDue", "0", ">", {persistent: false}
        

        if (status){
            if (status == "partial"){
                this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", ">", "AND");
            }else if(status == "unavailable"){
                this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", "<=", "AND");
            }else if(status == "available"){
                this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", ">", "AND");
            }else if(status == "paid"){
                this.orderFulfillmentCollection.addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">", "AND");
            }

        }

        this.orderItemCollection.getEntity().then((result)=>{
            //refreshes the page.
            this.collections[0] = this.orderItemCollection;
            this.view = this.views.Fulfillments;
        });


     }

     private createOrderFulfillmentCollectionWithFilterMap = (filterMap:Map<String, any>):void => {

        delete this.orderFulfillmentCollection;
        this.view = undefined;

        this.orderFulfillmentCollection = this.getBaseCollection("OrderFulfillment");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID", "ID");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber", "Order Number");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime", "Date Started");
        this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName", "Shipping Method");
        this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode", "State");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentStatusType.typeName", "Status"); 
        this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "=");
        this.orderFulfillmentCollection.addFilter("fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
        //Shipping
        this.orderFulfillmentCollection.addFilter("order.orderStatusType.systemCode", "ostNew", "=");
        this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=");
        //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentInvStatType.systemCode", "Availability");
        //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentItems.stock.location.locationID", "Stock Location");


        //Build the collection using just the correct filters.

        //Check the filters for multiple true
        var hasMultipleEnabled = false;
        var filterCount = 0;
        filterMap.forEach((v, k) => {
            if (filterMap.get(k) === true){
                filterCount++;

            }
        });

        if (filterCount > 1){
            hasMultipleEnabled = true;
        }

        //Add the filters.
        filterMap.forEach((v, k) => {
            var systemCode = k;
           //handle truth
            if (filterMap.get(k) === true){
                if (k){
                    if(k == "unavailable"){
                        this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", "=", "AND");
                    }else if(k == "available"){
                        this.orderFulfillmentCollection.addFilter("sku.calculatedQOH", "0", ">", "AND");
                    }else if(k == "paid"){
                        
                        console.log("Apply Paid Filter");
                        this.orderFulfillmentCollection.addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">", "AND");
                    }
        
                }

            }
            //handle false
            if (filterMap.get(k) === false && filterMap.get(k) != undefined){
                if (systemCode.length){
                    //this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.sku.calculatedQATS", systemCode, "!=", 'AND');
                    //this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstFulfilled", "!=", "AND");
                    //this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=", "AND");
                }
            }
        });

        if (this.getCollectionByView(this.getView())){
            this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
        }



     }

    /**
     * Setup the initial orderItem Collection.
     */
    private createOrderItemCollection = ():void => {
        this.orderItemCollection = this.getBaseCollection("OrderItem");
        this.orderItemCollection.addDisplayProperty("orderItemID");
        this.orderItemCollection.addDisplayProperty("sku.skuCode");
        this.orderItemCollection.addDisplayProperty("sku.calculatedSkuDefinition");
        this.orderItemCollection.addDisplayProperty("sku.calculatedQOH");
        this.orderItemCollection.addDisplayProperty("stock.location.locationName");
        this.orderItemCollection.addDisplayProperty("orderFulfillment.fulfillmentMethod.fulfillmentMethodType","Fulfillment Method Type");
        this.orderItemCollection.addDisplayProperty("quantity");
        this.orderItemCollection.addDisplayProperty("order.orderNumber");
        this.orderItemCollection.addDisplayProperty("order.orderOpenDateTime");
        this.orderItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentStatusType.typeName");
        this.orderItemCollection.addDisplayProperty("sku.product.productName");
        this.orderItemCollection.addFilter("orderFulfillment.orderFulfillmentStatusType.systemCode", "ofstUnfulfilled", "=");
        this.orderItemCollection.addFilter("orderFulfillment.fulfillmentMethod.fulfillmentMethodType", "shipping", "=");
        this.orderItemCollection.addFilter("order.orderNumber", "", "!=");
    }

    /**
     * Toggle the Status Type filters on and off.
     */
    public toggleFilter = (filterName):void => {
        this.filters[filterName] = !this.filters[filterName];

        if (this.filters[filterName]){
            this.addFilter(filterName, true);
            return;
        }
        this.removeFilter(filterName, false);
    }

    /**
     * Toggle between views. We refresh the collection everytime we set the view.
     */
    public setView = (view:number):void => {
        this.view = view;
        if (this.getCollectionByView(this.getView())){
            this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
        }
    }

    //ACTION CREATOR: This will toggle the listing between its 2 states (orderfulfillments and orderitems)
    public toggleOrderFulfillmentListing = () => {
        this.orderFulfillmentService.orderFulfillmentStore.dispatch({type: "TOGGLE_FULFILLMENT_LISTING", payload: {}});
        //reset the selections because you can't mix and match.
        this.getProcessObject().data.orderFulfillmentIDList = "";
        this.getProcessObject().data.orderItemIDList = "";
        try{
        this.orderFulfillmentService.listingService.clearAllSelections("orderFulfillmentCollectionTable");
        this.orderFulfillmentService.listingService.clearAllSelections("orderItemCollectionTable");
        }catch(e){
            //no need to say anything.
        }
        this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
    }

    /**
     * Returns the current view.
     */
    public getView = ():number => {
        return this.view;
    }

    /**
     * Refreshes the view
     */
    public refreshPage = () => {
        if (this.utilityService.isMultiPageMode()){
            window.location.reload();
        }
    }
    /**
     * Initialized the collection so that the listingDisplay can you it to display its data.
     */
    public refreshCollectionTotal = (collection):any => {

        if (collection){
            collection.getEntity().then((response)=>{
                this.total = response.recordsCount;
                this.refreshFlag=false;
            });
            return collection;
        }

    }

    public getRecordsCount = (collection):any => {
        this.total = collection.recordsCount;
        this.refreshFlag=false;
    }

    /**
     * Adds one of the status type filters into the collectionConfigService
     * @param key: FulfillmentsList.CollectionFilterValues {'partial' | 'available' | 'unavailable' | 'location'}
     * @param Vvalue: boolean: {true|false}
     */

    public addFilter = (key:FulfillmentsList.CollectionFilterValue, value:boolean):void => {

        this.$timeout(()=>{
            this.refreshFlag = true;
        }, 1);


        //Always keep the orderNumber filter.
        
            //If there is only one filter group add a second. otherwise add to the second.
            var filterGroup = [];
            var filter = {};
            if (this.getCollectionByView(this.getView()) && this.getCollectionByView(this.getView()).baseEntityName == "OrderFulfillment"){
                if (value == true){

                    if (key == "partial"){
                        this.createOrderFulfillmentCollectionWithStatus("partial");
                    }
                    if (key == "available"){
                        this.createOrderFulfillmentCollectionWithStatus("available");
                    }
                    if (key == "unavailable"){
                        this.createOrderFulfillmentCollectionWithStatus("unavailable");
                    }
                    if (key == "location" && value != undefined){
                        filter = this.getCollectionByView(this.getView()).createFilter("orderFulfillmentItems.stock.location.locationName", value, "=","OR",false);
                    }
                    if (key == "paid" && value != undefined){
                        console.log("Applied Paid Filter");
                        this.getCollectionByView(this.getView()).addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">");
                        
                    }

                }
                if (value = false){
                    this.createOrderFulfillmentCollection();
                }
            }else{
                if (value == true){
                    
                    if (key == "partial"){
                        this.createOrderItemCollectionWithStatus("partial");
                    }
                    if (key == "available"){
                        this.createOrderItemCollectionWithStatus("available");
                    }
                    if (key == "unavailable"){
                        this.createOrderItemCollectionWithStatus("unavailable");
                    }
                    if (key == "location" && value != undefined){
                        filter = this.getCollectionByView(this.getView()).createFilter("stock.location.locationName", value, "=","OR",false);
                    }
                    if (key == "paid" && value != undefined){
                        console.log("Applied Paid Filter");
                        this.getCollectionByView(this.getView()).addFilter("order.calculatedPaymentAmountReceivedTotal", "0", ">");
                        
                    }

                }
                if (value = false){
                    this.createOrderItemCollection();
                }
            }
        
        this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
    }

    /**
     * Adds one of the status type filters into the collectionConfigService
     * @param key: FulfillmentsList.CollectionFilterValues {'partial' | 'available' | 'unavailable' | 'location'}
     * @param Vvalue: boolean: {true|false}
     */

    public removeFilter = (key:FulfillmentsList.CollectionFilterValue, value:boolean):void => {
        this.refreshFlag = true;

        //Always keep the orderNumber filter.
        if (this.getCollectionByView(this.getView()) && this.getCollectionByView(this.getView()).baseEntityName == "OrderFulfillment"){
            var filterMap = new Map<String, any>();
            filterMap.set("partial", this.filters['partial']);
            filterMap.set("available", this.filters['available']);
            filterMap.set("unavailable", this.filters['unavailable']);
            filterMap.set("location", this.filters['location']);
            filterMap.set("paid", this.filters['paid']);
            this.createOrderFulfillmentCollectionWithFilterMap(filterMap);
        }else if (this.getCollectionByView(this.getView()).baseEntityName == "OrderItem"){
            console.warn("Adding orderItem Filters", this.getCollectionByView(this.getView()));
        }
        //Calls to auto refresh the collection since a filter was added.

        this.createOrderFulfillmentCollection();
        this.createOrderItemCollection();

        //some view setup.
        this.views = FulfillmentsList.Views;

        this.setView(this.views.Fulfillments);

        //add both collections into the collection object. Removed 0 elements (insert only).
        this.collections.push(this.orderFulfillmentCollection);
        this.collections.push(this.orderItemCollection);

        this.refreshCollectionTotal(this.getCollectionByView(this.getView()));

    }

    /**
     * This applies or removes a location filter from the collection.
     */
    public addLocationFilter = (locationID):void => {
        let currentCollection = this.getCollectionByView(this.getView());
        if (currentCollection && currentCollection.baseEntityName == "OrderFulfillment"){
            //If this is the fulfillment collection, the location is against, orderItems.stock.location
            currentCollection.addFilter("orderFulfillmentItems.stock.location.locationID", locationID, "=");
        }
        if (currentCollection && currentCollection.baseEntityName == "OrderItem"){
            //If this is the fulfillment collection, the location is against, stock.location
            currentCollection.addFilter("stock.location.locationID", locationID, "=");
        }
        
        //this.toggleOrderFulfillmentListing();
        //this.toggleOrderFulfillmentListing();
        this.refreshCollectionTotal(this.getCollectionByView(this.getView()));
    }


    /**
     * Saved the batch using the data stored in the processObject. This delegates to the service method.
     */
    public addBatch = ():void => {
        this.addingBatch = true;
        if (this.getProcessObject()) {
            this.orderFulfillmentService.addBatch(this.getProcessObject()).then(this.processCreateSuccess, this.processCreateError);
        }
    }
    /**
     * Handles a successful post of the processObject
     */
    public processCreateSuccess = (result):void => {
        //Redirect to the created fulfillmentBatch.
        this.addingBatch = false;
        if (result.data && result.data['fulfillmentBatchID']){
            //if url contains /Slatwall use that
            var slatwall = "";
            
            slatwall = this.$hibachi.appConfig.baseURL;
            
            if (slatwall == "") slatwall = "/";
            
            this.$window.location.href = slatwall + "?slataction=entity.detailfulfillmentbatch&fulfillmentBatchID=" + result.data['fulfillmentBatchID'];
        }
    }

    /**
     * Handles a successful post of the processObject
     */
    public processCreateError= (data):void => {
        console.warn("Process Errors", data);
    }

    /**
     * Returns the processObject
     */
    public getProcessObject = ():any => {
        return this.processObject;
    }

    /**
     * Sets the processObject
     */
    public setProcessObject = (processObject):void => {
        this.processObject = processObject;
    }

    /**
     * This will recieve all the notifications from all typeaheads on the page.
     * When I revieve a notification, it will be an object that has a name and data.
     * The name is the name of the form and the data is the selected id. The three types,
     * that I'm currently looking for are:
     * "locationIDfilter", "locationID", or "accountID" These are the same as the names of the forms.
     */
    public recieveNotification = (message): void => {
        
        switch (message.payload.name) {
            case "locationIDfilter":
                //If this is called, then the filter needs to be updated based on this id.
                this.addLocationFilter(message.payload.data);
                break;
            case "locationID":
                //If this is called, then a location for the batch has been selected.
                this.getProcessObject().data['locationID'] = message.payload.data || "";
                break;
            case "accountID":
                //If this is called, then an account to assign to the batch has been selected.
                this.getProcessObject().data['assignedAccountID'] = message.payload.data || "";
                break;
            default:
                console.log("Warning: A default case was hit with the data: ", message);
        }
    }

    /**
     * Returns the number of selected fulfillments
     */
    public getTotalFulfillmentsSelected = ():number => {

        var total = 0;
        if (this.getProcessObject() && this.getProcessObject().data){
            try{
                if (this.getProcessObject().data.orderFulfillmentIDList && this.getProcessObject().data.orderFulfillmentIDList.split(",").length > 0 && this.getProcessObject().data.orderItemIDList && this.getProcessObject().data.orderItemIDList.split(",").length > 0){
                    return this.getProcessObject().data.orderFulfillmentIDList.split(",").length + this.getProcessObject().data.orderItemIDList.split(",").length;
                }
                else if (this.getProcessObject().data.orderFulfillmentIDList && this.getProcessObject().data.orderFulfillmentIDList.split(",").length > 0) {
                    return this.getProcessObject().data.orderFulfillmentIDList.split(",").length;
                }
                else if (this.getProcessObject().data.orderItemIDList && this.getProcessObject().data.orderItemIDList.split(",").length > 0){
                    return this.getProcessObject().data.orderItemIDList.split(",").length;
                }else{
			return 0;
		}

            } catch (error){
                return 0; //default
            }
        }
    }
}

/**
 * This is a view helper class that uses the collection helper class.
 */
class SWOrderFulfillmentList implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public scope = {}

    public bindToController = {
        customOrderFulfillmentCollectionConfig:'=?',
        customOrderItemCollectionConfig:'=?'
    }
    public controller=SWOrderFulfillmentListController;
    public controllerAs="swOrderFulfillmentListController";

    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            slatwallPathBuilder,
            orderFulfillmentPartialsPath
		) => new SWOrderFulfillmentList (
            slatwallPathBuilder,
            orderFulfillmentPartialsPath
		);
		directive.$inject = [
            'slatwallPathBuilder',
            'orderFulfillmentPartialsPath'
		];
		return directive;
	}
    // @ngInject
    constructor(
        slatwallPathBuilder,
        orderFulfillmentPartialsPath
    ){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderFulfillmentPartialsPath) + "orderfulfillmentlist.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
    SWOrderFulfillmentListController,
	SWOrderFulfillmentList
};
