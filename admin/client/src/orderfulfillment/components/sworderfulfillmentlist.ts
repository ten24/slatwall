/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

module FulfillmentsList {
    export enum Views {
        Fulfillments,
        Items
    }
} 

class SWOrderFulfillmentListController {
    
    private orderFulfillmentCollection:any;
    private orderItemCollection:any;
    private orderCollectionConfig:any;
    private orderFulfillments:any[];
    private filters:{};
    private view:number;
    private collections:Array<any>;
    
    public views:any;
    public total:number;
    public formData:{};
    public processObject:any;

    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService){
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

        //Attach observerService
        var handler = function(){
            console.log("Handler Called");
        };
        console.log(this.observerService);
        this.observerService.attach(handler, "swSelectionToggleSelection", "swOrderFulfillmentListener");
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
         location.reload();
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
        if (this.getProcessObject()) {
            console.log("Hibachi", this.$hibachi);
            console.log("Process Object", this.getProcessObject());

        }
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