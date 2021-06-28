/*

    Slatwall - An Open Source eCommerce Platform
    Copyright (C) ten24, LLC

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.

    Linking this program statically or dynamically with other modules is
    making a combined work based on this program.  Thus, the terms and
    conditions of the GNU General Public License cover the whole
    combination.

    As a special exception, the copyright holders of this program give you
    permission to combine this program with independent modules and your
    custom code, regardless of the license terms of these independent
    modules, and to copy and distribute the resulting program under terms
    of your choice, provided that you follow these specific guidelines:

	- You also meet the terms and conditions of the license of each
	  independent module
	- You must not alter the default display of the Slatwall name or logo from
	  any part of the application
	- Your custom code must not alter or create any files inside Slatwall,
	  except in the following directories:
		/integrationServices/

	You may copy and distribute the modified version of this program that meets
	the above guidelines as a combined work under the terms of GPL for this program,
	provided that you include the source code of that other code when and as the
	GNU GPL requires distribution of source code.

    If you modify this program, you may extend this exception to your version
    of the program, but you are not obligated to do so.

Notes:

*/
component extends="Slatwall.meta.tests.unit.SlatwallUnitTestBase" {

	// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();
		variables.fulfillmentService = request.slatwallScope.getBean("fulfillmentService");
	}
	
	public void function createFulfillmentBatchTest(){
		
		//Get the process object to send to the service
		var fulfillmentBatch = request.slatwallScope.newEntity( 'fulfillmentBatch' );
		fulfillmentBatch.setFulfillmentBatchID("123456");
		var processObject = fulfillmentBatch.getProcessObject( 'Create' );
		
		//Find a random location id to use for population
		var locationID = request.slatwallScope.getService("LocationService").getLocationCollectionList().getRecords()[1]['locationID'];
		var location = request.slatwallScope.getService("LocationService").getLocationByLocationID(locationID);
		
		//Find a random account id to use for population
		var accountID = request.slatwallScope.getService("AccountService").getAccountCollectionList().getRecords()[1]['accountID'];
		var account = request.slatwallScope.getService("AccountService").getAccountByAccountID(accountID);
		var description = "This is a fulfillment batch description";
		
		//Get some random orderFulfillments from Slatwall to use
		var orderFulfillmentsForTesting = [];
		for (var i = 0; i<=5; i++){
			data = {
				orderFulfillmentID: "#now()#12345678-" & i
			};
			var orderFulfillment = createPersistedTestEntity("OrderFulfillment", data);
			arrayAppend(orderFulfillmentsForTesting, orderFulfillment);
		}
		//Create the orderFulfillmentIDList;
		orderFulfillmentIDList = "";
		for (var orderFulfillment in orderFulfillmentsForTesting){
			orderFulfillmentIDList = orderFulfillmentIDList & "," & orderFulfillment.getOrderFulfillmentID();
		}
		
		//***Testing that the service methods are working to populate the final object based on passed in data. 
		
		var data = {
			"locationIDList": location.getLocationID(),
			"assignedAccountID": account.getAccountID(),
			"description": "This is another test description",
			"orderFulfillmentIDList": orderFulfillmentIDList
		};
		
		//populate the data.
		processObject.populate(data);
		processObject.setOrderFulfillmentIDList(data.orderFulfillmentIDList);
		
		//Get the service method
		var fulfillmentService = variables.fulfillmentService;
		
		//Pass in the fulfillment batch and the process.
		var fb = fulfillmentService.processFulfillmentBatch_create(fulfillmentBatch, processObject);
		
		assert(!isNull(fb), "The fulfillmentBatch should not be null");
		
		assertIsArray(fb.getFulfillmentBatchItems(), "The array of batch items exists");
		
		assert(arraylen(fb.getFulfillmentBatchItems()) > 0, "It has at least 1 fulfillment batch item");
		
		assertSame(fb.getDescription(), data.description, "It should have the populated simple description");
		
		assertSame(fb.getAssignedAccountID(), data.assignedAccountID, "It should have populated a assigned account");
		
		assertSame(processObject.getAssignedAccount().getAccountID(), data.assignedAccountID, "It should have an assigned account ID and the ids should match");
		
		assertSame(fb.getLocations()[1].getLocationID(), data.locationIDList, "It should have a location id that matches the passed in locationID");
		
	}
}
