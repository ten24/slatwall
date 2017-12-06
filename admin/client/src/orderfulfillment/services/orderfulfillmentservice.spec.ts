/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />

import {coremodule} from "../../../../../org/Hibachi/client/src/core/core.module";
import {HibachiService} from "../../../../../org/Hibachi/client/src/core/services/hibachiservice";
import {collectionmodule} from "../../../../../org/Hibachi/client/src/collection/collection.module";
import {CollectionConfig} from "../../../../../org/Hibachi/client/src/collection/services/collectionconfigservice";
import {orderfulfillmentmodule} from "../orderfulfillment.module";
import {OrderFulfillmentService} from "../services/orderfulfillmentservice";
import * as actions from '../../fulfillmentbatch/actions/fulfillmentbatchactions';

describe('FulfillmentService Test Suite',()=>{
	var orderFulfillmentService:OrderFulfillmentService;
    var $httpBackend:ng.IHttpBackendService;
	var collectionConfigService:any;
	var $hibachi:any;

	beforeEach(angular.mock.module(orderfulfillmentmodule.name));
	beforeEach(angular.mock.module(collectionmodule.name));
    beforeEach(()=>{
        angular.mock.inject((_orderFulfillmentService_)=>{
            // The injector unwraps the underscores (_) from around the parameter names when matching
            orderFulfillmentService = _orderFulfillmentService_;
        });
		angular.mock.inject((_$hibachi_)=>{
            // The injector unwraps the underscores (_) from around the parameter names when matching
            $hibachi = _$hibachi_;
        });
    });

	//This service is observable so need to test those methods.
    it('Toggle Fulfillment Listing Action Test', ()=>{
	   var testState = {
			expandedFulfillmentBatchListing: ""
	   };

	   //Subscribe to state changes.
	   orderFulfillmentService.orderFulfillmentStore.store$.subscribe((stateChanges)=>{
            //Handle basic requests
            if ( (stateChanges.action && stateChanges.action.type) && stateChanges.action.type == actions.TOGGLE_BATCHLISTING){
                //set the new state.
                testState = stateChanges;
            }

	   });

	   //Toggle the listing via the action and then check the state
	   orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.TOGGLE_BATCHLISTING,
            payload: {}
       });

	   expect(testState.expandedFulfillmentBatchListing).toBe(false); //Default is true so toggle should cause it to be false.

	   orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.TOGGLE_BATCHLISTING,
            payload: {}
	   });

	   expect(testState.expandedFulfillmentBatchListing).toBe(true); //Was toggled to  false so expect true.

	});

	//This service is observable so need to test those methods.
    it('Toggle Loader Test', ()=>{
	   var testState = {
			loading: ""
	   };

	   //Subscribe to state changes.
	   orderFulfillmentService.orderFulfillmentStore.store$.subscribe((stateChanges)=>{
            //Handle basic requests
            if ( (stateChanges.action && stateChanges.action.type) && stateChanges.action.type == actions.TOGGLE_LOADER){
                //set the new state.
                testState = stateChanges;
            }

	   });

	   //Toggle the listing via the action and then check the state
	   orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.TOGGLE_LOADER,
            payload: {}
       });

	   expect(testState.loading).toBe(true); //Default is false so toggle should cause it to be true.

	   orderFulfillmentService.orderFulfillmentStore.dispatch({
            type: actions.TOGGLE_LOADER,
            payload: {}
	   });

	   expect(testState.loading).toBe(false); //Was toggled to true so expect false.

	});


	//This is the main method that saves the batch so its important to test
    it('addBatch test', ()=>{
	   var processObject = $hibachi.newFulfillmentBatch_Create();
	   expect(processObject.data).toBeDefined();

	   var successCallback = function(result){
			console.log(result);
			expect(result).toBeDefined;
	   };
	   var errorCallback = function(result){
			expect(result).not.toBeDefined();
	   };

	   orderFulfillmentService.addBatch(processObject).then(successCallback, errorCallback);

    });


});