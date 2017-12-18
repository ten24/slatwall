/// <reference path='../../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../../org/Hibachi/client/typings/tsd.d.ts' />

import {coremodule} from "../../../../../org/Hibachi/client/src/core/core.module";
import {slatwalladminmodule} from "../../../../../admin/client/src/slatwall/slatwalladmin.module";
import {HibachiService} from "../../../../../org/Hibachi/client/src/core/services/hibachiservice";
import {collectionmodule} from "../../../../../org/Hibachi/client/src/collection/collection.module";
import {CollectionConfig} from "../../../../../org/Hibachi/client/src/collection/services/collectionconfigservice";
import {orderfulfillmentmodule} from "../orderfulfillment.module";
import {OrderFulfillmentService} from "../services/orderfulfillmentservice";
import {ListingService} from "../../../../../org/Hibachi/client/src/listing/services/listingservice";
import {SelectionService} from "../../../../../org/Hibachi/client/src/core/services/selectionservice";
import {HistoryService} from "../../../../../org/Hibachi/client/src/core/services/historyservice";
import {UtilityService} from "../../../../../org/Hibachi/client/src/core/services/utilityservice";
import {ObserverService} from "../../../../../org/Hibachi/client/src/core/services/observerservice";
import * as actions from '../../fulfillmentbatch/actions/fulfillmentbatchactions';

describe("Order Fulfillment Service Tests", () => {
	
			var orderFulfillmentService : any;
			var observerService : ObserverService;
			var $httpBackend: any;
			var timeout: any;
			var $rootScope;
			var entitySaveMock;
			var $hibachi;
			
			
			beforeEach(inject(function($injector) {
				// Set up the mock http service responses
				$httpBackend = $injector.get('$httpBackend');
				$rootScope = $injector.get('$rootScope');
				
				//Mock hibachi service next using the injector methods.
				orderFulfillmentService = new OrderFulfillmentService(new ObserverService(timeout, HistoryService, UtilityService), HibachiService, CollectionConfig, ListingService, $rootScope, SelectionService);
			
				// backend definition common for all tests
				entitySaveMock = $httpBackend.when('POST', 'http://cf10.slatwall/?slatAction=api:main.getInstantiationKey')
									   .respond({userId: 'userX'}, {'instantiationKey': '1234543212345432123454321'});
		   

			}));

			it("Constructor should initialize correctly", () => {
				expect(orderFulfillmentService.orderFulfillmentStore).toBeDefined();
				expect(orderFulfillmentService).toBeDefined();
			});
			
			describe("Actions should call the correct function", () => {
				it("SETUP_BATCHDETAIL should call setupFulfillmentBatchDetail", () => {
					
					spyOn(orderFulfillmentService, "setupFulfillmentBatchDetail");
					var state = {};
					var action = {
						type: "SETUP_BATCHDETAIL",
						payload: {}
					};
					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					expect(orderFulfillmentService.setupFulfillmentBatchDetail).toHaveBeenCalled();
				});

				it("SAVE_COMMENT_REQUESTED should call saveComment", () => {
					
					spyOn(orderFulfillmentService, "saveComment");
					var state = {};
					var action = {
						type: "SAVE_COMMENT_REQUESTED",
						payload: {
							comment: {
								comment: "This is a comment",
								commentID: "123456789"
							},
							commentText: "This is the comment"
						}
					};
					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					expect(orderFulfillmentService.saveComment).toHaveBeenCalled();
				});

				it("DELETE_COMMENT_REQUESTED should call deleteComment", () => {
					
					spyOn(orderFulfillmentService, "deleteComment");
					var state = {};
					var action = {
						type: "DELETE_COMMENT_REQUESTED",
						payload: {
							comment: {
								comment: "This is a comment",
								commentID: "123456789"
							},
							commentText: "This is the comment"
						}
					};
					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					expect(orderFulfillmentService.deleteComment).toHaveBeenCalled();
				});

				it("CREATE_FULFILLMENT_REQUESTED should call fulfillItems", () => {
					
					spyOn(orderFulfillmentService, "fulfillItems");
					var state = {};
					var action = {
						type: "CREATE_FULFILLMENT_REQUESTED",
						payload: {
							viewState: {}
						}
					};
					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					expect(orderFulfillmentService.fulfillItems).toHaveBeenCalled();
				});

				it("SETUP_ORDERDELIVERYATTRIBUTES should call createOrderDeliveryAttributeCollection", () => {
					
					spyOn(orderFulfillmentService, "createOrderDeliveryAttributeCollection");
					var state = {};
					var action = {
						type: "SETUP_ORDERDELIVERYATTRIBUTES",
						payload: {
							viewState: {}
						}
					};
					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					expect(orderFulfillmentService.createOrderDeliveryAttributeCollection).toHaveBeenCalled();
				});

			});

			describe("Actions should update the state", () => {
				it("TOGGLE_FULFILLMENT_LISTING should toggle the state variable called showFulfillmentListing", () => {
					var state = {};

					var action = {
						type: "TOGGLE_FULFILLMENT_LISTING"
					};

					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					//showFulfillmentListing starts off as true, so this should be false after toggling once.
					expect(orderFulfillmentService.state.showFulfillmentListing).toEqual(false);

					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					//showFulfillmentListing starts off as true, so this should be true after toggling twice.
					expect(orderFulfillmentService.state.showFulfillmentListing).toEqual(true);

				});

				it("TOGGLE_BATCHLISTING should toggle the state variable called expandedFulfillmentBatchListing", () => {
					var state = {};

					var action = {
						type: "TOGGLE_BATCHLISTING"
					};

					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					//showFulfillmentListing starts off as true, so this should be false after toggling once.
					expect(orderFulfillmentService.state.expandedFulfillmentBatchListing).toEqual(false);

					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					//showFulfillmentListing starts off as true, so this should be true after toggling twice.
					expect(orderFulfillmentService.state.expandedFulfillmentBatchListing).toEqual(true);
					
				});

				it("TOGGLE_LOADER should toggle the state variable called loading", () => {
					var state = {};

					var action = {
						type: "TOGGLE_LOADER"
					};

					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					
					//showFulfillmentListing starts off as true, so this should be false after toggling once.
					expect(orderFulfillmentService.state.loading).toEqual(true);

					orderFulfillmentService.orderFulfillmentStateReducer(state, action);
					//showFulfillmentListing starts off as true, so this should be true after toggling twice.
					expect(orderFulfillmentService.state.loading).toEqual(false);
					
				})
			});

			describe("Store should maintain the state", () => {
				it("emitUpdateToClient should dispatch to the store", () => {
					var state = {};
	
					var action = {
						type: "TOGGLE_LOADER"
					};
	
					spyOn(orderFulfillmentService.orderFulfillmentStore, "dispatch");
					
					orderFulfillmentService.emitUpdateToClient();
					
					expect(orderFulfillmentService.orderFulfillmentStore.dispatch).toHaveBeenCalled();
					
				})
			});

			describe("Saving an entity using $hibachi.saveEntity should make a http call", () => {
				it("addBatch should save the fulfillment batch", () => {
					var state = {};
	
					var action = {
						type: "TOGGLE_LOADER"
					};
					$httpBackend.expectPOST('http://cf10.slatwall/?slatAction=api:main.get').respond(201, '');
					console.log($httpBackend);
					//orderFulfillmentService.addBatch({data: {entityName: "FulfillmentBatch"}});
					
				})
			});
			
	
			
});
	