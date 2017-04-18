/// <reference path='../../../../org/Hibachi/client/typings/hibachiTypescript.d.ts' />
/// <reference path='../../../../org/Hibachi/client/typings/tsd.d.ts' />

import {coremodule} from "../../../../org/Hibachi/client/src/core/core.module";
import {HibachiService} from "../../../../org/Hibachi/client/src/core/services/hibachiservice";
import {collectionmodule} from "../../../../org/Hibachi/client/src/collection/collection.module";
import {CollectionConfig} from "../../../../org/Hibachi/client/src/collection/services/collectionconfigservice";
import {orderfulfillmentmodule} from "./orderfulfillment.module";
import {OrderFulfillmentService} from "./services/orderfulfillmentservice";

describe('fulfillmentService Test',()=>{
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
    it('observable test', ()=>{
	   var messageTest = false;
	   var mockObserver = {
		   recieveNotification: function(message){ messageTest = message; }
	   };
	   orderFulfillmentService.registerObserver(mockObserver);
	   orderFulfillmentService.notifyObservers("This is a test message");
	   expect(orderFulfillmentService.observers.length).toBe(1);
       expect(messageTest).toEqual("This is a test message"); //This proves the register and notify have been called.

	   //Now remove the observer.
	   var messageTest = false;
	   orderFulfillmentService.removeObserver(mockObserver);
	   orderFulfillmentService.notifyObservers("This is a test message"); //Won't get called because no observers exist.
	   expect(messageTest).not.toEqual("This is a test message"); //This proves the remove removed the observer.
	   expect(orderFulfillmentService.observers.length).toBe(0);

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