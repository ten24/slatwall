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
component extends="Slatwall.meta.tests.unit.entity.SlatwallEntityTestBase" {

// @hint put things in here that you want to run befor EACH test
	public void function setUp() {
		super.setup();

		variables.entity = request.slatwallScope.getService("workflowService").newWorkflow();
	}


	private void function createDummySkus(numeric qnt = 5, string uniqueProductIdentifier = 'dummyData'){
		var productData = {
			productID = '',
			productName = 'ProductUnitTest',
			productDescription = arguments.uniqueProductIdentifier,
			skus = []
		};

		for(var i = 1;  i <= arguments.qnt; i++){
			arrayAppend(productData.skus, {
				skuID = '',
				price = '1337',
				skuCode = createUUID()
			});
		}
		createPersistedTestEntity('product', productData);
	}



	/**
	* @test
	*/
	public void function ScheduledWorkflowAndEntityQueueProcessingTest() {

		// Mock process Method
		request.slatwallScope.getService("skuService").processSku_workflowtest = function(required any sku, required struct data = {}){
			return sku;
		};

		// Mock Workflow Data;
		var workflowData = {
			workflowID = '',
			activeFlag = true,
			workflowName = 'My test Workflow',
			workflowObject = 'Sku',
			workflowTasks = [{
				workflowTaskID = '',
				activeFlag = true,
				taskName = 'Dummy Task',
				taskConditionsConfig = '{"filterGroups":[{"filterGroup":[]}],"baseEntityAlias":"Sku","baseEntityName":"Sku"}',
				workflowTaskActions = [{
					workflowTaskActionID = '',
					actionType = 'process',
					processMethod = 'processSku_workflowtest',
					emailTemplate = ''
				}]
			}],
			workflowTriggers = []
		};
		// Create workflow Object
		var workflow = createPersistedTestEntity('Workflow', workflowData);

		assert(arraylen(workflow.getWorkflowTasks()));


		// Mock Workflow Trigger Data to run now.
		var workflowTriggerData = {
			workflowTriggerID = '',
			triggerType = 'Schedule',
			objectPropertyIdentifier = '',
			triggerEvent = '',
			triggerEventTitle = '',
			startDateTime = DateAdd("d", -1, Now()),
			nextRunDateTime = dateAdd('n', -1, now())
		};
		// Create Workflow Trigger Object
		var workflowTrigger = createPersistedTestEntity('WorkflowTrigger', workflowTriggerData);


		// Mock Schedule Data to run every 5 minutes
		var scheduleData = {
			scheduleID = '',
			scheduleName = 'Dummy Schedule',
			recuringType = 'daily',
			frequencyInterval = '5',
			frequencyStartTime = '#dateAdd('d', -1, now())#',
			frequencyEndTime = '#dateAdd('d', 1, now())#'
		};
		// Create Schedule Object
		var schedule = createPersistedTestEntity('Schedule', scheduleData);
		workflowTrigger.setSchedule(schedule);

		var collection = request.slatwallScope.getService("skuService").getSkuCollectionList();

		var uniqueProductDescription = createUUID();

		// Create a Product with 50 Skus
		createDummySkus(50,uniqueProductDescription);

		//Add Filter By our new product
		collection.setDisplayProperties('skuID');
		collection.addFilter('product.productDescription', uniqueProductDescription);

		//Assert Sku was created
		assert(collection.getRecordsCount() == 50);

		var collectionData = {
			collectionID = '',
			collectionName = 'Dummy Collection',
			collectionObject = 'Sku',
			collectionConfig = serializeJSON(collection.getCollectionConfigStruct())
		};

		// Create Collection Object
		var collection = createPersistedTestEntity('Collection', collectionData);

		//set the collection to
		workflowTrigger.setScheduleCollection(collection);

		// Add Workflow Trigger to Workflow
		workflow.addWorkflowTrigger(workflowTrigger);

		//Asset Workflow Triggers
		assert(arraylen(workflow.getWorkflowTriggers()));

		request.slatwallScope.getService("workflowService").runWorkflowTriggerById(workflowTrigger.getWorkflowTriggerID());


		var queueCollection = request.slatwallScope.getService("hibachiEntityQueueService").getEntityQueueCollectionList();
		queueCollection.addFilter('workflowTrigger.workflowTriggerID', workflowTrigger.getWorkflowTriggerID());

		// Should have 50 items in the queue
		assert(queueCollection.getRecordsCount() == 50);


		// START QUEUE PROCESSING LOGIC

		var totalQueueCollection = request.slatwallScope.getService("hibachiEntityQueueService").getEntityQueueCollectionList();
		queueCollection.addFilter('processingFlag', false);
		var totalQueueBeforeRun = totalQueueCollection.getRecordsCount();


		var queueHistoryCollection = request.slatwallScope.getService("hibachiEntityQueueService").getEntityQueueHistoryCollectionList();
		var historyQueueBeforeRun = queueHistoryCollection.getRecordsCount();

		request.slatwallScope.getService("workflowService").runWorkflowTriggerById('0089415672933e4687bbb92af51cbd04');

		threadjoin();

		//Make sure 5 items was removed from QUEUE
		var totalQueueAfterRun = totalQueueCollection.getRecordsCount(true);
		assert(totalQueueBeforeRun - totalQueueAfterRun == 5);

		//Make Sure 5 Items was added to Queue History
		var historyQueueAfterRun = queueHistoryCollection.getRecordsCount(true);
		assert(historyQueueAfterRun - historyQueueBeforeRun == 5);

	}





}


