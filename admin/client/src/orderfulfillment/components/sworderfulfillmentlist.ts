/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWOrderFulfillmentListController {
    
    private orderFulfillmentCollection:any;
    private orderCollectionConfig:any;
    private orderFulfillments:any[];
    private filters:{};
    public total:number;

    
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService){
        //Some setup
        this.filters = {"unavailable": false, "partial": true, "available": true};
        this.orderFulfillmentCollection = collectionConfigService.newCollectionConfig("OrderFulfillment");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentID");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderNumber");
        this.orderFulfillmentCollection.addDisplayProperty("order.orderOpenDateTime");
        this.orderFulfillmentCollection.addDisplayProperty("shippingMethod.shippingMethodName");
        this.orderFulfillmentCollection.addDisplayProperty("shippingAddress.stateCode");
        this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentInvStatusType.typeName");
        this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.typeName", "fulfilled", "=");
        this.orderFulfillmentCollection.addFilter("order.orderNumber", null, "!=");

        //adds the two default filters to start.
        //this.addFilter('available', true);
        //this.addFilter('partial', true);
    }
    
    /**
     * Toggle the Status Type filters on and off.
     */
    toggleFilter = (filterName) => {
        this.filters[filterName] = !this.filters[filterName];
        this.addFilter(filterName, this.filters[filterName]);
    }

    /**
     * Initialized the orderFulfillment collection so that the listingDisplay can you it to display its data.
     */
    public refreshCollection = () => {
        this.orderFulfillmentCollection.getEntity().then((response)=>{
            this.orderFulfillments = response.pageRecords;
            this.total = response.recordsCount;
        });
    }

    /**
     * Adds one of the status type filters into the collectionConfigService
     * Keys: String['Partial', 'Available', 'Unavailable']
     * Value: Boolean: {true|false}
     */
    public addFilter = (key, value) => {
        console.log("Add Filter Called With", key, value);
        //Always keep the orderNumber filter.
        this.orderFulfillmentCollection.addFilter("order.orderNumber", null, "!=");
        this.orderFulfillmentCollection.addFilter("orderFulfillmentStatusType.typeName", "fulfilled", "=");
        if (key == "partial"){
            this.orderFulfillmentCollection.addFilter("orderFulfillmentInvStatusType.typeName","Partial",(value==true)?"=":"!=","OR",false,true,false);
        }
        if (key == "available"){
            this.orderFulfillmentCollection.addFilter("orderFulfillmentInvStatusType.typeName","Available",(value==true)?"=":"!=","OR",false,true,false);
        }
        if (key == "unavailable"){
            this.orderFulfillmentCollection.addFilter("orderFulfillmentInvStatusType.typeName","Unavailable",(value==true)?"=":"!=","OR",false,true,false);
        }
        if (key == "location"){
            this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.stock.location.locationName", value);
        }
        //Calls to auto refresh the collection since a filter was added.
        this.refreshCollection();
    }

}

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