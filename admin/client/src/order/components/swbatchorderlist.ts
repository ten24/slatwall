/**
 * Order List Controller
 */
class SWBatchOrderListController {
    private orderImportBatchItemCollection:any;
    private orderImportBatchItemCollectionConfig:any;
    private orders:any[];
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
    public ordersList;
    public customOrderImportBatchItemCollectionConfig:string;
    public orderImportBatchId:string;
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
            private orderService,
            private listingService
        ){

        //Set the initial state for the filters.
        this.collections = [];

        //Some setup for the fulfillments collection.
        this.createOrderImportBatchItemCollection();
        this.orderImportBatchItemCollectionConfig = this.orderImportBatchItemCollection;
        //Setup the processObject
        this.setProcessObject(this.$hibachi.newOrderImportBatch_Process());

        this.orderImportBatchItemCollection = this.refreshCollectionTotal(this.orderImportBatchItemCollection);

        //Attach our listeners for selections on listing display.
        this.observerService.attach(this.swSelectionToggleSelectionorderImportBatchItemCollectionTableListener, "swSelectionToggleSelectionorderImportBatchItemCollectionTable", "swSelectionToggleSelectionorderImportBatchItemCollectionTableListener");
        this.observerService.attach(this.collectionConfigUpdatedListener, "collectionConfigUpdated", "collectionConfigUpdatedListener");

    }

     private getBaseCollection = ():any=>{
        var collection = this.collectionConfigService.newCollectionConfig('OrderImportBatchItem');
        if(this.customOrderImportBatchItemCollectionConfig){
            collection.loadJson(this.customOrderImportBatchItemCollectionConfig);
        }
        return collection;
     }


    /**
     * Implements a listener for the order selections
     */
    public swSelectionToggleSelectionorderImportBatchItemCollectionTableListener = (callBackData) => {
        let processObject = this.getProcessObject();
        if (this.isSelected(callBackData.action)){
             processObject['data']['orderImportBatchItemIDList'] = this.listAppend(processObject.data['orderImportBatchItemIDList'], callBackData.selection);
        }else{
             processObject['data']['orderImportBatchItemIDList'] = this.listRemove(processObject.data['orderImportBatchItemIDList'], callBackData.selection);
        }
        this.setProcessObject(processObject);
    };

    public collectionConfigUpdatedListener = (callBackData) => {
        if (this.usingRefresh == true){
            this.refreshFlag=true;
        }
    };

    public orderImportBatchItemCollectionTablepageRecordsUpdatedListener = (callBackData) => {
        if (callBackData){
            this.refreshCollectionTotal(this.orderImportBatchItemCollection);
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
        return test == "check";
     }

    /**
     * Setup the initial orderFulfillment Collection.
     */
     private createOrderImportBatchItemCollection = ():void => {
        this.orderImportBatchItemCollection = this.getBaseCollection();
        this.orderImportBatchItemCollection.setDisplayProperties('orderImportBatchItemStatusType.typeName,originalOrderNumber,accountNumber,skuCode,quantity,name,streetAddress,street2Address,city,stateCode,locality,postalCode,countryCode,phoneNumber');
        this.orderImportBatchItemCollection.addDisplayProperty('orderImportBatchItemID','orderImportBatchItemID',{isVisible:false});
        this.orderImportBatchItemCollection.addFilter("orderImportBatchItemStatusType.systemCode", "oibistNew", "=");
        this.orderImportBatchItemCollection.addFilter("orderImportBatch.orderImportBatchID", this.orderImportBatchId, "=");
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
     * Saved the batch using the data stored in the processObject. This delegates to the service method.
     */
    public process = ():void => {
        this.addingBatch = true;
        if (this.getProcessObject()) {
            this.processObject.data.entityID=this.orderImportBatchId;
            this.orderService.placeOrderImportBatchOrders(this.getProcessObject()).then(this.processCreateSuccess, this.processCreateError);
        }
    }
    
    public deleteOrders = ():void => {
        
    }
    /**
     * Handles a successful post of the processObject
     */
    public processCreateSuccess = (result):void => {
        //Redirect to the created fulfillmentBatch.
        this.addingBatch = false;
        if (result.data && result.data['orderImportBatchID']){
            //if url contains /Slatwall use that
            var slatwall = "";

            slatwall = this.$hibachi.appConfig.baseURL;

            if (slatwall == "") slatwall = "/";

            this.$window.location.href = slatwall + "?slataction=entity.detailorderimportbatch&orderImportBatchID=" + result.data['orderImportBatchID'];
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
     * Returns the number of selected items
     */
    public getTotalOrdersSelected = ():number => {

        var total = 0;
        if (this.getProcessObject() && this.getProcessObject().data){
            try{
                if (this.getProcessObject().data.orderImportBatchItemIDList && this.getProcessObject().data.orderImportBatchItemIDList.split(",").length > 0) {
                    return this.getProcessObject().data.orderImportBatchItemIDList.split(",").length;
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
class SWBatchOrderList implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public scope = {}

    public bindToController = {
        customOrderImportBatchItemCollectionConfig:'=?',
        orderImportBatchId:'@'
    }
    public controller=SWBatchOrderListController;
    public controllerAs="swBatchOrderListController";

    public static Factory():ng.IDirectiveFactory{
        var directive:ng.IDirectiveFactory = (
		    orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        ) => new SWBatchOrderList(
			orderPartialsPath,
			slatwallPathBuilder,
			$hibachi,
			rbkeyService
        );
        directive.$inject = [
			'orderPartialsPath',
			'slatwallPathBuilder',
			'$hibachi',
			'rbkeyService'
        ];
        return directive;
    }

	constructor(private orderPartialsPath, 
				private slatwallPathBuilder, 
				private $hibachi,
				private rbkeyService
	){
		this.templateUrl = slatwallPathBuilder.buildPartialsPath(orderPartialsPath) + "/batchorderlist.html";
	}

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
    SWBatchOrderListController,
	SWBatchOrderList
};