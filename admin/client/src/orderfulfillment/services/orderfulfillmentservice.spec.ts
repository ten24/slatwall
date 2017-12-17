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
	
			beforeEach(
				()=>{
					var $rootScope = {};
					orderFulfillmentService = new OrderFulfillmentService(new ObserverService(timeout, HistoryService, UtilityService), HibachiService, CollectionConfig, ListingService, $rootScope, SelectionService);
				}
			);
	
			inject(function (_$filter_, _$httpBackend_, _$timeout_) {
				$httpBackend = _$httpBackend_;
				timeout = _$timeout_;
			});
	
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

			});

			
	
			
});
	