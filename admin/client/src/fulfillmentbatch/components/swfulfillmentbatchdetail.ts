/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import * as actions from '../actions/fulfillmentbatchactions';

/**
 * Fulfillment Batch Detail Controller
 */
class SWFulfillmentBatchDetailController  {
    
    public state;
    public orderItem = {};
    public fulfillmentBatchId: string;
    
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private listingService, private orderFulfillmentService, private rbkeyService){
       
        //setup a state change listener and send over the fulfillmentBatchID
        this.orderFulfillmentService.orderFulfillmentStore.store$.subscribe((stateChanges)=>{
            
            //Handle basic requests
            if ( (stateChanges.action && stateChanges.action.type) && (
                stateChanges.action.type == actions.TOGGLE_EDITCOMMENT || 
                stateChanges.action.type == actions.SAVE_COMMENT_REQUESTED || 
                stateChanges.action.type == actions.DELETE_COMMENT_REQUESTED || 
                stateChanges.action.type == actions.CREATE_FULFILLMENT_REQUESTED || 
                stateChanges.action.type == actions.PRINT_LIST_REQUESTED || 
                stateChanges.action.type == actions.EMAIL_LIST_REQUESTED || 
                stateChanges.action.type == actions.UPDATE_BATCHDETAIL || 
                stateChanges.action.type == actions.SETUP_BATCHDETAIL || 
                stateChanges.action.type == actions.SETUP_ORDERDELIVERYATTRIBUTES ||
                stateChanges.action.type == actions.TOGGLE_LOADER)){
                //set the new state.
                this.orderItem = {};
                this.state = stateChanges;
            }

        });

        //Get the attributes to display in the custom section.
        this.userViewingOrderDeliveryAttributes();

        //Dispatch the fulfillmentBatchID and setup the state.
        this.userViewingFulfillmentBatchDetail(this.fulfillmentBatchId);

    }
    
    public userViewingFulfillmentBatchDetail = (batchID) => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.SETUP_BATCHDETAIL,
            payload: {fulfillmentBatchId: batchID }
        });
    }

    public userToggleFulfillmentBatchListing = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.TOGGLE_BATCHLISTING,
            payload: {}
        });
    }
    
    //toggle_editcomment for action based
    public userEditingComment = (comment) => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.TOGGLE_EDITCOMMENT,
            payload: {comment: comment}
        });
    }
    
    //requested | failed | succeded
    public userDeletingComment = (comment) => {
        //Only fire the event if the user agrees.
        this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.DELETE_COMMENT_REQUESTED,
            payload: {comment: comment}
        });
    }

    //Try to delete the fulfillment batch item.
    public deleteFulfillmentBatchItem = () => {
        //Only fire the event if the user agrees.
        this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.DELETE_FULFILLMENTBATCHITEM_REQUESTED,
            payload: {}
        });
    }
    
    public userSavingComment = (comment, commentText) => {
        this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.SAVE_COMMENT_REQUESTED,
            payload: {comment: comment, commentText: commentText}
        });
    }

    public userViewingOrderDeliveryAttributes = () => {
        this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.SETUP_ORDERDELIVERYATTRIBUTES,
            payload: {}
        });
    }

    public userCaptureAndFulfill = () => {
        //request the fulfillment process.
        this.state.loading = true;
        this.state.orderItem = this.orderItem;
        
        this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.CREATE_FULFILLMENT_REQUESTED,
            payload: { viewState:this.state }
        });
    }

    public userPrintPickingList = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.PRINT_PICKINGLIST_REQUESTED,
            payload: {}
        });
    }

    public userPrintPackingList = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.PRINT_PACKINGLIST_REQUESTED,
            payload: {}
        });
    }

    /** Returns a list of print templates related to fulfillment batches. */
    public userRequiresPrintList = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.PRINT_LIST_REQUESTED,
            payload: {}
        });
    }

    /** Returns a list of all emails related to orderfulfillments */
    public userRequiresEmailList = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.EMAIL_LIST_REQUESTED,
            payload: {}
        });
    }

    /** Todo - Thiswill be for the barcode search which is currently commented out. */
    public userBarcodeSearch = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "BAR_CODE_SEARCH_ACTION",
            payload: {}
        });
    }
}

/**
 * This is a view helper class that uses the collection helper class.
 */
class SWFulfillmentBatchDetail implements ng.IDirective{

    public templateUrl; 
    public restrict = "EA"; 
    public scope = {}	
    
    public bindToController = {
        fulfillmentBatchId: "@?"
    }

    public controller=SWFulfillmentBatchDetailController;
    public controllerAs="swFulfillmentBatchDetailController";
     
    public static Factory():ng.IDirectiveFactory{
		var directive:ng.IDirectiveFactory = (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			fulfillmentBatchDetailPartialsPath,
			slatwallPathBuilder
		) => new SWFulfillmentBatchDetail (
            $hibachi, 
            $timeout, 
            collectionConfigService,
            observerService,
			fulfillmentBatchDetailPartialsPath,
			slatwallPathBuilder
		);
		directive.$inject = [
            '$hibachi', 
            '$timeout', 
            'collectionConfigService',
            'observerService',
			'fulfillmentBatchDetailPartialsPath',
			'slatwallPathBuilder'
		];
		return directive;
	}
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private fulfillmentBatchDetailPartialsPath, slatwallPathBuilder){
        this.templateUrl = slatwallPathBuilder.buildPartialsPath(fulfillmentBatchDetailPartialsPath) + "fulfillmentbatchdetail.html";	
    }

    public link:ng.IDirectiveLinkFn = ($scope: ng.IScope, element: ng.IAugmentedJQuery, attrs:ng.IAttributes) =>{  
    }
}

export {
    SWFulfillmentBatchDetailController,
	SWFulfillmentBatchDetail
};