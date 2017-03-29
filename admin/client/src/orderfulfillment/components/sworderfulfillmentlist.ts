/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />


class SWOrderFulfillmentListController {
    
    private orderFulfillmentCollection:any;
    private orderCollectionConfig:any;
    private orderFulfillments:any[];
    private filters:{};
    private toggleFilter:any;
    private refreshCollection:any;
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
        //this.orderFulfillmentCollection.addDisplayProperty("orderFulfillmentInventoryStatusType");
        this.orderFulfillmentCollection.addFilter("order.orderNumber", null, "!=");
        

        //Toggle the filter
        this.toggleFilter = (filterName) => {
            this.filters[filterName] = !this.filters[filterName];
            if (this.filters[filterName]){
                addFilter(filterName, true);
            }
        }

        var addFilter = (key, value) => {
            console.log("Add Filter Called With", key, value);
            if (key == "partial"){
                this.orderFulfillmentCollection.addFilterGroup([{
                    propertyIdentifier: "orderFulfillmentInventoryStatusType",
                    comparisonValue: "fefc92c1d8184017aa65cdc882bdf637",
                    comparisonOperator: "=",
                    logicalOperator: "OR",
                    hidden: "false"
                }]);
            }
            if (key == "available"){
                this.orderFulfillmentCollection.addFilterGroup([{
                    propertyIdentifier: "orderFulfillmentInventoryStatusType",
                    comparisonValue: "b718b6fadf084bdaa01e47f5cc1a8266",
                    comparisonOperator: "=",
                    logicalOperator: "OR",
                    hidden: "false"
                }]);
            }
            if (key == "unavailable"){
                this.orderFulfillmentCollection.addFilterGroup([{
                    propertyIdentifier: "orderFulfillmentInventoryStatusType",
                    comparisonValue: "159118d67de3418d9951fc629688e195",
                    comparisonOperator: "=",
                    logicalOperator: "OR",
                    hidden: "false"
                }]);
            }
            if (key == "location"){
                this.orderFulfillmentCollection.addFilter("orderFulfillmentItems.stock.location.locationName", value);
            }
            this.refreshCollection();
        }

        /**
         * Initialized the orderFulfillment collection so that the listingDisplay can you it to display its data.
         */
        this.refreshCollection = () => {
            this.orderFulfillmentCollection.getEntity().then((response)=>{
                console.log("Records" , response);
                this.orderFulfillments = response.pageRecords;
                this.total = response.recordsCount;
            });
        }
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