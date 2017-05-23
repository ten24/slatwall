/// <reference path='../../../typings/slatwallTypescript.d.ts' />
/// <reference path='../../../typings/tsd.d.ts' />

import {Observable} from 'rxjs/Observable';

type ActionName = "toggle" | "refresh";

/**
 * Fulfillment Batch Detail Controller
 */
class SWFulfillmentBatchDetailController  {
    
    public state;
    public fulfillmentBatchId: string;
    
    // @ngInject
    constructor(private $hibachi, private $timeout, private collectionConfigService, private observerService, private utilityService, private $location, private $http, private $window, private typeaheadService, private listingService, private orderFulfillmentService, private rbkeyService){
        //setup a state change listener and send over the fulfillmentBatchID
        this.orderFulfillmentService.orderFulfillmentStore.store$.subscribe((stateChanges)=>{
            //We only care about the state changes for fulfillmentBatchDetail right now.
            
            if (stateChanges.action && stateChanges.action.type && stateChanges.action.type == "FULFILLMENT_BATCH_DETAIL_SETUP"){
                //GET the state.
                this.state = stateChanges;
            }
            if ( (stateChanges.action && stateChanges.action.type) && stateChanges.action.type == "FULFILLMENT_BATCH_DETAIL_UPDATE"){
                //GET the state.
                this.state = stateChanges;
            }
            if ( (stateChanges.action && stateChanges.action.type) && (stateChanges.action.type == "EDIT_COMMENT_TOGGLE" || stateChanges.action.type == "SAVE_COMMENT_ACTION" || stateChanges.action.type == "DELETE_COMMENT_ACTION")){
                //GET the state.
                this.state = stateChanges;
            }
            //If there has been a change to the state because of the listing, update as well.

        });
        //Dispatch the fulfillmentBatchID and setup the state.
        this.userViewingFulfillmentBatchDetail(this.fulfillmentBatchId);

    }
    
    /** This is an action called thats says we need to initialize the fulfillmentBatch detail. */
    public userViewingFulfillmentBatchDetail = (batchID) => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "FULFILLMENT_BATCH_DETAIL_SETUP",
            payload: {fulfillmentBatchId: batchID }
        });
    }

    /** This is an action called thats says we need to initialize the fulfillmentBatch detail. */
    public userToggleFulfillmentBatchListing = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "TOGGLE_FULFILLMENT_BATCH_LISTING",
            payload: {}
        });
    }

    public userEditingComment = (comment) => {
        console.log(comment);
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "EDIT_COMMENT_TOGGLE",
            payload: {comment: comment}
        });
    }

    public userDeletingComment = (comment) => {
        //Only fire the event if the user agrees.
        let warning = this.rbkeyService.getRBKey("entity.comment.delete.confirm");
        if ( window.confirm(`${warning}?`) ) {
            this.orderFulfillmentService.orderFulfillmentStore.dispatch({
                type: "DELETE_COMMENT_ACTION",
                payload: {comment: comment}
            });
        }
    }
    
    public userSavingComment = (comment, commentText) => {
        console.log(comment, commentText);
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "SAVE_COMMENT_ACTION",
            payload: {comment: comment, commentText: commentText}
        });
    }

    public userFulfillment = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "FULFILLMENT_ACTION",
            payload: {}
        });
    }

    public userPrintPickingList = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "PRINT_PICKING_LIST_ACTION",
            payload: {}
        });
    }

    public userPrintPackingList = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "PRINT_PACKING_LIST_ACTION",
            payload: {}
        });
    }

    public userEmailCancellation = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "SEND_EMAIL_CANCELLATION_ACTION",
            payload: {}
        });
    }

    public userEmailConfirmation = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "SEND_EMAIL_CONFIRMATION_ACTION",
            payload: {}
        });
    }

    public userEmailOrderStatus = () => {
         this.orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: "SEND_EMAIL_ORDER_STATUS_ACTION",
            payload: {}
        });
    }

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
