/**
 * Order List Controller
 */
class SWOrderListController {
    private orderCollection:any;
    private orderCollectionConfig:any;
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
    public customOrderCollectionConfig:string;
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
        this.createOrderCollection();
        this.orderCollectionConfig = this.orderCollection;
        //Setup the processObject
        this.setProcessObject(this.$hibachi.newVolumeRebuildBatch_Create());

        this.orderCollection = this.refreshCollectionTotal(this.orderCollection);

        //Attach our listeners for selections on listing display.
        this.observerService.attach(this.swSelectionToggleSelectionorderCollectionTableListener, "swSelectionToggleSelectionorderCollectionTable", "swSelectionToggleSelectionorderCollectionTableListener");
        this.observerService.attach(this.collectionConfigUpdatedListener, "collectionConfigUpdated", "collectionConfigUpdatedListener");

    }
    
     private getBaseCollection = ():any=>{
        var collection = this.collectionConfigService.newCollectionConfig('Order');
        if(this.customOrderCollectionConfig){
            collection.loadJson(this.customOrderCollectionConfig);
        }
        return collection;
     }
    

    /**
     * Implements a listener for the order selections
     */
    public swSelectionToggleSelectionorderCollectionTableListener = (callBackData) => {
        let processObject = this.getProcessObject();
        if (this.isSelected(callBackData.action)){
             processObject['data']['orderIDList'] = this.listAppend(processObject.data['orderIDList'], callBackData.selection);
        }else{
             processObject['data']['orderIDList'] = this.listRemove(processObject.data['orderIDList'], callBackData.selection);
        }
        this.setProcessObject(processObject);
    };

    public collectionConfigUpdatedListener = (callBackData) => {
        if (this.usingRefresh == true){
            this.refreshFlag=true;
        }
    };

    public orderCollectionTablepageRecordsUpdatedListener = (callBackData) => {
        if (callBackData){
            this.refreshCollectionTotal(this.orderCollection);
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
     private createOrderCollection = ():void => {
        this.orderCollection = this.getBaseCollection();
        this.orderCollection.addDisplayProperty("orderID", "ID");
        this.orderCollection.addDisplayProperty("orderType.systemCode", "Order Type");
        this.orderCollection.addDisplayProperty("orderNumber", "Order Number");
        this.orderCollection.addDisplayProperty("account.calculatedFullName", "Full Name");
        this.orderCollection.addDisplayProperty("orderOpenDateTime", "Date Started");;
        this.orderCollection.addDisplayProperty("orderStatusType.typeName", "Status");
        this.orderCollection.addFilter("orderStatusType.systemCode", "ostNotPlaced", "!=");
        this.orderCollection.addFilter("orderNumber", "", "!=");
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
    public addBatch = ():void => {
        this.addingBatch = true;
        if (this.getProcessObject()) {
            this.orderService.addVolumeRebuildBatch(this.getProcessObject()).then(this.processCreateSuccess, this.processCreateError);
        }
    }
    /**
     * Handles a successful post of the processObject
     */
    public processCreateSuccess = (result):void => {
        //Redirect to the created fulfillmentBatch.
        this.addingBatch = false;
        if (result.data && result.data['volumeRebuildBatchID']){
            //if url contains /Slatwall use that
            var slatwall = "";
            
            slatwall = this.$hibachi.appConfig.baseURL;
            
            if (slatwall == "") slatwall = "/";
            
            this.$window.location.href = slatwall + "?slataction=entity.detailvolumerebuildbatch&volumeRebuildBatchID=" + result.data['volumeRebuildBatchID'];
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
     * Returns the number of selected fulfillments
     */
    public getTotalOrdersSelected = ():number => {

        var total = 0;
        if (this.getProcessObject() && this.getProcessObject().data){
            try{
                if (this.getProcessObject().data.orderIDList && this.getProcessObject().data.orderIDList.split(",").length > 0 && this.getProcessObject().data.orderItemIDList && this.getProcessObject().data.orderItemIDList.split(",").length > 0){
                    return this.getProcessObject().data.orderIDList.split(",").length + this.getProcessObject().data.orderItemIDList.split(",").length;
                }
                else if (this.getProcessObject().data.orderIDList && this.getProcessObject().data.orderIDList.split(",").length > 0) {
                    return this.getProcessObject().data.orderIDList.split(",").length;
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
class SWOrderList implements ng.IDirective{

    public templateUrl;
    public restrict = "EA";
    public scope = {}

    public bindToController = {
        customOrderCollectionConfig:'=?'
    }
    public controller=SWOrderListController;
    public controllerAs="swOrderListController";

    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            slatwallPathBuilder,
            monatBasePath
		) => new SWOrderList (
            slatwallPathBuilder,
            monatBasePath
		);
		directive.$inject = [
            'slatwallPathBuilder',
            'monatBasePath'
		];
		return directive;
	}
    // @ngInject
    constructor(
        slatwallPathBuilder,
        monatBasePath
    ){
        this.templateUrl = monatBasePath + "/monatadmin/components/rebuildorderlist.html";
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{
    }
}

export {
    SWOrderListController,
	SWOrderList
};
