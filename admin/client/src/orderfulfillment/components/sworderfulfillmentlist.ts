/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />
import * as Prototypes from '../../../../../org/hibachi/client/src/core/prototypes/Observable';

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
    export type CollectionFilterValue =  "partial"|"available"|"unavailable"|"location";
} 

/**
 * Fulfillment List Controller
 */
class SWOrderFulfillmentListController implements Prototypes.Observable.IObserver {
    private orderFulfillmentCollection:any;
    private orderItemCollection:any;
    private orderCollectionConfig:any;
    private orderFulfillments:any[];
    private filters:{};
    private view:number;
    private collections:any;
    private refreshFlag:boolean;
    
    public views:any;
    public total:number;
    public formData:{};
    public processObject:any;

    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private orderFulfillmentService){

        //Set the initial state for the filters.
        this.filters = { "unavailable": false, "partial": true, "available": true };
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
        
        //This tells the typeaheadService to send us all of its events to our recieveNotification method.
        this.typeaheadService.registerObserver(this);
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
        this.orderFulfillmentCollection = this.collectionConfigService.newCollectionConfig("OrderFulfillment");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime");
        this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName");
        this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentStatusType.typeName");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentItems.stock.location.locationID");
        this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.systemCode", "ofstFulfilled", "!=");
        this.orderFulfillmentCollection.addFilter("order.orderNumber", "", "!=");
     }
    
    /**
     * Setup the initial orderItem Collection.
     */
    private createOrderItemCollection = ():void => {
        this.orderItemCollection = this.collectionConfigService.newCollectionConfig("OrderItem");
        this.orderItemCollection.addDisplayProperty("orderItemID");
        this.orderItemCollection.addDisplayProperty("quantity");
        this.orderItemCollection.addDisplayProperty("order.orderNumber");
        this.orderItemCollection.addDisplayProperty("order.orderOpenDateTime");
        this.orderItemCollection.addDisplayProperty("orderFulfillment.orderFulfillmentStatusType.typeName");
        this.orderItemCollection.addDisplayProperty("sku.product.productName");
        this.orderItemCollection.addFilter("orderFulfillment.orderFulfillmentStatusType.systemCode", "ofstFulfilled", "!=");
        this.orderItemCollection.addFilter("order.orderNumber", "", "!=");
    }

    /**
     * Toggle the Status Type filters on and off.
     */
    public toggleFilter = (filterName):void => {
        this.filters[filterName] = !this.filters[filterName];
        this.addFilter(filterName, this.filters[filterName]);
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
            console.log("MultiPageMode");
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
            });
            return collection;
        }

    }

    /**
     * Adds one of the status type filters into the collectionConfigService
     * @param key: FulfillmentsList.CollectionFilterValues {'partial' | 'available' | 'unavailable' | 'location'}
     * @param Vvalue: boolean: {true|false}
     */
    
    public addFilter = (key:FulfillmentsList.CollectionFilterValue, value:boolean):void => {
        //Always keep the orderNumber filter.
        if (this.getCollectionByView(this.getView()) && this.getCollectionByView(this.getView()).baseEntityName == "OrderFulfillment"){
            
            //If there is only one filter group add a second. otherwise add to the second.
            var filterGroup = [];
            var filter = {};
            
            if (value == true){
                
                if (key == "partial"){
                    filter = this.getCollectionByView(this.getView()).createFilter("orderFulfillmentInvStatusType.systemCode","ofisPartial","=","OR",false);
                }
                if (key == "available"){
                    filter = this.getCollectionByView(this.getView()).createFilter("orderFulfillmentInvStatusType.systemCode","ofisAvailable","=","OR",false);
                }
                if (key == "unavailable"){
                    filter = this.getCollectionByView(this.getView()).createFilter("orderFulfillmentInvStatusType.systemCode","ofisUnavailable","=","OR",false);
                }
                if (key == "location"){
                     filter = this.getCollectionByView(this.getView()).createFilter("orderFulfillmentItems.stock.location.locationName", value, "=","OR",false);
                }
                //add the filter to the group
                filterGroup.push(filter);
                //add the group
                this.getCollectionByView(this.getView()).addFilterGroup(filterGroup);

            }
            if (value = false){
                console.log("False");
            }
        }else if (this.getCollectionByView(this.getView()).baseEntityName == "OrderItem"){
            console.log("Adding orderItem Filters", this.getCollectionByView(this.getView()));
        }
        //Calls to auto refresh the collection since a filter was added.
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
        this.refreshCollectionTotal(currentCollection);
    }

    /**
     * Saved the batch using the data stored in the processObject. This delegates to the service method.
     */
    public addBatch = ():void => {
        if (this.getProcessObject()) {
            this.orderFulfillmentService.addBatch(this.getProcessObject()).then(this.processCreateSuccess, this.processCreateError);
        }
    }
    /**
     * Handles a successful post of the processObject
     */
    public processCreateSuccess = (result):void => {
        //Redirect to the created fulfillmentBatch.
        if (result.data && result.data['fulfillmentBatchID']){
            this.$window.location.href = "/?slataction=entity.detailfulfillmentbatch&fulfillmentBatchID=" + result.data['fulfillmentBatchID'];
        }
    }

    /**
     * Handles a successful post of the processObject
     */
    public processCreateError= (data):void => {
        console.log("Process Errors", data);
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
        
        switch (message.name) {
            case "locationIDfilter": 
                //If this is called, then the filter needs to be updated based on this id.
                this.addLocationFilter(message.data);
                break;
            case "locationID":
                //If this is called, then a location for the batch has been selected.
                this.getProcessObject().data['locationID'] = message.data || "";
                break;
            case "accountID":
                //If this is called, then an account to assign to the batch has been selected.
                this.getProcessObject().data['assignedAccountID'] = message.data || "";
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