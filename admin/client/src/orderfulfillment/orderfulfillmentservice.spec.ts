import {SWOrderFulfillmentService} from "./services/orderfulfillmentservice";

describe('fulfillmentService Test',()=>{
	var fulfillmentService:SWOrderFulfillmentService;
    var $httpBackend:ng.IHttpBackendService;

    beforeEach(()=>{
        angular.mock.inject((_fulfillmentService_)=>{
            // The injector unwraps the underscores (_) from around the parameter names when matching
            fulfillmentService = _fulfillmentService_;
        });
    });
	
	//This service is observable so need to test those methods.
    it('observable test', ()=>{
	   var messageTest = false;
	   var mockObserver = {
		   recieveNotification: function(message){ messageTest = message; }
	   };
	   fulfillmentService.registerObserver(mockObserver);
	   fulfillmentService.notifyObservers("This is a test message");
	   expect(fulfillmentService.observers.length).toBe(1);
       expect(messageTest).toEqual("This is a test message"); //This proves the register and notify have been called.

	   //Now remove the observer.
	   var messageTest = false;
	   fulfillmentService.removeObserver(mockObserver);
	   fulfillmentService.notifyObservers("This is a test message"); //Won't get called because no observers exist.
	   expect(messageTest).not.toEqual("This is a test message"); //This proves the remove removed the observer.
	   expect(fulfillmentService.observers.length).toBe(0);

    });

});