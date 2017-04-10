/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import * as Prototypes from '../prototypes/Observable';

module FulfillmentsList {
    export enum Views {
        Fulfillments,
        Items
    }
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
    
    public views:any;
    public total:number;
    public formData:{};
    public processObject:any;

    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService){
        
        //Set the initial state for the filters.
        this.filters = { "unavailable": false, "partial": true, "available": true };
        this.collections = [];
        
        //Some setup for the fulfillments collection.
        this.createOrderFulfillmentCollection(collectionConfigService);
        this.createOrderItemCollection(collectionConfigService);

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
        this.refreshCollection(this.getCollectionByView(this.getView()));

        //Attach our listeners for selections on both listing displays.
        console.log(this.observerService);
        this.observerService.attach(this.swSelectionToggleSelectionorderFulfillmentCollectionTableListener, "swSelectionToggleSelectionorderFulfillmentCollectionTable", "swSelectionToggleSelectionorderFulfillmentCollectionTableListener");
        this.observerService.attach(this.swSelectionToggleSelectionorderItemCollectionTableListener, "swSelectionToggleSelectionorderItemCollectionTable", "swSelectionToggleSelectionorderItemCollectionTableListener");
        this.typeaheadService.attachTypeaheadSelectionUpdateEvent("orderFulfillment", (data)=>{
            console.log("Data", data);
        });
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
     * Add Instance Of string to list
     */
    public listAppend = (str, subStr) => {
        let isNew = false;
        if (!str) {
            str = "";
            isNew = true;
        }
        if (subStr){
            str = str + ((isNew)? "" : ",") + subStr;
        }
        return str;
    }
    
    /**
     * Removes a string from a string.
     */
     public listRemove = (str, subStr) => {
        if (str.indexOf(subStr) != -1){
            //remove it cause its no longer selected.
            str = str.replace(subStr, "");
            str = str.replace(",,", "");
            if (str == ","){
                str = "";
            }
            if (str[0] == ","){
                str[0] = "";
            }
            str = str.substring(0, str.length-1);
        }

        return str;
    }

    /**
     * returns true if the action is selected
     */
    public isSelected = (test) => {
        if (test == "check") { return true; } else { return false };
    }

    /**
     * Each collection has a view. The view is maintained by the enum. This Returns
     * the collection for that view.
     */
     public getCollectionByView = (view:number) => {
        if (view == undefined || this.collections == undefined){
            return;
        }
        
        return this.collections[view];
     }

    /**
     * Setup the initial orderFulfillment Collection.
     */
     private createOrderFulfillmentCollection = (collectionConfigService) => {
        this.orderFulfillmentCollection = collectionConfigService.newCollectionConfig("OrderFulfillment");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime");
        this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName");
        this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentInvStatusType.typeName");
        this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.typeName", "Fulfilled", "!=");
        this.orderFulfillmentCollection.addFilter("order.orderNumber", null, "!=");
     }
    
    /**
     * Setup the initial orderItem Collection.
     */
    private createOrderItemCollection = (collectionConfigService) => {
        this.orderItemCollection = collectionConfigService.newCollectionConfig("OrderItem");
        this.orderItemCollection.addDisplayProperty("orderItemID");
        this.orderItemCollection.addDisplayProperty("quantity");
        this.orderItemCollection.addDisplayProperty("order.orderNumber");
        this.orderItemCollection.addDisplayProperty("order.orderOpenDateTime");
        this.orderItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentStatusType.typeName");
        this.orderItemCollection.addDisplayProperty("sku.product.productName");
        this.orderItemCollection.addFilter("orderFulfillment.orderFulfillmentStatusType.typeName", "Fulfilled", "!=");
        this.orderItemCollection.addFilter("orderFulfillment.orderFulfillmentID", null, "!=");
        this.orderItemCollection.addFilter("order.orderNumber", null, "!=");
    }

    /**
     * Toggle the Status Type filters on and off.
     */
    toggleFilter = (filterName) => {
        this.filters[filterName] = !this.filters[filterName];
        this.addFilter(filterName, this.filters[filterName]);
    }

    /**
     * Toggle between views. We refresh the collection everytime we set the view.
     */
    public setView = (view:number) => {
        this.view = view;
        if (this.getCollectionByView(this.getView())){
            this.refreshCollection(this.getCollectionByView(this.getView()));
        }
    }

    /**
     * Returns the current view.
     */
    public getView = () => {
        return this.view;
    }

    /**
     * Initialized the collection so that the listingDisplay can you it to display its data.
     */
    public refreshCollection = (collection) => {
        if (collection){
            collection.getEntity().then((response)=>{
                if (!response || response.pageRecords == undefined || response.pageRecords.length == 0){
                   this.redirect();
                }else{
                    collection = response.pageRecords;
                    this.total = response.recordsCount;
                }
            });
        }
    }

    /**
     * Redirects the current page (to go to login) if the user tries to interacts with the view while not logged in.
     */
    public redirect = () => {
         this.$location.reload();
    }

    /**
     * Adds one of the status type filters into the collectionConfigService
     * Keys: String['Partial', 'Available', 'Unavailable']
     * Value: Boolean: {true|false}
     */
    public addFilter = (key, value) => {
        //Always keep the orderNumber filter.
        var currentCollection = this.getCollectionByView(this.getView());
        if (currentCollection && currentCollection.baseEntityName == "OrderFulfillment"){
            console.log(currentCollection);
            currentCollection.addFilter("orderFulfillmentStatusType.typeName", "Fulfilled", "!=");
            if (value == true){
                currentCollection.addFilter("order.orderNumber", null, "!=");
                if (key == "partial"){
                    currentCollection.addFilter("orderFulfillmentInvStatusType.typeName","Partial",true,"OR",false,true,false);
                }
                if (key == "available"){
                    currentCollection.addFilter("orderFulfillmentInvStatusType.typeName","Available",true,"OR",false,true,false);
                }
                if (key == "unavailable"){
                    currentCollection.addFilter("orderFulfillmentInvStatusType.typeName","Unavailable",true,"OR",false,true,false);
                }
                if (key == "location"){
                    currentCollection.addFilter("orderFulfillmentItems.stock.location.locationName", value);
                }
            }
        }else if (currentCollection.baseEntityName == "OrderItem"){
            console.log("Adding orderItem Filters", currentCollection);
        }
        //Calls to auto refresh the collection since a filter was added.
        this.refreshCollection(this.getCollectionByView(this.getView()));
    }

    /**
     * Saved the batch using the data stored in the processObject.
     */
    public addBatch = () => {
        //if we have formData, then pass that formData to the createBatch process.
        //This needs to go into the service once its created..
        if (this.getProcessObject()) {
            console.log("Hibachi", this.$hibachi);
            console.log("Process Object", this.getProcessObject());
            //this.orderFulfillmentService.addBatch(this.getBatchProcess());
            this.getProcessObject().data.entityName = "FulfillmentBatch";
            this.getProcessObject().data.serviceName = "fulfillment";//service is different then fulfillmentBatchService so must define.
            this.getProcessObject().data.processContext = "create";
            this.getProcessObject().data['fulfillmentBatch'] = {};
            this.getProcessObject().data['fulfillmentBatch']['fulfillmentBatchID'] = "";

            //get the locationID and the assigned account id if they exist.
            this.getProcessObject().data['assignedAccountID'] = $("input[name=accountID]").val() || "";
            this.getProcessObject().data['locationID'] = $("input[name=locationID]").val() || "";

            //This goes to service.
            this.$http.post("/?slataction=api:main.doProcess", this.getProcessObject().data, {})
                .then(this.processCreateSuccess, this.processCreateError)
        }
    }
     /**
     * Handles a successful post of the processObject
     */
    public processCreateSuccess = (result) => {
        console.log("Process Created", result);
        //Redirect to the created fulfillmentBatch.
        this.$window.location.href = "/?slataction=entity.detailfulfillmentbatch&fulfillmentBatchID=" + result.data['FulfillmentBatch']['FulfillmentBatchID'];
    }

    /**
     * Handles a successful post of the processObject
     */
    public processCreateError= (data) => {
        console.log("Process Errors", data);
    }

    /**
     * Returns the processObject
     */
    public getProcessObject = () => {
        return this.processObject;
    }

    /**
     * Sets the processObject
     */
    public setProcessObject = (processObject) => {
        this.processObject = processObject;
    }

    /**
     * This will recieve all the notifications from the observer service.
     */
    public recieveNotification = (message): void => {
        console.log("Message Recieved: ", message);
        switch (message.type) {
            case "batchSaveSuccess": break;
            case "batchSaveFail": break;
            case "error": break;
        }
    }

    /**
     * Returns the number of selected fulfillments
     */
    public getTotalFulfillmentsSelected = () => {
        try{
            return this.getProcessObject().data.orderFulfillmentIDList.split(",").length;
        } catch (error){
            return 0;
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
    }
    public controller=SWOrderFulfillmentListController;
    public controllerAs="swOrderFulfillmentListController";
     
    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			orderFulfillmentPartialsPath,
			slatwallPathBuilder
		) => new SWOrderFulfillmentList (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			orderFulfillmentPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
            '$hibachi', 
            '$timeout', 
            'collectionConfigService',
            'observerService',
			'orderFulfillmentPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private orderFulfillmentPartialsPath, slatwallPathBuilder){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderFulfillmentPartialsPath) + "orderfulfillmentlist.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{  
    }
}

export {
    SWOrderFulfillmentListController,
	SWOrderFulfillmentList
};